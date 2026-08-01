import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Users', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.xxl),
        AdminDataTable<UsersRecord>(
          itemsStream: queryUsersRecord(),
          searchHint: 'Search by name or email…',
          searchFilter: (user, query) {
            final q = query.toLowerCase();
            return user.displayName.toLowerCase().contains(q) ||
                user.email.toLowerCase().contains(q);
          },
          statusOf: (user) => user.instructor ? AdminStatus.brand : AdminStatus.neutral,
          onTap: (user) => context.go('/users/${user.reference.id}'),
          columns: [
            AdminColumn<UsersRecord>(
              label: 'Name',
              flex: 3,
              cellBuilder: (context, user) =>
                  AdminCellText(user.displayName.isEmpty ? '—' : user.displayName),
            ),
            AdminColumn<UsersRecord>(
              label: 'Email',
              flex: 4,
              cellBuilder: (context, user) => AdminCellText(user.email, muted: true),
            ),
            AdminColumn<UsersRecord>(
              label: 'Role',
              flex: 2,
              cellBuilder: (context, user) => user.role.isEmpty
                  ? const AdminCellText('—', muted: true)
                  : StatusPill(
                      label: user.role,
                      status: user.instructor ? AdminStatus.brand : AdminStatus.neutral,
                    ),
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
          ],
        ),
      ],
    );
  }
}
