import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_data_table.dart';

/// Consultation bookings from the mobile app and the website. Each new one
/// is also emailed to the academy inbox (emailOnConsultationBooked).
///
/// Read-only: the security rules don't let anyone edit a booking, so there
/// is no status to change yet. Bookings are marked Upcoming or Past from
/// the day the person picked; the academy confirms the real time by phone
/// or email.
class ConsultationsPage extends StatelessWidget {
  const ConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Consultations', style: AdminType.display(26, weight: FontWeight.w600)),
        const SizedBox(height: AdminSpace.xs),
        Text(
          'Booking requests from the app and the website. Contact each person to confirm a time.',
          style: AdminType.body(13, color: AdminColors.inkFaint),
        ),
        const SizedBox(height: AdminSpace.lg),
        AdminDataTable<ConsultationRecord>(
          itemsStream: queryConsultationRecord(
            queryBuilder: (q) => q.orderBy('created_time', descending: true),
          ),
          searchHint: 'Search by name, phone, email or topic…',
          searchFilter: (c, query) {
            final q = query.toLowerCase();
            return [
              _name(c),
              c.phoneNumber,
              c.email,
              departmentLabel(c.selectedDepartment),
              c.reasonForVisit,
            ].any((v) => v.toLowerCase().contains(q));
          },
          emptyLabel: 'No consultation bookings yet.',
          statusOf: (c) => _isUpcoming(c) ? AdminStatus.caution : AdminStatus.neutral,
          onTap: (c) => showDialog(
            context: context,
            builder: (_) => _ConsultationDialog(consultation: c),
          ),
          columns: [
            AdminColumn<ConsultationRecord>(
              label: 'Name',
              flex: 3,
              cellBuilder: (context, c) => AdminCellText(_name(c)),
            ),
            AdminColumn<ConsultationRecord>(
              label: 'Phone',
              flex: 2,
              cellBuilder: (context, c) =>
                  AdminCellText(c.phoneNumber.isEmpty ? '—' : c.phoneNumber, mono: true),
            ),
            AdminColumn<ConsultationRecord>(
              label: 'Topic',
              flex: 3,
              cellBuilder: (context, c) =>
                  AdminCellText(departmentLabel(c.selectedDepartment), muted: true),
            ),
            AdminColumn<ConsultationRecord>(
              label: 'Preferred day',
              flex: 2,
              numeric: true,
              cellBuilder: (context, c) => AdminCellText(
                c.hasAppointmentTime() ? dateTimeFormat('yMMMd', c.appointmentTime) : '—',
                mono: true,
              ),
            ),
            AdminColumn<ConsultationRecord>(
              label: 'When',
              flex: 2,
              cellBuilder: (context, c) => StatusPill(
                label: _isUpcoming(c) ? 'Upcoming' : 'Past',
                status: _isUpcoming(c) ? AdminStatus.caution : AdminStatus.neutral,
              ),
            ),
            AdminColumn<ConsultationRecord>(
              label: 'Booked',
              flex: 2,
              numeric: true,
              cellBuilder: (context, c) => AdminCellText(
                c.hasCreatedTime() ? dateTimeFormat('yMMMd', c.createdTime) : '—',
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

String _name(ConsultationRecord c) =>
    c.displayName.isNotEmpty ? c.displayName : (c.userName.isNotEmpty ? c.userName : '—');

/// The preferred day is still today or later.
bool _isUpcoming(ConsultationRecord c) {
  if (!c.hasAppointmentTime()) return false;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return !c.appointmentTime!.isBefore(today);
}

/// The app stores these exact strings (spellings included); show readable ones.
String departmentLabel(String stored) => switch (stored) {
      "Nelway's Academy" => 'Courses & learning',
      "Nelway's Ice cream" => 'Ice cream business',
      "Nelway's Gelato" => 'Gelato',
      "Nelway's Consultaion" => 'Business consultation',
      '' => '—',
      _ => stored,
    };

class _ConsultationDialog extends StatelessWidget {
  const _ConsultationDialog({required this.consultation});
  final ConsultationRecord consultation;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final phone = c.phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final whatsapp = phone.replaceAll('+', '');
    return AlertDialog(
      title: Text(_name(c)),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Field('Phone', c.phoneNumber),
              _Field('Email', c.email),
              _Field('Topic', departmentLabel(c.selectedDepartment)),
              _Field(
                'Preferred day',
                c.hasAppointmentTime() ? dateTimeFormat('yMMMMEEEEd', c.appointmentTime) : '',
              ),
              _Field('Booked', c.hasCreatedTime() ? dateTimeFormat('yMMMd jm', c.createdTime) : ''),
              _Field('Account', c.uid.isEmpty ? 'Visitor (not signed in)' : 'Signed-in learner'),
              const SizedBox(height: AdminSpace.md),
              Text('Message', style: AdminType.body(13, color: AdminColors.inkFaint)),
              const SizedBox(height: AdminSpace.xs),
              SelectableText(
                c.reasonForVisit.isEmpty ? '—' : c.reasonForVisit,
                style: AdminType.body(14),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (phone.isNotEmpty)
          TextButton.icon(
            onPressed: () => launchURL('tel:$phone'),
            icon: const Icon(Icons.call_outlined, size: 18),
            label: const Text('Call'),
          ),
        if (whatsapp.isNotEmpty)
          TextButton.icon(
            onPressed: () => launchURL('https://wa.me/$whatsapp'),
            icon: const Icon(Icons.chat_outlined, size: 18),
            label: const Text('WhatsApp'),
          ),
        if (c.email.isNotEmpty)
          TextButton.icon(
            onPressed: () => launchURL(
                'mailto:${c.email}?subject=${Uri.encodeComponent("Your Nelwa's Academy consultation")}'),
            icon: const Icon(Icons.mail_outline, size: 18),
            label: const Text('Email'),
          ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
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
            width: 110,
            child: Text(label, style: AdminType.body(13, color: AdminColors.inkFaint)),
          ),
          Expanded(child: SelectableText(value.isEmpty ? '—' : value, style: AdminType.body(13))),
        ],
      ),
    );
  }
}
