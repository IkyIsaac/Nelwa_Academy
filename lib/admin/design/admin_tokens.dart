import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system for the admin console — a "registry" for the school's
/// operations: courses, lessons, people, money. Built on the app's real
/// brand colors (`LightModeTheme` in flutter_flow_theme.dart) rather than
/// inventing a new palette, but used structurally instead of decoratively:
/// the deep oxblood is the console's own color (nav rail, primary actions),
/// terracotta is reserved for status signals, and every number in the UI
/// sets in a monospace so figures line up like a ledger.
abstract final class AdminColors {
  // Straight from LightModeTheme — kept in sync deliberately, not copied
  // by accident. See lib/flutter_flow/flutter_flow_theme.dart.
  static const oxblood = Color(0xFF5D0A0B);
  static const oxbloodDark = Color(0xFF3E0607);
  static const terracotta = Color(0xFFEE8B60);
  static const canvas = Color(0xFFF6F6F6);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF242424);
  static const inkFaint = Color(0xFFA5A5A5);
  static const hairline = Color(0xFFE0E3E7);
  static const success = Color(0xFF2BC63D);
  static const warning = Color(0xFFFFBF00);
  static const error = Color(0xFFE0301E);

  /// Rail text/icons at rest, against the oxblood background.
  static const onRail = Color(0xFFE9C9C4);
  static const onRailMuted = Color(0xFFB98C87);
}

abstract final class AdminType {
  static TextStyle display(
    double size, {
    FontWeight weight = FontWeight.w600,
    Color color = AdminColors.ink,
    double? letterSpacing,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
        height: 1.15,
      );

  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AdminColors.ink,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.4,
      );

  /// For anything numeric or code-like: KPI figures, table numeric/date
  /// columns, IDs, prices — tabular figures so columns of digits align.
  static TextStyle mono(
    double size, {
    FontWeight weight = FontWeight.w500,
    Color color = AdminColors.ink,
  }) =>
      GoogleFonts.ibmPlexMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Small-caps-style section eyebrows ("PROFILE", "PURCHASE HISTORY").
  static TextStyle eyebrow({Color color = AdminColors.inkFaint}) =>
      GoogleFonts.ibmPlexMono(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 1.2,
      );
}

abstract final class AdminSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;
}

abstract final class AdminRadius {
  static const sm = 6.0;
  static const md = 10.0;
  static const lg = 14.0;
  static const pill = 999.0;
}

/// The "status spine" is the console's signature: a thin colored bar on
/// the leading edge of a card or row that says what state something is in
/// before you read a word — published/draft, role, refund status — the
/// way color-coded tabs work in a physical filing registry.
enum AdminStatus { neutral, positive, caution, negative, brand }

extension AdminStatusColor on AdminStatus {
  Color get color => switch (this) {
        AdminStatus.neutral => AdminColors.hairline,
        AdminStatus.positive => AdminColors.success,
        AdminStatus.caution => AdminColors.warning,
        AdminStatus.negative => AdminColors.error,
        AdminStatus.brand => AdminColors.terracotta,
      };
}

class StatusSpine extends StatelessWidget {
  const StatusSpine({super.key, required this.child, required this.status, this.width = 3});

  final Widget child;
  final AdminStatus status;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: status.color, width: width)),
      ),
      child: child,
    );
  }
}

class StatusDot extends StatelessWidget {
  const StatusDot({super.key, required this.status, this.size = 8});

  final AdminStatus status;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
    );
  }
}

/// A small pill label, e.g. "Published", "Instructor", "Pending".
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.status});

  final String label;
  final AdminStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AdminSpace.sm, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AdminRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatusDot(status: status, size: 6),
          const SizedBox(width: AdminSpace.xs),
          Text(label, style: AdminType.body(12, weight: FontWeight.w600, color: AdminColors.ink)),
        ],
      ),
    );
  }
}
