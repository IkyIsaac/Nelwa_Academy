import 'package:flutter/material.dart';

import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/upload_data.dart';
import '../design/admin_tokens.dart';

/// Same idea as AdminVideoField, for image URLs — shows the actual image
/// instead of a bare link, with upload-or-paste-URL either way.
class AdminImageField extends StatefulWidget {
  const AdminImageField({
    super.key,
    required this.label,
    required this.url,
    required this.onChanged,
    required this.storageFolder,
    this.aspectRatio = 16 / 9,
  });

  final String label;
  final String url;
  final ValueChanged<String> onChanged;
  final String storageFolder;
  final double aspectRatio;

  @override
  State<AdminImageField> createState() => _AdminImageFieldState();
}

class _AdminImageFieldState extends State<AdminImageField> {
  late final _urlController = TextEditingController(text: widget.url);
  bool _uploading = false;

  @override
  void didUpdateWidget(AdminImageField oldWidget) {
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
      allowPhoto: true,
      allowVideo: false,
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
            aspectRatio: widget.aspectRatio,
            child: Container(
              color: AdminColors.canvas,
              child: widget.url.isEmpty
                  ? Center(
                      child: Icon(Icons.image_outlined,
                          color: AdminColors.inkFaint, size: 28),
                    )
                  : Image.network(
                      widget.url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          'Could not load image',
                          style: AdminType.body(12, color: AdminColors.inkFaint),
                        ),
                      ),
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
                  hintText: 'Paste an image URL, or upload a file',
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
