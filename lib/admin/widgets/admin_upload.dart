import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';

import '../design/admin_tokens.dart';

/// Upload state + logic shared by AdminVideoField and AdminImageField.
///
/// Unlike the FlutterFlow `uploadData` helper (a bare `await putData`), this
/// reports byte-level progress, can be cancelled, gives up if no bytes move
/// for [_stallTimeout], and turns failures into a readable message instead
/// of leaving the button spinning forever.
mixin AdminUploadMixin<T extends StatefulWidget> on State<T> {
  static const _stallTimeout = Duration(seconds: 60);

  UploadTask? _task;
  StreamSubscription<TaskSnapshot>? _sub;
  Timer? _stallTimer;
  DateTime _lastProgressAt = DateTime.now();
  bool _stalled = false;

  int uploadBytesSent = 0;
  int uploadBytesTotal = 0;
  String? uploadError;

  bool get uploading => _task != null;

  /// Uploads [data] to [path] and returns its download URL, or null if the
  /// upload failed or was cancelled (in which case [uploadError] says why).
  Future<String?> runUpload(String path, Uint8List data) async {
    setState(() {
      uploadError = null;
      uploadBytesSent = 0;
      uploadBytesTotal = data.length;
      _stalled = false;
    });

    final ref = FirebaseStorage.instance.ref().child(path);
    final task = ref.putData(data, SettableMetadata(contentType: mime(path)));
    setState(() => _task = task);

    // Settle on whichever happens first: the task future, an error or
    // success on the snapshot stream, or the stall watchdog. On web the
    // task future has been seen to never complete after a rejected
    // request, so we can't rely on `await task` alone.
    final done = Completer<String?>();
    void fail(Object e) {
      debugPrint('[AdminUpload] $path failed: $e');
      if (done.isCompleted) return;
      if (mounted) {
        setState(() => uploadError = e is FirebaseException
            ? _describe(e, path)
            : 'Upload failed: $e');
      }
      done.complete(null);
    }

    Future<void> succeed(Reference r) async {
      if (done.isCompleted) return;
      try {
        final url = await r.getDownloadURL();
        if (!done.isCompleted) done.complete(url);
      } catch (e) {
        fail(e);
      }
    }

    _lastProgressAt = DateTime.now();
    _sub = task.snapshotEvents.listen((s) {
      debugPrint('[AdminUpload] ${s.state.name} ${s.bytesTransferred}/${s.totalBytes}');
      if (s.bytesTransferred != uploadBytesSent) {
        _lastProgressAt = DateTime.now();
      }
      if (mounted) {
        setState(() {
          uploadBytesSent = s.bytesTransferred;
          if (s.totalBytes > 0) uploadBytesTotal = s.totalBytes;
        });
      }
      if (s.state == TaskState.success) succeed(s.ref);
      if (s.state == TaskState.error) {
        fail(FirebaseException(plugin: 'firebase_storage', code: 'unknown'));
      }
    }, onError: fail);
    task.then((s) => succeed(s.ref), onError: fail);
    _stallTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (DateTime.now().difference(_lastProgressAt) > _stallTimeout) {
        _stalled = true;
        task.cancel().catchError((_) => false);
        fail(FirebaseException(plugin: 'firebase_storage', code: 'canceled'));
      }
    });

    try {
      return await done.future;
    } finally {
      _cleanup();
      if (mounted) setState(() => _task = null);
    }
  }

  void cancelUpload() {
    final t = _task;
    if (t == null) return;
    t.cancel().catchError((_) => false);
    // Don't wait for the SDK to acknowledge — free the UI immediately.
    _cleanup();
    setState(() {
      _task = null;
      uploadError = 'Upload cancelled.';
    });
  }

  String _describe(FirebaseException e, String path) {
    switch (e.code) {
      case 'canceled':
        return _stalled
            ? 'Upload stalled — no data was sent for ${_stallTimeout.inSeconds}s. '
                'Check your internet connection and try again.'
            : 'Upload cancelled.';
      case 'unauthorized':
      case 'unauthenticated':
        return 'Firebase Storage refused the upload (${e.code}). The Storage '
            'security rules must allow admins to write to '
            '"${path.substring(0, path.lastIndexOf('/'))}/".';
      case 'retry-limit-exceeded':
        return 'Upload kept failing and gave up. Check your internet '
            'connection and try again.';
      case 'quota-exceeded':
        return 'Firebase Storage quota exceeded — check the project\'s billing plan.';
      default:
        return 'Upload failed (${e.code}): ${e.message ?? 'unknown error'}';
    }
  }

  void _cleanup() {
    _stallTimer?.cancel();
    _stallTimer = null;
    _sub?.cancel();
    _sub = null;
  }

  @override
  void dispose() {
    _task?.cancel();
    _cleanup();
    super.dispose();
  }

  /// Progress bar + "42% · 5.4 / 13.0 MB" + Cancel while uploading, or the
  /// error message after a failure. Empty otherwise.
  Widget buildUploadStatus() {
    if (uploading) {
      final total = uploadBytesTotal;
      final fraction = total > 0 ? uploadBytesSent / total : null;
      final pct = fraction == null ? '' : '${(fraction * 100).floor()}% · ';
      return Padding(
        padding: const EdgeInsets.only(top: AdminSpace.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 6,
                      color: AdminColors.oxblood,
                      backgroundColor: AdminColors.hairline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$pct${_mb(uploadBytesSent)} / ${_mb(total)} MB',
                    style: AdminType.body(12, color: AdminColors.inkFaint),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AdminSpace.sm),
            TextButton(
              onPressed: cancelUpload,
              style: TextButton.styleFrom(foregroundColor: AdminColors.inkFaint),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
    if (uploadError != null) {
      return Padding(
        padding: const EdgeInsets.only(top: AdminSpace.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, size: 16, color: AdminColors.error),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                uploadError!,
                style: AdminType.body(12, color: AdminColors.error),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  static String _mb(int bytes) => (bytes / (1024 * 1024)).toStringAsFixed(1);
}
