import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_image_field.dart';
import '../widgets/admin_video_field.dart';

Future<void> showLessonEditor(
  BuildContext context, {
  required DocumentReference courseRef,
  LessonsRecord? existing,
  required int nextOrder,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (_) => LessonEditorDialog(
      courseRef: courseRef,
      existing: existing,
      nextOrder: nextOrder,
    ),
  );
}

class LessonEditorDialog extends StatefulWidget {
  const LessonEditorDialog({
    super.key,
    required this.courseRef,
    required this.nextOrder,
    this.existing,
  });

  final DocumentReference courseRef;
  final LessonsRecord? existing;
  final int nextOrder;

  @override
  State<LessonEditorDialog> createState() => _LessonEditorDialogState();
}

class _LessonEditorDialogState extends State<LessonEditorDialog> {
  late final DocumentReference _lessonRef;
  late final _titleController =
      TextEditingController(text: widget.existing?.title ?? '');
  late final _descriptionController =
      TextEditingController(text: widget.existing?.description ?? '');
  late final _durationController = TextEditingController(
      text: widget.existing?.hasDuration() == true
          ? widget.existing!.duration.toString()
          : '');
  late final _orderController = TextEditingController(
      text: (widget.existing?.hasOrder() == true
              ? widget.existing!.order
              : widget.nextOrder)
          .toString());

  String _videoUrl = '';
  String _imageUrl = '';
  bool _isFree = false;
  bool _saving = false;
  bool _deleting = false;

  bool get _isNew => widget.existing == null;

  @override
  void initState() {
    super.initState();
    _lessonRef = widget.existing?.reference ?? LessonsRecord.createDoc(widget.courseRef);
    _videoUrl = widget.existing?.videoUrl ?? '';
    _imageUrl = widget.existing?.image ?? '';
    _isFree = widget.existing?.isFree ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _saving = true);

    final data = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'video_url': _videoUrl,
      'image': _imageUrl,
      'duration': int.tryParse(_durationController.text.trim()) ?? 0,
      'order': int.tryParse(_orderController.text.trim()) ?? widget.nextOrder,
      'is_free': _isFree,
    };

    if (_isNew) {
      await _lessonRef.set(data);
    } else {
      await _lessonRef.update(data);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this lesson?'),
        content: Text('"${widget.existing!.title}" will be removed for every student. This can\'t be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: AdminColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _deleting = true);
    await _lessonRef.delete();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AdminColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AdminRadius.lg)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(AdminSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isNew ? 'New lesson' : 'Edit lesson',
                      style: AdminType.display(20, weight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AdminSpace.lg),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminVideoField(
                        label: 'Video',
                        url: _videoUrl,
                        storageFolder: 'lesson_videos/${_lessonRef.id}',
                        onChanged: (v) => _videoUrl = v,
                      ),
                      const SizedBox(height: AdminSpace.lg),
                      _field('Title', _titleController),
                      _field('Description', _descriptionController, maxLines: 3),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _field('Duration (minutes)', _durationController)),
                          const SizedBox(width: AdminSpace.lg),
                          Expanded(child: _field('Order', _orderController)),
                        ],
                      ),
                      const SizedBox(height: AdminSpace.sm),
                      Row(
                        children: [
                          Switch(
                            value: _isFree,
                            activeThumbColor: AdminColors.oxblood,
                            onChanged: (v) => setState(() => _isFree = v),
                          ),
                          const SizedBox(width: AdminSpace.sm),
                          Text('Free preview lesson', style: AdminType.body(13)),
                        ],
                      ),
                      const SizedBox(height: AdminSpace.lg),
                      AdminImageField(
                        label: 'Thumbnail',
                        url: _imageUrl,
                        storageFolder: 'lesson_images/${_lessonRef.id}',
                        onChanged: (v) => _imageUrl = v,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AdminSpace.xl),
              Row(
                children: [
                  if (!_isNew)
                    TextButton.icon(
                      onPressed: _deleting ? null : _delete,
                      icon: _deleting
                          ? const SizedBox(
                              width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                          : Icon(Icons.delete_outline, size: 16, color: AdminColors.error),
                      label: Text('Delete', style: TextStyle(color: AdminColors.error)),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: AdminType.body(13)),
                  ),
                  const SizedBox(width: AdminSpace.sm),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AdminColors.oxblood,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AdminRadius.sm)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(_isNew ? 'Add lesson' : 'Save changes',
                            style: AdminType.body(13, weight: FontWeight.w600, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AdminSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AdminType.eyebrow()),
          const SizedBox(height: AdminSpace.sm),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: AdminType.body(14),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: AdminSpace.md, vertical: AdminSpace.md),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AdminRadius.sm),
                borderSide: const BorderSide(color: AdminColors.hairline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
