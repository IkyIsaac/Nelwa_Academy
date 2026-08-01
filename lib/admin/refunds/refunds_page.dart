import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';
import '../widgets/pending_feature_notice.dart';

class RefundsPage extends StatelessWidget {
  const RefundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Refund requests', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.lg),
        const PendingFeatureNotice(
          reason:
              'Requests are listed here in full, but actually reversing a charge needs a '
              'payment processor decision (Stripe/Braintree/Razorpay — none is wired up yet) '
              'plus a Cloud Function that can call it server-side. Approving here would only '
              'edit a status field, not move any money.',
        ),
        AdminDataTable<RequestaRefundRecord>(
          itemsStream: queryRequestaRefundRecord(),
          searchHint: 'Search by reason or status…',
          searchFilter: (r, query) =>
              r.reason.toLowerCase().contains(query.toLowerCase()) ||
              r.status.toLowerCase().contains(query.toLowerCase()),
          emptyLabel: 'No refund requests.',
          statusOf: (r) => switch (r.status.toLowerCase()) {
            'pending' => AdminStatus.caution,
            'refunded' || 'approved' => AdminStatus.positive,
            'rejected' => AdminStatus.negative,
            _ => AdminStatus.neutral,
          },
          columns: [
            AdminColumn<RequestaRefundRecord>(
              label: 'User',
              flex: 3,
              cellBuilder: (context, refund) => _RefName(ref: refund.userRef),
            ),
            AdminColumn<RequestaRefundRecord>(
              label: 'Course',
              flex: 3,
              cellBuilder: (context, refund) => _CourseName(ref: refund.couresesRef),
            ),
            AdminColumn<RequestaRefundRecord>(
              label: 'Amount',
              flex: 2,
              numeric: true,
              cellBuilder: (context, refund) => AdminCellText(refund.amount.toStringAsFixed(2), mono: true),
            ),
            AdminColumn<RequestaRefundRecord>(
              label: 'Reason',
              flex: 4,
              cellBuilder: (context, refund) => AdminCellText(refund.reason, muted: true),
            ),
            AdminColumn<RequestaRefundRecord>(
              label: 'Status',
              flex: 2,
              cellBuilder: (context, refund) => StatusPill(
                label: refund.status.isEmpty ? '—' : refund.status,
                status: switch (refund.status.toLowerCase()) {
                  'pending' => AdminStatus.caution,
                  'refunded' || 'approved' => AdminStatus.positive,
                  'rejected' => AdminStatus.negative,
                  _ => AdminStatus.neutral,
                },
              ),
            ),
            AdminColumn<RequestaRefundRecord>(
              label: 'Requested',
              flex: 2,
              numeric: true,
              cellBuilder: (context, refund) => AdminCellText(
                refund.hasCreatedAt() ? dateTimeFormat('yMMMd', refund.createdAt) : '—',
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

class _RefName extends StatelessWidget {
  const _RefName({required this.ref});
  final DocumentReference? ref;

  @override
  Widget build(BuildContext context) {
    if (ref == null) return const AdminCellText('—', muted: true);
    return FutureBuilder<UsersRecord>(
      future: UsersRecord.getDocumentOnce(ref!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const AdminCellText('…', muted: true);
        final user = snapshot.data!;
        return AdminCellText(user.displayName.isEmpty ? user.email : user.displayName);
      },
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName({required this.ref});
  final DocumentReference? ref;

  @override
  Widget build(BuildContext context) {
    if (ref == null) return const AdminCellText('—', muted: true);
    return FutureBuilder<CoursesRecord>(
      future: CoursesRecord.getDocumentOnce(ref!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const AdminCellText('…', muted: true);
        return AdminCellText(snapshot.data!.title);
      },
    );
  }
}
