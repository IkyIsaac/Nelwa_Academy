import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';

class CoursesListPage extends StatefulWidget {
  const CoursesListPage({super.key});

  @override
  State<CoursesListPage> createState() => _CoursesListPageState();
}

/// Subcollections hung off a course doc that Firestore won't cascade-delete
/// on its own — anything left here would be reachable by id forever even
/// after the course itself is gone.
const _courseSubcollections = [
  'lessons',
  'courses_review',
  'review_report',
  'lesson_report',
  'courses_report',
];

Future<void> deleteCourse(DocumentReference courseRef) async {
  for (final name in _courseSubcollections) {
    final docs = await courseRef.collection(name).get();
    if (docs.docs.isEmpty) continue;
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in docs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
  await courseRef.delete();
}

class _CoursesListPageState extends State<CoursesListPage> {
  bool _creating = false;

  Future<void> _createCourse() async {
    setState(() => _creating = true);
    final ref = await CoursesRecord.collection.add({
      'title': 'Untitled course',
      'is_published': false,
    });
    if (!mounted) return;
    setState(() => _creating = false);
    context.go('/courses/${ref.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Courses', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.xs),
        Text('Every course, including unpublished drafts.',
            style: AdminType.body(13, color: AdminColors.inkFaint)),
        const SizedBox(height: AdminSpace.xxl),
        AdminDataTable<CoursesRecord>(
          itemsStream: queryCoursesRecord(),
          searchHint: 'Search by title, category, or instructor…',
          searchFilter: (course, query) {
            final q = query.toLowerCase();
            return course.title.toLowerCase().contains(q) ||
                course.category.toLowerCase().contains(q) ||
                course.instructorName.toLowerCase().contains(q);
          },
          statusOf: (course) => course.isPublished ? AdminStatus.positive : AdminStatus.neutral,
          onTap: (course) => context.go('/courses/${course.reference.id}'),
          trailing: FilledButton.icon(
            onPressed: _creating ? null : _createCourse,
            icon: _creating
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.add, size: 16),
            label: Text(_creating ? 'Creating…' : 'Add course'),
            style: FilledButton.styleFrom(
              backgroundColor: AdminColors.oxblood,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AdminRadius.sm)),
            ),
          ),
          columns: [
            AdminColumn<CoursesRecord>(
              label: 'Title',
              flex: 3,
              cellBuilder: (context, course) =>
                  AdminCellText(course.title.isEmpty ? '—' : course.title),
            ),
            AdminColumn<CoursesRecord>(
              label: 'Category',
              flex: 2,
              cellBuilder: (context, course) =>
                  AdminCellText(course.category.isEmpty ? '—' : course.category, muted: true),
            ),
            AdminColumn<CoursesRecord>(
              label: 'Instructor',
              flex: 2,
              cellBuilder: (context, course) =>
                  AdminCellText(course.instructorName.isEmpty ? '—' : course.instructorName, muted: true),
            ),
            AdminColumn<CoursesRecord>(
              label: 'Price',
              flex: 1,
              numeric: true,
              cellBuilder: (context, course) => AdminCellText(course.price.toStringAsFixed(2), mono: true),
            ),
            AdminColumn<CoursesRecord>(
              label: 'Status',
              flex: 2,
              cellBuilder: (context, course) => StatusPill(
                label: course.isPublished ? 'Published' : 'Draft',
                status: course.isPublished ? AdminStatus.positive : AdminStatus.neutral,
              ),
            ),
            AdminColumn<CoursesRecord>(
              label: '',
              flex: 1,
              cellBuilder: (context, course) => _DeleteCourseButton(course: course),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeleteCourseButton extends StatelessWidget {
  const _DeleteCourseButton({required this.course});
  final CoursesRecord course;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Delete course',
      icon: const Icon(Icons.delete_outline_rounded, size: 18),
      color: AdminColors.inkFaint,
      onPressed: () => showDialog(
        context: context,
        builder: (_) => _DeleteCourseDialog(course: course),
      ),
    );
  }
}

class _DeleteCourseDialog extends StatefulWidget {
  const _DeleteCourseDialog({required this.course});
  final CoursesRecord course;

  @override
  State<_DeleteCourseDialog> createState() => _DeleteCourseDialogState();
}

class _DeleteCourseDialogState extends State<_DeleteCourseDialog> {
  bool _confirmed = false;
  bool _deleting = false;
  String? _error;

  Future<void> _delete() async {
    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      await deleteCourse(widget.course.reference);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _deleting = false;
        _error = 'Could not delete the course: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDownloaders = widget.course.downloaders.isNotEmpty;
    return AlertDialog(
      title: const Text('Delete course'),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('"${widget.course.title.isEmpty ? 'Untitled course' : widget.course.title}" '
                'and its lessons will be permanently deleted.'),
            if (hasDownloaders) ...[
              const SizedBox(height: AdminSpace.md),
              Text(
                '${widget.course.downloaders.length} student(s) have this course in their '
                'library — deleting it will leave their purchase pointing at nothing.',
                style: const TextStyle(color: AdminColors.error, fontSize: 13),
              ),
            ],
            const SizedBox(height: AdminSpace.md),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _confirmed,
              onChanged: _deleting ? null : (v) => setState(() => _confirmed = v ?? false),
              title: const Text(
                'I understand this cannot be undone.',
                style: TextStyle(fontSize: 13),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AdminSpace.sm),
              Text(_error!, style: const TextStyle(color: AdminColors.error, fontSize: 13)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AdminColors.error),
          onPressed: (_confirmed && !_deleting) ? _delete : null,
          child: _deleting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Delete course'),
        ),
      ],
    );
  }
}
