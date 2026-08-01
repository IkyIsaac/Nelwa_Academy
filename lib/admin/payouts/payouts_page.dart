import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';
import '../widgets/pending_feature_notice.dart';

class PayoutsPage extends StatelessWidget {
  const PayoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payouts', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.lg),
        const PendingFeatureNotice(
          reason:
              'Instructor payment accounts and balances are listed here, but actually sending '
              'a payout needs a payment processor decision (Stripe/Braintree/Razorpay — none '
              'is wired up yet) plus a Cloud Function that can move money server-side.',
        ),
        AdminDataTable<PaymentAccountRecord>(
          itemsStream: queryPaymentAccountRecord(),
          emptyLabel: 'No payment accounts on file.',
          statusOf: (account) => account.isDefault ? AdminStatus.brand : AdminStatus.neutral,
          columns: [
            AdminColumn<PaymentAccountRecord>(
              label: 'Instructor',
              flex: 3,
              cellBuilder: (context, account) => _OwnerName(ref: account.parentReference),
            ),
            AdminColumn<PaymentAccountRecord>(
              label: 'Account type',
              flex: 2,
              cellBuilder: (context, account) =>
                  AdminCellText(account.accountType.isEmpty ? '—' : account.accountType, muted: true),
            ),
            AdminColumn<PaymentAccountRecord>(
              label: 'Currency',
              flex: 1,
              cellBuilder: (context, account) =>
                  AdminCellText(account.currency.isEmpty ? '—' : account.currency, mono: true),
            ),
            AdminColumn<PaymentAccountRecord>(
              label: 'Balance',
              flex: 2,
              numeric: true,
              cellBuilder: (context, account) => AdminCellText(account.balance.toStringAsFixed(2), mono: true),
            ),
            AdminColumn<PaymentAccountRecord>(
              label: 'Default',
              flex: 1,
              cellBuilder: (context, account) => account.isDefault
                  ? const StatusPill(label: 'Default', status: AdminStatus.brand)
                  : const AdminCellText('—', muted: true),
            ),
          ],
        ),
      ],
    );
  }
}

class _OwnerName extends StatelessWidget {
  const _OwnerName({required this.ref});
  final DocumentReference ref;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UsersRecord>(
      future: UsersRecord.getDocumentOnce(ref),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const AdminCellText('…', muted: true);
        final user = snapshot.data!;
        return AdminCellText(user.displayName.isEmpty ? user.email : user.displayName);
      },
    );
  }
}
