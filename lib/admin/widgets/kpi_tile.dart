import 'package:flutter/material.dart';

import '../design/admin_tokens.dart';

class KpiTile extends StatelessWidget {
  const KpiTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.status = AdminStatus.brand,
    this.sparkline,
  });

  final String label;
  final String value;
  final IconData icon;
  final AdminStatus status;

  /// Optional trend widget (a `Sparkline`) shown beside the figure — only
  /// the metrics that genuinely have a time series get one; a ratio like
  /// "published / total" doesn't need to pretend it has a trend.
  final Widget? sparkline;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fixed, not just a minWidth: this tile sits inside a Wrap, which
      // gives each child unbounded width to measure itself. Without a fixed
      // width here, the Expanded sparkline below has nothing bounded to
      // flex against and the whole tile stretches to fill the row.
      width: 280,
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: AdminColors.hairline),
      ),
      child: StatusSpine(
        status: status,
        width: 3,
        child: Padding(
          padding: const EdgeInsets.all(AdminSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(AdminRadius.sm),
                    ),
                    child: Icon(icon, size: 16, color: status.color),
                  ),
                  const SizedBox(width: AdminSpace.md),
                  Expanded(child: Text(label, style: AdminType.label(13))),
                ],
              ),
              const SizedBox(height: AdminSpace.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value, style: AdminType.mono(26, weight: FontWeight.w600)),
                  if (sparkline != null) ...[
                    const SizedBox(width: AdminSpace.md),
                    Expanded(child: sparkline!),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
