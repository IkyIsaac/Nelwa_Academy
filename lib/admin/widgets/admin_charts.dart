import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design/admin_tokens.dart';

/// A single point on a trend chart or sparkline.
class TrendPoint {
  const TrendPoint(this.label, this.value);
  final String label;
  final double value;
}

/// Bare, axis-less line+fill for a stat tile. No hover layer — per the
/// dataviz skill, a sparkline inside a stat tile is the one chart form
/// that's allowed to skip it.
class Sparkline extends StatelessWidget {
  const Sparkline({super.key, required this.values, required this.color, this.height = 32});

  final List<double> values;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(values: values, color: color),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.values, required this.color});
  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.width <= 0) return;

    final maxV = values.reduce(math.max);
    final minV = math.min(0.0, values.reduce(math.min));
    final range = (maxV - minV).abs() < 1e-9 ? 1.0 : (maxV - minV);
    final dx = size.width / (values.length - 1);

    final line = Path();
    final fill = Path();
    for (var i = 0; i < values.length; i++) {
      final x = dx * i;
      final y = size.height - ((values[i] - minV) / range) * size.height;
      if (i == 0) {
        line.moveTo(x, y);
        fill.moveTo(x, size.height);
        fill.lineTo(x, y);
      } else {
        line.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill.lineTo(size.width, size.height);
    fill.close();

    canvas.drawPath(fill, Paint()..color = color.withValues(alpha: 0.12));
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final lastY = size.height - ((values.last - minV) / range) * size.height;
    canvas.drawCircle(Offset(size.width, lastY), 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

/// A single-series area/line chart with recessive gridlines and a
/// crosshair+tooltip hover layer, per the dataviz skill's default for any
/// chart that isn't a bare stat tile.
class TrendAreaChart extends StatefulWidget {
  const TrendAreaChart({
    super.key,
    required this.points,
    this.color = AdminColors.chart,
    this.height = 220,
    this.valueFormatter,
  });

  final List<TrendPoint> points;
  final Color color;
  final double height;
  final String Function(double value)? valueFormatter;

  @override
  State<TrendAreaChart> createState() => _TrendAreaChartState();
}

class _TrendAreaChartState extends State<TrendAreaChart> {
  int? _hoverIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.points.length < 2) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text('Not enough data yet.', style: AdminType.body(13, color: AdminColors.inkFaint)),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return MouseRegion(
            onHover: (event) => _updateHover(event.localPosition.dx, width),
            onExit: (_) => setState(() => _hoverIndex = null),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(width, widget.height),
                  painter: _TrendPainter(
                    points: widget.points,
                    color: widget.color,
                    hoverIndex: _hoverIndex,
                  ),
                ),
                if (_hoverIndex != null) _tooltip(width),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateHover(double dx, double width) {
    final n = widget.points.length;
    final step = width / (n - 1);
    final idx = (dx / step).round().clamp(0, n - 1);
    if (idx != _hoverIndex) setState(() => _hoverIndex = idx);
  }

  Widget _tooltip(double width) {
    final idx = _hoverIndex!;
    final point = widget.points[idx];
    final step = width / (widget.points.length - 1);
    const tooltipWidth = 128.0;
    final left = (step * idx - tooltipWidth / 2)
        .clamp(0.0, math.max(0.0, width - tooltipWidth))
        .toDouble();
    final valueText = widget.valueFormatter?.call(point.value) ?? point.value.toStringAsFixed(0);

    return Positioned(
      left: left,
      top: 0,
      child: IgnorePointer(
        child: Container(
          width: tooltipWidth,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AdminColors.ink,
            borderRadius: BorderRadius.circular(AdminRadius.sm),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(point.label, style: AdminType.label(11, color: Colors.white70)),
              Text(valueText, style: AdminType.mono(13, weight: FontWeight.w600, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({required this.points, required this.color, required this.hoverIndex});

  final List<TrendPoint> points;
  final Color color;
  final int? hoverIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final values = points.map((p) => p.value).toList();
    final maxV = values.reduce(math.max);
    final minV = math.min(0.0, values.reduce(math.min));
    final range = (maxV - minV).abs() < 1e-9 ? 1.0 : (maxV - minV);
    final dx = size.width / (points.length - 1);

    // Recessive gridlines — no axis numbers, the hover tooltip carries the value.
    final gridPaint = Paint()
      ..color = AdminColors.hairline
      ..strokeWidth = 1;
    for (final t in [0.0, 0.5, 1.0]) {
      final y = size.height * t;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final line = Path();
    final fill = Path();
    final offsets = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final x = dx * i;
      final y = size.height - ((values[i] - minV) / range) * size.height;
      offsets.add(Offset(x, y));
      if (i == 0) {
        line.moveTo(x, y);
        fill.moveTo(x, size.height);
        fill.lineTo(x, y);
      } else {
        line.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill.lineTo(size.width, size.height);
    fill.close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    if (hoverIndex != null) {
      final hover = offsets[hoverIndex!];
      canvas.drawLine(
        Offset(hover.dx, 0),
        Offset(hover.dx, size.height),
        Paint()
          ..color = AdminColors.inkFaint.withValues(alpha: 0.5)
          ..strokeWidth = 1,
      );
      canvas.drawCircle(hover, 4, Paint()..color = AdminColors.surface);
      canvas.drawCircle(hover, 4, Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);
      canvas.drawCircle(hover, 2, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.hoverIndex != hoverIndex || oldDelegate.color != color;
}

/// One segment of a status breakdown — count + the status's own semantic
/// color, never a freshly invented categorical hue.
class StatusSegment {
  const StatusSegment(this.label, this.value, this.color);
  final String label;
  final int value;
  final Color color;
}

/// A single proportional bar + legend. Status colors are reserved for this
/// exact job (state), so they're the right palette here — never recolored
/// per-series the way a categorical chart would be.
class StatusBreakdownBar extends StatelessWidget {
  const StatusBreakdownBar({super.key, required this.segments});

  final List<StatusSegment> segments;

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<int>(0, (sum, s) => sum + s.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AdminRadius.sm),
          child: SizedBox(
            height: 10,
            width: double.infinity,
            child: total == 0
                ? Container(color: AdminColors.hairline)
                : Row(
                    children: [
                      for (final s in segments)
                        if (s.value > 0) Expanded(flex: s.value, child: Container(color: s.color)),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: AdminSpace.lg),
        Wrap(
          spacing: AdminSpace.lg,
          runSpacing: AdminSpace.sm,
          children: [
            for (final s in segments)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: AdminSpace.xs),
                  Text('${s.label} · ${s.value}', style: AdminType.body(13)),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
