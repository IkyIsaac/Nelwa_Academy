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
          ],
        ),
      ],
    );
  }
}
