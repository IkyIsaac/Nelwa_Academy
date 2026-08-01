import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/pending_feature_notice.dart';

const _kRoleOptions = ['Learner', 'Instructor'];

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key, required this.userId});

  final String userId;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  bool _savingRole = false;

  Future<void> _updateRole(DocumentReference ref, String role) async {
    setState(() => _savingRole = true);
    await ref.update({'role': role});
    if (mounted) setState(() => _savingRole = false);
  }

  @override
  Widget build(BuildContext context) {
    final userRef = UsersRecord.collection.doc(widget.userId);

    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(userRef),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _BackButton(onTap: () => context.go('/users')),
                const SizedBox(width: AdminSpace.md),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AdminColors.terracotta.withValues(alpha: 0.2),
                  child: Text(
                    (user.displayName.isEmpty ? user.email : user.displayName)
                        .substring(0, 1)
                        .toUpperCase(),
                    style: AdminType.body(16, weight: FontWeight.w700, color: AdminColors.oxblood),
                  ),
                ),
                const SizedBox(width: AdminSpace.md),
                Text(
                  user.displayName.isEmpty ? user.email : user.displayName,
                  style: AdminType.display(24, weight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: AdminSpace.xxl),
            _SectionCard(
              title: 'Profile',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow('Email', user.email),
                  _InfoRow('Phone', user.phoneNumber.isEmpty ? '—' : user.phoneNumber),
                  _InfoRow('Country', user.country.isEmpty ? '—' : user.country),
                  _InfoRow(
                    'Joined',
                    user.hasCreatedTime() ? dateTimeFormat('yMMMd', user.createdTime) : '—',
                  ),
                  const SizedBox(height: AdminSpace.lg),
                  Row(
                    children: [
                      Text('ROLE', style: AdminType.eyebrow()),
                      const SizedBox(width: AdminSpace.lg),
                      DropdownButton<String>(
                        value: _kRoleOptions.contains(user.role) ? user.role : null,
                        hint: Text('Unset', style: AdminType.body(13, color: AdminColors.inkFaint)),
                        style: AdminType.body(13, color: AdminColors.ink),
                        underline: Container(height: 1, color: AdminColors.hairline),
                        items: _kRoleOptions
                            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: _savingRole
                            ? null
                            : (value) {
                                if (value != null) _updateRole(user.reference, value);
                              },
                      ),
                      if (_savingRole) ...[
                        const SizedBox(width: AdminSpace.md),
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AdminSpace.sm),
                  Text(
                    'This only changes what the mobile app displays to the user. It does not '
                    'grant admin-portal access — that is controlled separately by the admin '
                    'email allow-list.',
                    style: AdminType.body(12, color: AdminColors.inkFaint),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdminSpace.lg),
            _SectionCard(
              title: 'Purchased courses',
              child: user.purchasedCourses.isEmpty
                  ? Text('No purchases yet.', style: AdminType.body(13, color: AdminColors.inkFaint))
                  : FutureBuilder<List<CoursesRecord>>(
                      future: Future.wait(
                          user.purchasedCourses.map((ref) => CoursesRecord.getDocumentOnce(ref))),
                      builder: (context, coursesSnapshot) {
                        if (!coursesSnapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: coursesSnapshot.data!
                              .map((course) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Text('· ${course.title}',
                                        style: AdminType.body(13)),
                                  ))
                              .toList(),
                        );
                      },
                    ),
            ),
            const SizedBox(height: AdminSpace.lg),
            _SectionCard(
              title: 'Purchase history',
              child: StreamBuilder<List<PurchaseHistoryRecord>>(
                stream: queryPurchaseHistoryRecord(parent: user.reference),
                builder: (context, historySnapshot) {
                  if (!historySnapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final history = historySnapshot.data!;
                  if (history.isEmpty) {
                    return Text('No transactions yet.',
                        style: AdminType.body(13, color: AdminColors.inkFaint));
                  }
                  return Column(
                    children: history
                        .map((h) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: Text(h.coursesName, style: AdminType.body(13))),
                                  Expanded(
                                    flex: 2,
                                    child: Text('${h.currency} ${h.amount.toStringAsFixed(2)}',
                                        style: AdminType.mono(13)),
                                  ),
                                  Expanded(flex: 2, child: Text(h.status?.name ?? '—', style: AdminType.body(13, color: AdminColors.inkFaint))),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      h.hasDate() ? dateTimeFormat('yMMMd', h.date) : '—',
                                      style: AdminType.mono(12, color: AdminColors.inkFaint),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: AdminSpace.lg),
            _SectionCard(
              title: 'Account actions',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PendingFeatureNotice(
                    reason:
                        'Disabling sign-in for another user requires the Firebase Admin SDK '
                        "(a Cloud Function) — client apps cannot disable another user's account.",
                  ),
                  OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.block, size: 16),
                    label: const Text('Disable account'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AdminRadius.sm)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AdminSpace.xl),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: AdminColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AdminType.eyebrow()),
          const SizedBox(height: AdminSpace.lg),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: AdminType.body(13, color: AdminColors.inkFaint))),
          Text(value, style: AdminType.body(13)),
        ],
      ),
    );
  }
}
