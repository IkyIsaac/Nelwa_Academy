import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';

/// Real Snippe-backed order history (the `orders` collection written by
/// createOrder/snippeWebhook in firebase/functions/payments.js) — the one
/// source of truth for actual money collected, as opposed to the mixed
/// pre-Snippe/real-Snippe data in purchase_history.
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Orders', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.lg),
        AdminDataTable<OrdersRecord>(
          itemsStream: queryOrdersRecord(
            queryBuilder: (q) => q.orderBy('createdAt', descending: true),
          ),
          searchHint: 'Search by status or Snippe reference…',
          searchFilter: (order, query) =>
              order.status.toLowerCase().contains(query.toLowerCase()) ||
              order.snippeReference.toLowerCase().contains(query.toLowerCase()),
          emptyLabel: 'No orders yet.',
          statusOf: (order) => switch (order.status.toLowerCase()) {
            'completed' => AdminStatus.positive,
            'pending' => AdminStatus.caution,
            'failed' || 'voided' => AdminStatus.negative,
            _ => AdminStatus.neutral,
          },
          columns: [
            AdminColumn<OrdersRecord>(
              label: 'User',
              flex: 3,
              cellBuilder: (context, order) => _UserName(ref: order.userRef),
            ),
            AdminColumn<OrdersRecord>(
              label: 'Course(s)',
              flex: 4,
              cellBuilder: (context, order) => _LineItemsSummary(order: order),
            ),
            AdminColumn<OrdersRecord>(
              label: 'Amount',
              flex: 2,
              numeric: true,
              cellBuilder: (context, order) => AdminCellText(
                '${order.amount.toStringAsFixed(0)} ${order.currency}',
                mono: true,
              ),
            ),
            AdminColumn<OrdersRecord>(
              label: 'Status',
              flex: 2,
              cellBuilder: (context, order) => StatusPill(
                label: order.status.isEmpty ? '—' : order.status,
                status: switch (order.status.toLowerCase()) {
                  'completed' => AdminStatus.positive,
                  'pending' => AdminStatus.caution,
                  'failed' || 'voided' => AdminStatus.negative,
                  _ => AdminStatus.neutral,
                },
              ),
            ),
            AdminColumn<OrdersRecord>(
              label: 'Created',
              flex: 2,
              numeric: true,
              cellBuilder: (context, order) => AdminCellText(
                order.hasCreatedAt()
                    ? dateTimeFormat('yMMMd', order.createdAt)
                    : '—',
                mono: true,
                muted: true,
              ),
            ),
            AdminColumn<OrdersRecord>(
              label: 'Snippe ref',
              flex: 3,
              cellBuilder: (context, order) => AdminCellText(
                order.snippeReference.isEmpty ? '—' : order.snippeReference,
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

class _UserName extends StatelessWidget {
  const _UserName({required this.ref});
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

class _LineItemsSummary extends StatelessWidget {
  const _LineItemsSummary({required this.order});
  final OrdersRecord order;

  @override
  Widget build(BuildContext context) {
    final items = order.lineItems;
    if (items.isEmpty) return const AdminCellText('—', muted: true);
    final firstTitle = items.first['title'] as String? ?? '—';
    final label = items.length > 1
        ? '$firstTitle +${items.length - 1} more'
        : firstTitle;
    return AdminCellText(label);
  }
}
