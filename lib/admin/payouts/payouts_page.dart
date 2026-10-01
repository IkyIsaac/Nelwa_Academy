import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';

class PayoutsPage extends StatelessWidget {
  const PayoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payouts', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.lg),
        Text(
          'Payouts go out via Snippe to the instructor\'s phone (mobile money only '
          'for now — bank transfer isn\'t wired up). Balance is only reduced once '
          'Snippe confirms the payout completed, never at the moment you send it.',
          style: AdminType.body(13, color: AdminColors.inkFaint).copyWith(height: 1.5),
        ),
        const SizedBox(height: AdminSpace.lg),
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
              cellBuilder: (context, account) => AdminCellText(account.balance.toStringAsFixed(0), mono: true),
            ),
            AdminColumn<PaymentAccountRecord>(
              label: '',
              flex: 2,
              cellBuilder: (context, account) => _PayOutButton(account: account),
            ),
          ],
        ),
        const SizedBox(height: AdminSpace.xxl),
        Text('Payout history', style: AdminType.display(20, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.lg),
        AdminDataTable<PayoutsRecord>(
          itemsStream: queryPayoutsRecord(
            queryBuilder: (q) => q.orderBy('createdAt', descending: true),
          ),
          emptyLabel: 'No payouts yet.',
          statusOf: (payout) => switch (payout.status.toLowerCase()) {
            'completed' => AdminStatus.positive,
            'pending' => AdminStatus.caution,
            'failed' || 'reversed' => AdminStatus.negative,
            _ => AdminStatus.neutral,
          },
          columns: [
            AdminColumn<PayoutsRecord>(
              label: 'Instructor',
              flex: 3,
              cellBuilder: (context, payout) => _OwnerName(ref: payout.instructorRef),
            ),
            AdminColumn<PayoutsRecord>(
              label: 'Amount',
              flex: 2,
              numeric: true,
              cellBuilder: (context, payout) => AdminCellText(
                '${payout.amount.toStringAsFixed(0)} ${payout.currency}',
                mono: true,
              ),
            ),
            AdminColumn<PayoutsRecord>(
              label: 'Status',
              flex: 2,
              cellBuilder: (context, payout) => StatusPill(
                label: payout.status.isEmpty ? '—' : payout.status,
                status: switch (payout.status.toLowerCase()) {
                  'completed' => AdminStatus.positive,
                  'pending' => AdminStatus.caution,
                  'failed' || 'reversed' => AdminStatus.negative,
                  _ => AdminStatus.neutral,
                },
              ),
            ),
            AdminColumn<PayoutsRecord>(
              label: 'Sent',
              flex: 2,
              numeric: true,
              cellBuilder: (context, payout) => AdminCellText(
                payout.hasCreatedAt() ? dateTimeFormat('yMMMd', payout.createdAt) : '—',
                mono: true,
                muted: true,
              ),
            ),
            AdminColumn<PayoutsRecord>(
              label: 'Snippe ref',
              flex: 3,
              cellBuilder: (context, payout) => AdminCellText(
                payout.snippeReference.isEmpty ? '—' : payout.snippeReference,
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

class _OwnerName extends StatelessWidget {
  const _OwnerName({required this.ref});
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

class _PayOutButton extends StatelessWidget {
  const _PayOutButton({required this.account});
  final PaymentAccountRecord account;

  @override
  Widget build(BuildContext context) {
    if (account.balance <= 0) {
      return const AdminCellText('No balance', muted: true);
    }
    return TextButton(
      onPressed: () => showDialog(
        context: context,
        builder: (_) => _PayoutDialog(account: account),
      ),
      child: const Text('Pay out'),
    );
  }
}

class _PayoutDialog extends StatefulWidget {
  const _PayoutDialog({required this.account});
  final PaymentAccountRecord account;

  @override
  State<_PayoutDialog> createState() => _PayoutDialogState();
}

class _PayoutDialogState extends State<_PayoutDialog> {
  late final TextEditingController _amountController;
  bool _confirmed = false;
  bool _sending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.account.balance.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid amount.');
      return;
    }
    if (amount > widget.account.balance) {
      setState(() => _error = 'Amount exceeds the available balance.');
      return;
    }

    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      await FirebaseFunctions.instance.httpsCallable('createPayout').call<dynamic>({
        'instructorUserId': widget.account.parentReference.id,
        'amount': amount,
      });
      if (!mounted) return;
      Navigator.pop(context, true);
    } on FirebaseFunctionsException catch (e) {
      setState(() {
        _sending = false;
        _error = e.message ?? 'Could not send the payout.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send payout'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available balance: ${widget.account.balance.toStringAsFixed(0)} TZS'),
            const SizedBox(height: AdminSpace.md),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (TZS)'),
              enabled: !_sending,
            ),
            const SizedBox(height: AdminSpace.md),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _confirmed,
              onChanged: _sending ? null : (v) => setState(() => _confirmed = v ?? false),
              title: const Text(
                'I understand this sends real money to the instructor\'s phone '
                'via Snippe and cannot be undone.',
                style: TextStyle(fontSize: 13),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AdminSpace.sm),
              Text(_error!, style: const TextStyle(color: AdminColors.error, fontSize: 13)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: (_confirmed && !_sending) ? _send : null,
          child: _sending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send payout'),
        ),
      ],
    );
  }
}
