import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';

/// Values of the users `instructor_status` field. The mobile app sets
/// `pending` when someone submits the "Become an Instructor" form; only the
/// actions on this page grant (or take away) instructor status.
const kInstructorPending = 'pending';
const kInstructorApproved = 'approved';
const kInstructorRejected = 'rejected';
const kInstructorRevoked = 'revoked';

Future<void> approveInstructor(UsersRecord user) async {
  await user.reference.update({
    'instructor': true,
    'role': 'Instructor',
    'instructor_status': kInstructorApproved,
  });
  await _notify(
    user,
    type: 'completed',
    title: 'You are now an instructor',
    description:
        'Your instructor application was approved. Switch your account role to Instructor to start creating courses.',
  );
}

Future<void> rejectInstructor(UsersRecord user) async {
  await user.reference.update({'instructor_status': kInstructorRejected});
  await _notify(
    user,
    type: 'warning',
    title: 'Instructor application not approved',
    description:
        'Your instructor application was not approved this time. You can update your details and apply again from your profile.',
  );
}

Future<void> revokeInstructor(UsersRecord user) async {
  await user.reference.update({
    'instructor': false,
    'role': 'Learner',
    'instructor_status': kInstructorRevoked,
  });
}

Future<void> _notify(
  UsersRecord user, {
  required String type,
  required String title,
  required String description,
}) =>
    NotificationRecord.createDoc(user.reference).set(createNotificationRecordData(
      title: title,
      description: description,
      type: type,
      timeStamp: getCurrentTimestamp,
      seen: false,
    ));

class InstructorApplicationsPage extends StatelessWidget {
  const InstructorApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Instructors', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.xs),
        Text('Review instructor applications and manage who can teach in the app.',
            style: AdminType.body(13, color: AdminColors.inkFaint)),
        const SizedBox(height: AdminSpace.xl),
        Text('PENDING APPLICATIONS', style: AdminType.eyebrow()),
        const SizedBox(height: AdminSpace.md),
        AdminDataTable<UsersRecord>(
          itemsStream: queryUsersRecord(
            queryBuilder: (q) => q.where('instructor_status', isEqualTo: kInstructorPending),
          ),
          searchHint: 'Search applicants…',
          searchFilter: _matchesUser,
          emptyLabel: 'No applications waiting for review.',
          statusOf: (_) => AdminStatus.caution,
          onTap: (user) => _openReview(context, user),
          columns: [
            AdminColumn<UsersRecord>(
              label: 'Name',
              flex: 3,
              cellBuilder: (context, user) =>
                  AdminCellText(user.displayName.isEmpty ? '—' : user.displayName),
            ),
            AdminColumn<UsersRecord>(
              label: 'Email',
              flex: 3,
              cellBuilder: (context, user) => AdminCellText(user.email, muted: true),
            ),
            AdminColumn<UsersRecord>(
              label: 'Joined',
              flex: 2,
              numeric: true,
              cellBuilder: (context, user) => AdminCellText(
                user.hasCreatedTime() ? dateTimeFormat('yMMMd', user.createdTime) : '—',
                mono: true,
                muted: true,
              ),
            ),
            AdminColumn<UsersRecord>(
              label: '',
              flex: 2,
              cellBuilder: (context, user) => Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _openReview(context, user),
                  child: const Text('Review'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AdminSpace.xxl),
        Text('ACTIVE INSTRUCTORS', style: AdminType.eyebrow()),
        const SizedBox(height: AdminSpace.md),
        AdminDataTable<UsersRecord>(
          itemsStream: queryUsersRecord(
            queryBuilder: (q) => q.where('instructor', isEqualTo: true),
          ),
          searchHint: 'Search by name or email…',
          searchFilter: _matchesUser,
          emptyLabel: 'No instructors yet.',
          statusOf: (_) => AdminStatus.brand,
          columns: [
            AdminColumn<UsersRecord>(
              label: 'Name',
              flex: 3,
              cellBuilder: (context, user) =>
                  AdminCellText(user.displayName.isEmpty ? '—' : user.displayName),
            ),
            AdminColumn<UsersRecord>(
              label: 'Email',
              flex: 3,
              cellBuilder: (context, user) => AdminCellText(user.email, muted: true),
            ),
            AdminColumn<UsersRecord>(
              label: 'Specialty',
              flex: 2,
              cellBuilder: (context, user) =>
                  AdminCellText(user.specialty.isEmpty ? '—' : user.specialty, muted: true),
            ),
            AdminColumn<UsersRecord>(
              label: 'Joined',
              flex: 2,
              numeric: true,
              cellBuilder: (context, user) => AdminCellText(
                user.hasCreatedTime() ? dateTimeFormat('yMMMd', user.createdTime) : '—',
                mono: true,
                muted: true,
              ),
            ),
            AdminColumn<UsersRecord>(
              label: '',
              flex: 2,
              cellBuilder: (context, user) => Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: AdminColors.error),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => _RevokeDialog(user: user),
                  ),
                  child: const Text('Revoke'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static bool _matchesUser(UsersRecord user, String query) {
    final q = query.toLowerCase();
    return user.displayName.toLowerCase().contains(q) || user.email.toLowerCase().contains(q);
  }

  static void _openReview(BuildContext context, UsersRecord user) => showDialog(
        context: context,
        builder: (_) => _ReviewDialog(user: user),
      );
}

class _ReviewDialog extends StatefulWidget {
  const _ReviewDialog({required this.user});
  final UsersRecord user;

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog> {
  late final Future<List<InstructorDetailsRecord>> _details =
      queryInstructorDetailsRecordOnce(parent: widget.user.reference);
  bool _saving = false;
  String? _error;

  Future<void> _decide(Future<void> Function(UsersRecord) action) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await action(widget.user);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _saving = false;
        _error = 'Could not save the decision: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return AlertDialog(
      title: Text(user.displayName.isEmpty ? user.email : user.displayName),
      content: SizedBox(
        width: 460,
        child: FutureBuilder<List<InstructorDetailsRecord>>(
          future: _details,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            // Re-applying adds another details doc; any of them is the
            // applicant's own words, so show the most complete one.
            final details = snapshot.data!.isEmpty
                ? null
                : (snapshot.data!..sort((a, b) =>
                        b.aboutInstructor.length.compareTo(a.aboutInstructor.length)))
                    .first;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Field('Email', user.email),
                _Field('Phone', user.phoneNumber),
                _Field('Country', user.country),
                _Field('Specialty', details?.specialty ?? ''),
                _Field('Education', details?.education ?? ''),
                _Field('About', details?.aboutInstructor ?? ''),
                if (_error != null) ...[
                  const SizedBox(height: AdminSpace.sm),
                  Text(_error!, style: const TextStyle(color: AdminColors.error, fontSize: 13)),
                ],
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: AdminColors.error),
          onPressed: _saving ? null : () => _decide(rejectInstructor),
          child: const Text('Reject'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AdminColors.success),
          onPressed: _saving ? null : () => _decide(approveInstructor),
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Approve'),
        ),
      ],
    );
  }
}

class _RevokeDialog extends StatefulWidget {
  const _RevokeDialog({required this.user});
  final UsersRecord user;

  @override
  State<_RevokeDialog> createState() => _RevokeDialogState();
}

class _RevokeDialogState extends State<_RevokeDialog> {
  bool _saving = false;
  String? _error;

  Future<void> _revoke() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await revokeInstructor(widget.user);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _saving = false;
        _error = 'Could not revoke instructor status: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.user.displayName.isEmpty ? widget.user.email : widget.user.displayName;
    return AlertDialog(
      title: const Text('Revoke instructor status'),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$name will be switched back to a learner account and lose access to '
                'instructor tools. Their existing courses are not deleted.'),
            if (_error != null) ...[
              const SizedBox(height: AdminSpace.sm),
              Text(_error!, style: const TextStyle(color: AdminColors.error, fontSize: 13)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AdminColors.error),
          onPressed: _saving ? null : _revoke,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Revoke'),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: AdminType.body(13, color: AdminColors.inkFaint)),
          ),
          Expanded(child: Text(value.isEmpty ? '—' : value, style: AdminType.body(13))),
        ],
      ),
    );
  }
}
