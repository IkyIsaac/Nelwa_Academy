import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '../design/admin_tokens.dart';
import 'lesson_editor_dialog.dart';

class LessonsSection extends StatelessWidget {
  const LessonsSection({super.key, required this.courseRef});

  final DocumentReference courseRef;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: AdminColors.hairline),
      ),
      child: StreamBuilder<List<LessonsRecord>>(
        stream: queryLessonsRecord(
          parent: courseRef,
          queryBuilder: (q) => q.orderBy('order'),
        ),
        builder: (context, snapshot) {
          final lessons = snapshot.data ?? const <LessonsRecord>[];
          final nextOrder = lessons.isEmpty
              ? 1
              : lessons.map((l) => l.order).reduce((a, b) => a > b ? a : b) + 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AdminSpace.xl, AdminSpace.xl, AdminSpace.xl, AdminSpace.lg),
                child: Row(
                  children: [
                    Text('LESSONS', style: AdminType.eyebrow()),
                    const SizedBox(width: AdminSpace.sm),
                    Text('(${lessons.length})', style: AdminType.mono(12, color: AdminColors.inkFaint)),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () => showLessonEditor(
                        context,
                        courseRef: courseRef,
                        nextOrder: nextOrder,
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add lesson'),
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
              ),
              if (!snapshot.hasData)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AdminSpace.xxl),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (lessons.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AdminSpace.xl, 0, AdminSpace.xl, AdminSpace.xxl),
                  child: Text(
                    'No lessons yet. Add the first one to start building this course.',
                    style: AdminType.body(13, color: AdminColors.inkFaint),
                  ),
                )
              else
                Column(
                  children: [
                    for (final lesson in lessons)
                      _LessonRow(
                        lesson: lesson,
                        courseRef: courseRef,
                        nextOrder: nextOrder,
                      ),
                  ],
                ),
              const SizedBox(height: AdminSpace.sm),
            ],
          );
        },
      ),
    );
  }
}

class _LessonRow extends StatefulWidget {
  const _LessonRow({required this.lesson, required this.courseRef, required this.nextOrder});

  final LessonsRecord lesson;
  final DocumentReference courseRef;
  final int nextOrder;

  @override
  State<_LessonRow> createState() => _LessonRowState();
}

class _LessonRowState extends State<_LessonRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: () => showLessonEditor(
          context,
          courseRef: widget.courseRef,
          existing: lesson,
          nextOrder: widget.nextOrder,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _hovering ? AdminColors.canvas : AdminColors.surface,
            border: const Border(top: BorderSide(color: AdminColors.hairline)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AdminSpace.xl, vertical: AdminSpace.md),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text('${lesson.order}', style: AdminType.mono(13, color: AdminColors.inkFaint)),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(AdminRadius.sm),
                child: Container(
                  width: 56,
                  height: 32,
                  color: AdminColors.ink,
                  child: lesson.image.isNotEmpty
                      ? Image.network(lesson.image, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.play_arrow, color: Colors.white54, size: 16))
                      : const Icon(Icons.play_arrow, color: Colors.white54, size: 16),
                ),
              ),
              const SizedBox(width: AdminSpace.md),
              Expanded(
                child: Text(
                  lesson.title.isEmpty ? 'Untitled lesson' : lesson.title,
                  style: AdminType.body(13, weight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (lesson.isFree) ...[
                StatusPill(label: 'Free', status: AdminStatus.brand),
                const SizedBox(width: AdminSpace.md),
              ],
              SizedBox(
                width: 60,
                child: Text(
                  lesson.duration > 0 ? '${lesson.duration} min' : '—',
                  textAlign: TextAlign.right,
                  style: AdminType.mono(12, color: AdminColors.inkFaint),
                ),
              ),
              const SizedBox(width: AdminSpace.md),
              Icon(Icons.chevron_right, size: 18, color: AdminColors.inkFaint),
            ],
          ),
        ),
      ),
    );
  }
}
