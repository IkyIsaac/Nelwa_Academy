import 'package:flutter/material.dart';

import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/upload_data.dart';
import '../design/admin_tokens.dart';

/// Same idea as AdminVideoField, for image URLs — shows the actual image
/// instead of a bare link. Upload a file or paste a URL — either way the
/// link itself stays tucked behind a button, not sitting open in a text
/// field.
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
  late String _currentUrl = widget.url;
  bool _uploading = false;

  @override
  void didUpdateWidget(AdminImageField oldWidget) {
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
      allowedExtensions: const ['png', 'jpg', 'jpeg', 'gif', 'webp'],
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
        title: const Text('Image URL'),
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
            aspectRatio: widget.aspectRatio,
            child: Container(
              color: AdminColors.canvas,
              child: _currentUrl.isEmpty
                  ? Center(
                      child: Icon(Icons.image_outlined,
                          color: AdminColors.inkFaint, size: 28),
                    )
                  : Image.network(
                      _currentUrl,
                      key: ValueKey(_currentUrl),
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
                tooltip: 'Remove image',
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
