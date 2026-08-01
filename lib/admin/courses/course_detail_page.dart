import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_image_field.dart';
import '../widgets/admin_video_field.dart';
import 'lessons_section.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({super.key, required this.courseId});

  final String courseId;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late Future<CoursesRecord> _courseFuture;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _levelController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _yearPriceController = TextEditingController();
  final _tagsController = TextEditingController();
  final _audienceController = TextEditingController();

  DocumentReference? _courseRef;
  String _imageUrl = '';
  String _videoPreviewUrl = '';
  bool _saving = false;
  bool _isPublished = false;
  String? _saveMessage;

  @override
  void initState() {
    super.initState();
    _courseFuture = _load();
  }

  Future<CoursesRecord> _load() async {
    final ref = CoursesRecord.collection.doc(widget.courseId);
    final course = await CoursesRecord.getDocumentOnce(ref);
    _courseRef = course.reference;
    _titleController.text = course.title;
    _descriptionController.text = course.description;
    _categoryController.text = course.category;
    _levelController.text = course.level;
    _priceController.text = course.price.toString();
    _discountController.text = course.discount.toString();
    _yearPriceController.text = course.yearPrice.toString();
    _tagsController.text = course.tags.join(', ');
    _audienceController.text = course.audience.join(', ');
    _imageUrl = course.image;
    _videoPreviewUrl = course.videoPreview;
    _isPublished = course.isPublished;
    return course;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _levelController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _yearPriceController.dispose();
    _tagsController.dispose();
    _audienceController.dispose();
    super.dispose();
  }

  List<String> _splitList(String value) =>
      value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  Future<void> _save() async {
    if (_courseRef == null) return;
    setState(() {
      _saving = true;
      _saveMessage = null;
    });
    await _courseRef!.update({
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _categoryController.text.trim(),
      'level': _levelController.text.trim(),
      'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
      'discount': double.tryParse(_discountController.text.trim()) ?? 0.0,
      'year_price': double.tryParse(_yearPriceController.text.trim()) ?? 0.0,
      'image': _imageUrl,
      'video_preview': _videoPreviewUrl,
      'tags': _splitList(_tagsController.text),
      'audience': _splitList(_audienceController.text),
    });
    if (!mounted) return;
    setState(() {
      _saving = false;
      _saveMessage = 'Saved.';
    });
  }

  Future<void> _togglePublish() async {
    if (_courseRef == null) return;
    final newValue = !_isPublished;
    await _courseRef!.update({
      'is_published': newValue,
      if (newValue) 'published_date': DateTime.now(),
    });
    if (mounted) setState(() => _isPublished = newValue);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoursesRecord>(
      future: _courseFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error loading course: ${snapshot.error}',
              style: AdminType.body(13, color: AdminColors.error));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _BackButton(onTap: () => context.go('/courses')),
                const SizedBox(width: AdminSpace.md),
                Expanded(
                  child: Text(
                    _titleController.text.isEmpty ? 'Untitled course' : _titleController.text,
                    style: AdminType.display(24, weight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusPill(
                  label: _isPublished ? 'Published' : 'Draft',
                  status: _isPublished ? AdminStatus.positive : AdminStatus.neutral,
                ),
                const SizedBox(width: AdminSpace.md),
                OutlinedButton(
                  onPressed: _togglePublish,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AdminColors.oxblood,
                    side: const BorderSide(color: AdminColors.oxblood),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AdminRadius.sm)),
                  ),
                  child: Text(_isPublished ? 'Unpublish' : 'Publish'),
                ),
              ],
            ),
            const SizedBox(height: AdminSpace.xxl),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 860;
                final fieldsCol = _FieldsColumn(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  categoryController: _categoryController,
                  levelController: _levelController,
                  priceController: _priceController,
                  discountController: _discountController,
                  yearPriceController: _yearPriceController,
                  tagsController: _tagsController,
                  audienceController: _audienceController,
                  onChanged: () => setState(() {}),
                );
                final mediaCol = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminImageField(
                      label: 'Cover image',
                      url: _imageUrl,
                      storageFolder: 'course_images/${widget.courseId}',
                      onChanged: (v) => _imageUrl = v,
                    ),
                    const SizedBox(height: AdminSpace.xl),
                    AdminVideoField(
                      label: 'Preview video',
                      url: _videoPreviewUrl,
                      storageFolder: 'course_previews/${widget.courseId}',
                      onChanged: (v) => _videoPreviewUrl = v,
                    ),
                  ],
                );

                if (!wide) {
                  return Column(children: [mediaCol, const SizedBox(height: AdminSpace.xl), fieldsCol]);
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: fieldsCol),
                    const SizedBox(width: AdminSpace.xxl),
                    Expanded(flex: 2, child: mediaCol),
                  ],
                );
              },
            ),
            const SizedBox(height: AdminSpace.lg),
            Row(
              children: [
                if (_saveMessage != null) ...[
                  Text(_saveMessage!, style: AdminType.body(13, color: AdminColors.success)),
                  const SizedBox(width: AdminSpace.lg),
                ],
                FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AdminColors.oxblood,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AdminRadius.sm)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Save changes', style: AdminType.body(13, weight: FontWeight.w600, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: AdminSpace.xxxl),
            LessonsSection(courseRef: _courseRef!),
          ],
        );
      },
    );
  }
}

class _FieldsColumn extends StatelessWidget {
  const _FieldsColumn({
    required this.titleController,
    required this.descriptionController,
    required this.categoryController,
    required this.levelController,
    required this.priceController,
    required this.discountController,
    required this.yearPriceController,
    required this.tagsController,
    required this.audienceController,
    required this.onChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController levelController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final TextEditingController yearPriceController;
  final TextEditingController tagsController;
  final TextEditingController audienceController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AdminSpace.xl),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: AdminColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _field('Title', titleController, onChanged: onChanged),
          _field('Description', descriptionController, maxLines: 4),
          Row(
            children: [
              Expanded(child: _field('Category', categoryController)),
              const SizedBox(width: AdminSpace.lg),
              Expanded(child: _field('Level', levelController)),
            ],
          ),
          Row(
            children: [
              Expanded(child: _field('Price', priceController)),
              const SizedBox(width: AdminSpace.lg),
              Expanded(child: _field('Discount', discountController)),
              const SizedBox(width: AdminSpace.lg),
              Expanded(child: _field('Yearly price', yearPriceController)),
            ],
          ),
          _field('Tags (comma-separated)', tagsController),
          _field('Audience (comma-separated)', audienceController, isLast: true),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1, bool isLast = false, VoidCallback? onChanged}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AdminSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AdminType.eyebrow()),
          const SizedBox(height: AdminSpace.sm),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: AdminType.body(14),
            onChanged: onChanged == null ? null : (_) => onChanged(),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: AdminSpace.md, vertical: AdminSpace.md),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AdminRadius.sm),
                borderSide: const BorderSide(color: AdminColors.hairline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AdminRadius.sm),
                borderSide: const BorderSide(color: AdminColors.oxblood, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AdminRadius.sm),
      child: Container(
        padding: const EdgeInsets.all(AdminSpace.sm),
        decoration: BoxDecoration(
          border: Border.all(color: AdminColors.hairline),
          borderRadius: BorderRadius.circular(AdminRadius.sm),
        ),
        child: const Icon(Icons.arrow_back, size: 18, color: AdminColors.ink),
      ),
    );
  }
}
