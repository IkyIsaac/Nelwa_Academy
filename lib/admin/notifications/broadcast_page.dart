import 'package:flutter/material.dart';

import '../design/admin_tokens.dart';
import '../widgets/pending_feature_notice.dart';

const _kNotificationTypes = ['Announcement', 'Promotion', 'Course update'];

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  String _type = _kNotificationTypes.first;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Broadcast notification', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.lg),
        const PendingFeatureNotice(
          reason:
              'Sending to every user means fanning a notification doc out into each user\'s '
              'own subcollection (or wiring up OneSignal — already listed in the Cloud '
              'Functions dependencies but never called). That fan-out has to run server-side '
              'in a Cloud Function, not from this browser tab, so Send stays disabled until '
              'that function exists.',
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(AdminSpace.xl),
          decoration: BoxDecoration(
            color: AdminColors.surface,
            borderRadius: BorderRadius.circular(AdminRadius.lg),
            border: Border.all(color: AdminColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field('Title', _titleController),
              _field('Description', _descriptionController, maxLines: 4),
              Text('TYPE', style: AdminType.eyebrow()),
              const SizedBox(height: AdminSpace.sm),
              DropdownButtonFormField<String>(
                initialValue: _type,
                style: AdminType.body(13, color: AdminColors.ink),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: AdminSpace.md, vertical: AdminSpace.md),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AdminRadius.sm),
                    borderSide: const BorderSide(color: AdminColors.hairline),
                  ),
                ),
                items: _kNotificationTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) => setState(() => _type = value!),
              ),
              const SizedBox(height: AdminSpace.lg),
              _field('Image URL (optional)', _imageController, isLast: true),
              const SizedBox(height: AdminSpace.lg),
              FilledButton.icon(
                onPressed: null,
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Send to all users'),
                style: FilledButton.styleFrom(
                  backgroundColor: AdminColors.oxblood,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AdminRadius.sm)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _field(String label, TextEditingController controller, {int maxLines = 1, bool isLast = false}) {
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
