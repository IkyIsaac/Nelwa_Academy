import 'package:flutter/material.dart';

import '../design/admin_tokens.dart';

class KpiTile extends StatelessWidget {
  const KpiTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.status = AdminStatus.brand,
  });

  final String label;
  final String value;
  final IconData icon;
  final AdminStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: AdminColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: StatusSpine(
        status: status,
        width: 3,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AdminSpace.lg, AdminSpace.lg, AdminSpace.lg, AdminSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: AdminColors.inkFaint),
                  const SizedBox(width: AdminSpace.sm),
                  Expanded(
                    child: Text(label.toUpperCase(), style: AdminType.eyebrow()),
                  ),
                ],
              ),
              const SizedBox(height: AdminSpace.lg),
              Text(value, style: AdminType.mono(28, weight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
