import 'package:flutter/material.dart';

import '../design/admin_tokens.dart';

/// Shared banner shown on admin sections that are listable/readable today
/// but whose write actions need a backend decision that hasn't been made
/// yet (a payment processor, a Cloud Function, a custom claim). Never
/// silently disable a control — always say why.
class PendingFeatureNotice extends StatelessWidget {
  const PendingFeatureNotice({super.key, required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AdminSpace.xl),
      decoration: BoxDecoration(
        color: AdminColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AdminRadius.md),
      ),
      child: StatusSpine(
        status: AdminStatus.caution,
        child: Padding(
          padding: const EdgeInsets.all(AdminSpace.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.construction_rounded, color: AdminColors.warning, size: 18),
              const SizedBox(width: AdminSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NEEDS BACKEND WORK', style: AdminType.eyebrow(color: AdminColors.ink)),
                    const SizedBox(height: AdminSpace.xs),
                    Text(reason, style: AdminType.body(13, color: AdminColors.inkFaint).copyWith(height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
