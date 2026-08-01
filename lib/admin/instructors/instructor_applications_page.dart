import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';
import '../widgets/pending_feature_notice.dart';

class InstructorApplicationsPage extends StatelessWidget {
  const InstructorApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Instructors', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.xs),
        Text('Everyone who currently has instructor status in the app.',
            style: AdminType.body(13, color: AdminColors.inkFaint)),
        const SizedBox(height: AdminSpace.lg),
        const PendingFeatureNotice(
          reason:
              'There is no approval step today — anyone can self-grant instructor status '
              'through the "Become an Instructor" flow in the app. Turning this into a real '
              'review queue (with Approve/Revoke actions here) needs a callable Cloud Function '
              "that sets an admin-verified custom claim, so a client-writable field can't be "
              "the source of truth for who's actually an instructor.",
        ),
        AdminDataTable<UsersRecord>(
          itemsStream: queryUsersRecord(
            queryBuilder: (q) => q.where('instructor', isEqualTo: true),
          ),
          searchHint: 'Search by name or email…',
          searchFilter: (user, query) {
            final q = query.toLowerCase();
            return user.displayName.toLowerCase().contains(q) || user.email.toLowerCase().contains(q);
          },
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
              cellBuilder: (context, user) => Tooltip(
                message: 'Needs the custom-claim workflow described above',
                child: Text('Revoke', style: AdminType.body(12, color: AdminColors.inkFaint)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
