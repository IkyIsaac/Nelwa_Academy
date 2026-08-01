import 'package:flutter/material.dart';

import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/upload_data.dart';
import '../design/admin_tokens.dart';

/// A video field that actually plays the video it points to, instead of
/// just holding a URL in a text box. Supports pasting a URL directly or
/// uploading a file (which fills the URL in after it lands in Storage).
class AdminVideoField extends StatefulWidget {
  const AdminVideoField({
    super.key,
    required this.label,
    required this.url,
    required this.onChanged,
    required this.storageFolder,
  });

  final String label;
  final String url;
  final ValueChanged<String> onChanged;

  /// Storage folder new uploads for this field are written under, e.g.
  /// `course_previews/<courseId>` or `lesson_videos/<lessonId>`.
  final String storageFolder;

  @override
  State<AdminVideoField> createState() => _AdminVideoFieldState();
}

class _AdminVideoFieldState extends State<AdminVideoField> {
  late final _urlController = TextEditingController(text: widget.url);
  bool _uploading = false;

  @override
  void didUpdateWidget(AdminVideoField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url && widget.url != _urlController.text) {
      _urlController.text = widget.url;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _upload() async {
    final selected = await selectMediaWithSourceBottomSheet(
      context: context,
      allowPhoto: false,
      allowVideo: true,
      storageFolderPath: widget.storageFolder,
    );
    if (selected == null || selected.isEmpty) return;
    final file = selected.first;

    setState(() => _uploading = true);
    final path =
        '${widget.storageFolder}/${DateTime.now().millisecondsSinceEpoch}_${file.storagePath.split('/').last}';
    final url = await uploadData(path, file.bytes);
    if (!mounted) return;
    setState(() => _uploading = false);
    if (url != null) {
      _urlController.text = url;
      widget.onChanged(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label.toUpperCase(), style: AdminType.eyebrow()),
        const SizedBox(height: AdminSpace.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AdminRadius.md),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: AdminColors.ink,
              child: widget.url.isEmpty
                  ? Center(
                      child: Text(
                        'No video yet',
                        style: AdminType.body(13, color: Colors.white70),
                      ),
                    )
                  : FlutterFlowVideoPlayer(
                      key: ValueKey(widget.url),
                      path: widget.url,
                      videoType: VideoType.network,
                      width: double.infinity,
                      height: double.infinity,
                      autoPlay: false,
                      looping: false,
                      showControls: true,
                      allowFullScreen: true,
                    ),
            ),
          ),
        ),
        const SizedBox(height: AdminSpace.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _urlController,
                style: AdminType.mono(12),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Paste a video URL, or upload a file',
                  hintStyle: AdminType.body(12, color: AdminColors.inkFaint),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AdminSpace.md,
                    vertical: AdminSpace.md,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AdminRadius.sm),
                    borderSide: const BorderSide(color: AdminColors.hairline),
                  ),
                ),
                onSubmitted: widget.onChanged,
                onChanged: widget.onChanged,
              ),
            ),
            const SizedBox(width: AdminSpace.sm),
            OutlinedButton.icon(
              onPressed: _uploading ? null : _upload,
              icon: _uploading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_rounded, size: 16),
              label: Text(_uploading ? 'Uploading…' : 'Upload'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AdminColors.oxblood,
                side: const BorderSide(color: AdminColors.oxblood),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AdminRadius.sm),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
