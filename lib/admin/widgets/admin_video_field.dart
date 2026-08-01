import 'package:flutter/material.dart';

import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/upload_data.dart';
import '../design/admin_tokens.dart';

/// A video field that actually plays the video it points to, instead of
/// just holding a URL in a text box. Upload a file or paste a URL — either
/// way the link itself stays tucked behind a button, not sitting open in a
/// text field.
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
  late String _currentUrl = widget.url;
  bool _uploading = false;

  @override
  void didUpdateWidget(AdminVideoField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url && widget.url != _currentUrl) {
      _currentUrl = widget.url;
    }
  }

  void _setUrl(String url) {
    setState(() => _currentUrl = url);
    widget.onChanged(url);
  }

  Future<void> _upload() async {
    // selectFile opens the OS/browser file picker directly — no
    // "Choose Source" (Camera/Gallery) sheet, which is a mobile-only
    // concept and doesn't apply here.
    final file = await selectFile(
      storageFolderPath: widget.storageFolder,
      allowedExtensions: const ['mp4', 'mov', 'webm'],
    );
    if (file == null) return;

    setState(() => _uploading = true);
    final path =
        '${widget.storageFolder}/${DateTime.now().millisecondsSinceEpoch}_${file.storagePath.split('/').last}';
    final url = await uploadData(path, file.bytes);
    if (!mounted) return;
    setState(() => _uploading = false);
    if (url != null) _setUrl(url);
  }

  Future<void> _pasteUrl() async {
    final controller = TextEditingController(text: _currentUrl);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video URL'),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AdminType.mono(13),
          decoration: const InputDecoration(hintText: 'https://…'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: AdminColors.oxblood),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) _setUrl(result);
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
              child: _currentUrl.isEmpty
                  ? Center(
                      child: Text(
                        'No video yet',
                        style: AdminType.body(13, color: Colors.white70),
                      ),
                    )
                  : FlutterFlowVideoPlayer(
                      key: ValueKey(_currentUrl),
                      path: _currentUrl,
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
            const SizedBox(width: AdminSpace.sm),
            TextButton.icon(
              onPressed: _pasteUrl,
              icon: const Icon(Icons.link, size: 16),
              label: const Text('Paste URL'),
              style: TextButton.styleFrom(foregroundColor: AdminColors.inkFaint),
            ),
            if (_currentUrl.isNotEmpty) ...[
              const SizedBox(width: AdminSpace.sm),
              IconButton(
                tooltip: 'Remove video',
                onPressed: () => _setUrl(''),
                icon: const Icon(Icons.close, size: 16),
                color: AdminColors.inkFaint,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
