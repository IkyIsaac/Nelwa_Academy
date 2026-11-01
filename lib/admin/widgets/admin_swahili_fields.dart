import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '../design/admin_tokens.dart';

/// Swahili title/description inputs for a course or lesson, with a button
/// that asks the translateText Cloud Function for a machine draft of the
/// English fields. The draft only fills the inputs; the admin still reviews
/// it and saves through the surrounding form.
class AdminSwahiliFields extends StatefulWidget {
  const AdminSwahiliFields({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.titleSwController,
    required this.descriptionSwController,
    this.descriptionLines = 4,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController titleSwController;
  final TextEditingController descriptionSwController;
  final int descriptionLines;

  @override
  State<AdminSwahiliFields> createState() => _AdminSwahiliFieldsState();
}

class _AdminSwahiliFieldsState extends State<AdminSwahiliFields> {
  bool _translating = false;
  String? _message;
  bool _messageIsError = false;

  Future<void> _suggest() async {
    final title = widget.titleController.text.trim();
    final description = widget.descriptionController.text.trim();
    if (title.isEmpty && description.isEmpty) {
      setState(() {
        _message = 'Fill in the English title or description first.';
        _messageIsError = true;
      });
      return;
    }

    final hasExisting = widget.titleSwController.text.trim().isNotEmpty ||
        widget.descriptionSwController.text.trim().isNotEmpty;
    if (hasExisting) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Replace the Swahili text?'),
          content: const Text(
              'The Swahili fields already have text. A suggestion will overwrite it.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Replace')),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    setState(() {
      _translating = true;
      _message = null;
    });
    try {
      final result = await FirebaseFunctions.instance.httpsCallable('translateText').call<dynamic>({
        'texts': [title, description],
        'target': 'sw',
      });
      final translations = List<String>.from((result.data as Map)['translations'] as List);
      if (!mounted) return;
      setState(() {
        if (title.isNotEmpty) widget.titleSwController.text = translations[0];
        if (description.isNotEmpty) widget.descriptionSwController.text = translations[1];
        _translating = false;
        _message = 'Machine draft. Read it through and fix the wording before saving.';
        _messageIsError = false;
      });
    } on FirebaseFunctionsException catch (e) {
      if (!mounted) return;
      setState(() {
        _translating = false;
        _message = e.message ?? 'Could not get a translation.';
        _messageIsError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('SWAHILI (KISWAHILI)', style: AdminType.eyebrow(color: AdminColors.oxblood))),
            TextButton.icon(
              onPressed: _translating ? null : _suggest,
              icon: _translating
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.translate, size: 16, color: AdminColors.oxblood),
              label: Text('Suggest translation', style: AdminType.body(13, color: AdminColors.oxblood)),
            ),
          ],
        ),
        Text(
          'Shown in the app when a learner picks Kiswahili. Leave empty to show the English text.',
          style: AdminType.body(12, color: AdminColors.inkFaint),
        ),
        if (_message != null) ...[
          const SizedBox(height: AdminSpace.sm),
          Text(_message!,
              style: AdminType.body(12, color: _messageIsError ? AdminColors.error : AdminColors.ink)),
        ],
        const SizedBox(height: AdminSpace.md),
        _field('Title (Swahili)', widget.titleSwController),
        const SizedBox(height: AdminSpace.lg),
        _field('Description (Swahili)', widget.descriptionSwController, maxLines: widget.descriptionLines),
      ],
    );
  }

  Widget _field(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminRadius.sm),
              borderSide: const BorderSide(color: AdminColors.oxblood, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
