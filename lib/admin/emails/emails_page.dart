import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';
import '../widgets/kpi_tile.dart';

/// Log of every email sent by the Cloud Functions (the `mail` outbox in
/// firebase/functions/email/outbox.js). Delivery details beyond "accepted
/// by Resend" (opened, bounced) live in the Resend dashboard.
const _kTemplateLabels = {
  'welcome': 'Welcome',
  'purchase_receipt': 'Purchase receipt',
  'payment_failed': 'Payment failed',
  'instructor_sale': 'Instructor sale',
  'instructor_application_received': 'Application received',
  'instructor_approved': 'Instructor approved',
  'instructor_rejected': 'Instructor rejected',
  'instructor_revoked': 'Instructor revoked',
};

String _templateLabel(String template) =>
    _kTemplateLabels[template] ?? (template.isEmpty ? '—' : template);

AdminStatus _statusOf(MailRecord mail) => switch (mail.status) {
      'sent' => AdminStatus.positive,
      'queued' || 'retrying' => AdminStatus.caution,
      'failed' => AdminStatus.negative,
      _ => AdminStatus.neutral,
    };

/// How many of the most recent emails the table loads.
const _kRecentLimit = 500;

class EmailsPage extends StatefulWidget {
  const EmailsPage({super.key});

  @override
  State<EmailsPage> createState() => _EmailsPageState();
}

class _EmailsPageState extends State<EmailsPage> {
  late final Future<List<int>> _counts = Future.wait([
    for (final status in ['sent', 'failed', 'skipped'])
      MailRecord.collection
          .where('status', isEqualTo: status)
          .count()
          .get()
          .then((r) => r.count ?? 0),
  ]);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Emails', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.xs),
        Text(
          'Every email the system sends. Open one for details; failed emails can be resent.',
          style: AdminType.body(13, color: AdminColors.inkFaint),
        ),
        const SizedBox(height: AdminSpace.lg),
        FutureBuilder<List<int>>(
          future: _counts,
          builder: (context, snapshot) {
            String value(int i) => snapshot.hasData ? '${snapshot.data![i]}' : '…';
            return Wrap(
              spacing: AdminSpace.lg,
              runSpacing: AdminSpace.lg,
              children: [
                KpiTile(
                  label: 'Sent',
                  value: value(0),
                  icon: Icons.mark_email_read_outlined,
                  status: AdminStatus.positive,
                ),
                KpiTile(
                  label: 'Failed',
                  value: value(1),
                  icon: Icons.error_outline,
                  status: AdminStatus.negative,
                ),
                KpiTile(
                  label: 'Skipped',
                  value: value(2),
                  icon: Icons.do_not_disturb_on_outlined,
                  status: AdminStatus.neutral,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AdminSpace.xl),
        AdminDataTable<MailRecord>(
          itemsStream: queryMailRecord(
            queryBuilder: (q) => q.orderBy('createdAt', descending: true),
            limit: _kRecentLimit,
          ),
          searchHint: 'Search by recipient, subject, type or status…',
          searchFilter: (mail, query) {
            final q = query.toLowerCase();
            return mail.to.toLowerCase().contains(q) ||
                mail.subject.toLowerCase().contains(q) ||
                _templateLabel(mail.template).toLowerCase().contains(q) ||
                mail.status.contains(q);
          },
          emptyLabel: 'No emails sent yet.',
          statusOf: _statusOf,
          onTap: (mail) => showDialog(
            context: context,
            builder: (_) => _EmailDetailDialog(mail: mail),
          ),
          columns: [
            AdminColumn<MailRecord>(
              label: 'Recipient',
              flex: 3,
              cellBuilder: (context, mail) => AdminCellText(mail.to.isEmpty ? '—' : mail.to),
            ),
            AdminColumn<MailRecord>(
              label: 'Type',
              flex: 2,
              cellBuilder: (context, mail) => AdminCellText(_templateLabel(mail.template)),
            ),
            AdminColumn<MailRecord>(
              label: 'Subject',
              flex: 4,
              cellBuilder: (context, mail) =>
                  AdminCellText(mail.subject.isEmpty ? '—' : mail.subject, muted: mail.subject.isEmpty),
            ),
            AdminColumn<MailRecord>(
              label: 'Lang',
              flex: 1,
              cellBuilder: (context, mail) =>
                  AdminCellText(mail.language.toUpperCase(), mono: true, muted: true),
            ),
            AdminColumn<MailRecord>(
              label: 'Status',
              flex: 2,
              cellBuilder: (context, mail) => StatusPill(
                label: mail.status.isEmpty ? '—' : mail.status,
                status: _statusOf(mail),
              ),
            ),
            AdminColumn<MailRecord>(
              label: 'Created',
              flex: 2,
              numeric: true,
              cellBuilder: (context, mail) => AdminCellText(
                mail.hasCreatedAt() ? dateTimeFormat('MMMd, HH:mm', mail.createdAt) : '—',
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

class _EmailDetailDialog extends StatefulWidget {
  const _EmailDetailDialog({required this.mail});
  final MailRecord mail;

  @override
  State<_EmailDetailDialog> createState() => _EmailDetailDialogState();
}

class _EmailDetailDialogState extends State<_EmailDetailDialog> {
  bool _sending = false;
  String? _error;
  bool _resent = false;

  bool get _canResend =>
      !_resent && (widget.mail.status == 'failed' || widget.mail.status == 'skipped');

  Future<void> _resend() async {
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await FirebaseFunctions.instance
          .httpsCallable('resendEmail')
          .call<dynamic>({'id': widget.mail.reference.id});
      if (!mounted) return;
      setState(() {
        _sending = false;
        _resent = true;
      });
    } on FirebaseFunctionsException catch (e) {
      setState(() {
        _sending = false;
        _error = e.message ?? 'Could not resend the email.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mail = widget.mail;
    final rows = <(String, String)>[
      ('Type', _templateLabel(mail.template)),
      ('Recipient', mail.to),
      ('Subject', mail.subject.isEmpty ? '—' : mail.subject),
      ('Language', mail.language == 'sw' ? 'Swahili' : 'English'),
      ('Status', mail.status),
      ('Created', mail.hasCreatedAt() ? dateTimeFormat('yMMMd, HH:mm', mail.createdAt) : '—'),
      ('Sent', mail.hasSentAt() ? dateTimeFormat('yMMMd, HH:mm', mail.sentAt) : '—'),
      if (mail.attempts > 0) ('Failed attempts', '${mail.attempts}'),
      ('User ID', mail.userId.isEmpty ? '—' : mail.userId),
      ('Resend ID', mail.resendId.isEmpty ? '—' : mail.resendId),
      ('Email ID', mail.reference.id),
    ];

    return AlertDialog(
      title: const Text('Email details'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (label, value) in rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: AdminSpace.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(label, style: AdminType.body(13, color: AdminColors.inkFaint)),
                      ),
                      Expanded(child: SelectableText(value, style: AdminType.body(13))),
                    ],
                  ),
                ),
              if (mail.error.isNotEmpty) ...[
                const SizedBox(height: AdminSpace.sm),
                Text('ERROR', style: AdminType.eyebrow()),
                const SizedBox(height: AdminSpace.xs),
                SelectableText(
                  mail.error,
                  style: AdminType.mono(12, color: AdminColors.error),
                ),
              ],
              if (_resent) ...[
                const SizedBox(height: AdminSpace.md),
                Text('Email resent.', style: AdminType.body(13, color: AdminColors.success)),
              ],
              if (_error != null) ...[
                const SizedBox(height: AdminSpace.md),
                Text(_error!, style: AdminType.body(13, color: AdminColors.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        if (_canResend)
          FilledButton(
            onPressed: _sending ? null : _resend,
            child: _sending
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Resend'),
          ),
      ],
    );
  }
}
