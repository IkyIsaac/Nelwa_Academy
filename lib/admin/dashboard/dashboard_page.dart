import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/admin_charts.dart';
import '../widgets/kpi_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _InstructorRow {
  const _InstructorRow({
    required this.name,
    required this.specialty,
    required this.balance,
    required this.currency,
  });
  final String name;
  final String specialty;
  final double balance;
  final String currency;
}

class _DashboardStats {
  const _DashboardStats({
    required this.totalUsers,
    required this.instructors,
    required this.totalCourses,
    required this.publishedCourses,
    required this.pendingRefunds,
    required this.monthRevenue,
    required this.ordersThisMonth,
    required this.openReports,
    required this.userGrowth,
    required this.signupSparkline,
    required this.revenueSparkline,
    required this.ordersSparkline,
    required this.orderStatusSegments,
    required this.recentOrders,
    required this.topInstructors,
  });

  final int totalUsers;
  final int instructors;
  final int totalCourses;
  final int publishedCourses;
  final int pendingRefunds;
  final double monthRevenue;
  final int ordersThisMonth;
  final int openReports;
  final List<TrendPoint> userGrowth;
  final List<double> signupSparkline;
  final List<double> revenueSparkline;
  final List<double> ordersSparkline;
  final List<StatusSegment> orderStatusSegments;
  final List<OrdersRecord> recentOrders;
  final List<_InstructorRow> topInstructors;
}

/// Buckets dated values into one sum per calendar day, for the last [days]
/// days ending today. Days with nothing stay zero — real data, not padded.
List<TrendPoint> _dailySums(List<MapEntry<DateTime, double>> entries, int days) {
  final today = DateTime.now();
  final start = DateTime(today.year, today.month, today.day).subtract(Duration(days: days - 1));
  final buckets = <DateTime, double>{
    for (var i = 0; i < days; i++) start.add(Duration(days: i)): 0,
  };
  for (final entry in entries) {
    final day = DateTime(entry.key.year, entry.key.month, entry.key.day);
    if (buckets.containsKey(day)) buckets[day] = buckets[day]! + entry.value;
  }
  return [
    for (final e in buckets.entries) TrendPoint(dateTimeFormat('M/d', e.key), e.value),
  ];
}

/// Cumulative count per calendar month, spanning from the earliest date to
/// now — the real growth curve, not a fixed recent window.
List<TrendPoint> _cumulativeByMonth(List<DateTime> dates) {
  if (dates.isEmpty) return const [];
  final sorted = [...dates]..sort();
  var cursor = DateTime(sorted.first.year, sorted.first.month);
  final last = DateTime(sorted.last.year, sorted.last.month);
  final points = <TrendPoint>[];
  var cumulative = 0;
  var dateIndex = 0;
  while (!cursor.isAfter(last)) {
    final next = DateTime(cursor.year, cursor.month + 1);
    while (dateIndex < sorted.length && sorted[dateIndex].isBefore(next)) {
      cumulative++;
      dateIndex++;
    }
    points.add(TrendPoint(dateTimeFormat('MMM', cursor), cumulative.toDouble()));
    cursor = next;
  }
  return points;
}

/// New signups per month, last [months] months (not cumulative) — for the
/// stat tile sparkline, which reads better as momentum than as a curve
/// that's always monotonically increasing.
List<double> _monthlyCounts(List<DateTime> dates, int months) {
  final now = DateTime.now();
  return [
    for (var i = months - 1; i >= 0; i--)
      () {
        final monthStart = DateTime(now.year, now.month - i);
        final nextMonth = DateTime(monthStart.year, monthStart.month + 1);
        return dates.where((d) => !d.isBefore(monthStart) && d.isBefore(nextMonth)).length.toDouble();
      }(),
  ];
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<_DashboardStats> _statsFuture;
  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
    _statsFuture = _loadStats();
  }

  Future<_DashboardStats> _loadStats() async {
    final startOfMonth = DateTime(_selectedYear, _selectedMonth, 1);
    final startOfNextMonth = DateTime(_selectedYear, _selectedMonth + 1, 1);

    final results = await Future.wait([
      queryUsersRecordOnce(),
      queryUsersRecordCount(
        queryBuilder: (q) => q.where('instructor', isEqualTo: true),
      ),
      queryCoursesRecordCount(),
      queryCoursesRecordCount(
        queryBuilder: (q) => q.where('is_published', isEqualTo: true),
      ),
      queryRequestaRefundRecordCount(
        queryBuilder: (q) => q.where('status', isEqualTo: 'pending'),
      ),
      // Unfiltered on purpose: a `where('createdAt', ...)` query needs a
      // Firestore index that firestore.indexes.json declares but was never
      // actually deployed. Filtering client-side avoids depending on that
      // deploy ever having happened. Sourced from `orders` (real Snippe
      // TZS payments only), not purchase_history, which still carries
      // pre-Snippe fake USD entries mixed in with real ones.
      queryOrdersRecordOnce(),
      queryCoursesReportRecordCount(),
      queryReviewReportRecordCount(),
      queryLessonReportRecordCount(),
      // Sorted client-side below rather than via orderBy: a collection-group
      // orderBy needs a composite index that was never deployed (same
      // undeployed-index gap noted elsewhere in this file) — and with only
      // a handful of instructor accounts, sorting here is free anyway.
      queryPaymentAccountRecordOnce(),
    ]);

    final allUsers = results[0] as List<UsersRecord>;
    final allOrders = results[5] as List<OrdersRecord>;
    final topAccounts = (results[9] as List<PaymentAccountRecord>)
      ..sort((a, b) => b.balance.compareTo(a.balance));

    final signupDates = allUsers.where((u) => u.hasCreatedTime()).map((u) => u.createdTime!).toList();

    final completedOrders = allOrders.where((o) => o.status == 'completed').toList();
    final monthRevenue = completedOrders
        .where((o) =>
            o.hasCompletedAt() &&
            !o.completedAt!.isBefore(startOfMonth) &&
            o.completedAt!.isBefore(startOfNextMonth))
        .fold<double>(0, (sum, o) => sum + o.amount);
    final ordersThisMonth = allOrders
        .where((o) =>
            o.hasCreatedAt() && !o.createdAt!.isBefore(startOfMonth) && o.createdAt!.isBefore(startOfNextMonth))
        .length;

    final completedCount = completedOrders.length;
    final pendingCount = allOrders.where((o) => o.status == 'pending').length;
    final unsuccessfulCount = allOrders.length - completedCount - pendingCount;

    final topInstructors = <_InstructorRow>[];
    for (final account in topAccounts.take(5)) {
      if (account.balance <= 0) continue;
      final ownerRef = account.parentReference;
      final userSnap = await UsersRecord.getDocumentOnce(ownerRef);
      final details = await queryInstructorDetailsRecordOnce(parent: ownerRef, limit: 1);
      topInstructors.add(_InstructorRow(
        name: userSnap.displayName.isEmpty ? userSnap.email : userSnap.displayName,
        specialty: details.isNotEmpty ? details.first.specialty : '',
        balance: account.balance,
        // Note: this field predates the Snippe integration and is "USD" on
        // older accounts even though real credits are TZS — a pre-existing
        // data hygiene issue (see docs/snippe-integration.md), not
        // something to paper over here by hardcoding "TZS".
        currency: account.currency.isEmpty ? 'TZS' : account.currency,
      ));
    }

    final recentOrders = [...allOrders]
      ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));

    return _DashboardStats(
      totalUsers: allUsers.length,
      instructors: results[1] as int,
      totalCourses: results[2] as int,
      publishedCourses: results[3] as int,
      pendingRefunds: results[4] as int,
      monthRevenue: monthRevenue,
      ordersThisMonth: ordersThisMonth,
      openReports: (results[6] as int) + (results[7] as int) + (results[8] as int),
      userGrowth: _cumulativeByMonth(signupDates),
      signupSparkline: _monthlyCounts(signupDates, 6),
      revenueSparkline: _dailySums(
        completedOrders.where((o) => o.hasCompletedAt()).map((o) => MapEntry(o.completedAt!, o.amount)).toList(),
        14,
      ).map((p) => p.value).toList(),
      ordersSparkline: _dailySums(
        allOrders.where((o) => o.hasCreatedAt()).map((o) => MapEntry(o.createdAt!, 1.0)).toList(),
        14,
      ).map((p) => p.value).toList(),
      orderStatusSegments: [
        StatusSegment('Completed', completedCount, AdminColors.success),
        StatusSegment('Pending', pendingCount, AdminColors.warning),
        StatusSegment('Unsuccessful', unsuccessfulCount, AdminColors.error),
      ],
      recentOrders: recentOrders.take(6).toList(),
      topInstructors: topInstructors,
    );
  }

  void _refresh() => setState(() => _statsFuture = _loadStats());

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateTimeFormat('EEEE, MMMM d', today), style: AdminType.label(13)),
                  const SizedBox(height: AdminSpace.xs),
                  Text('Overview', style: AdminType.display(26, weight: FontWeight.w600)),
                ],
              ),
            ),
            _MonthYearSelector(
              month: _selectedMonth,
              year: _selectedYear,
              onChanged: (month, year) => setState(() {
                _selectedMonth = month;
                _selectedYear = year;
                _statsFuture = _loadStats();
              }),
            ),
            const SizedBox(width: AdminSpace.md),
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh, size: 20),
              color: AdminColors.ink,
              onPressed: _refresh,
            ),
          ],
        ),
        const SizedBox(height: AdminSpace.xxl),
        FutureBuilder<_DashboardStats>(
          future: _statsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Error loading dashboard: ${snapshot.error}',
                style: AdminType.body(13, color: AdminColors.error),
              );
            }
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final stats = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AdminSpace.lg,
                  runSpacing: AdminSpace.lg,
                  children: [
                    KpiTile(
                      label: 'Total users',
                      value: '${stats.totalUsers}',
                      icon: Icons.people_outline,
                      status: AdminStatus.brand,
                      sparkline: Sparkline(values: stats.signupSparkline, color: AdminColors.terracotta),
                    ),
                    KpiTile(
                      label: 'Orders in ${dateTimeFormat('MMM yyyy', DateTime(_selectedYear, _selectedMonth))}',
                      value: '${stats.ordersThisMonth}',
                      icon: Icons.receipt_long_outlined,
                      status: AdminStatus.brand,
                      sparkline: Sparkline(values: stats.ordersSparkline, color: AdminColors.terracotta),
                    ),
                    KpiTile(
                      label: 'Revenue in ${dateTimeFormat('MMM yyyy', DateTime(_selectedYear, _selectedMonth))}',
                      value: '${formatNumber(stats.monthRevenue, formatType: FormatType.decimal, decimalType: DecimalType.automatic)} TZS',
                      icon: Icons.payments_outlined,
                      status: AdminStatus.positive,
                      sparkline: Sparkline(values: stats.revenueSparkline, color: AdminColors.success),
                    ),
                    KpiTile(
                      label: 'Published / total courses',
                      value: '${stats.publishedCourses} / ${stats.totalCourses}',
                      icon: Icons.menu_book_outlined,
                      status: AdminStatus.brand,
                    ),
                    KpiTile(
                      label: 'Pending refund requests',
                      value: '${stats.pendingRefunds}',
                      icon: Icons.currency_exchange,
                      status: AdminStatus.caution,
                    ),
                    KpiTile(
                      label: 'Open reports',
                      value: '${stats.openReports}',
                      icon: Icons.flag_outlined,
                      status: AdminStatus.negative,
                    ),
                  ],
                ),
                const SizedBox(height: AdminSpace.xxl),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 900;
                    final userGrowthCard = _Card(
                      title: 'User growth',
                      subtitle: 'Cumulative signups, all time',
                      child: TrendAreaChart(points: stats.userGrowth),
                    );
                    final statusCard = _Card(
                      title: 'Orders by outcome',
                      subtitle: 'All orders, all time',
                      child: StatusBreakdownBar(segments: stats.orderStatusSegments),
                    );
                    if (narrow) {
                      return Column(
                        children: [
                          userGrowthCard,
                          const SizedBox(height: AdminSpace.lg),
                          statusCard,
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: userGrowthCard),
                        const SizedBox(width: AdminSpace.lg),
                        Expanded(child: statusCard),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AdminSpace.lg),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 900;
                    final recentOrdersCard = _Card(
                      title: 'Recent orders',
                      subtitle: 'Latest 6, any status',
                      child: _RecentOrdersList(orders: stats.recentOrders),
                    );
                    final topInstructorsCard = _Card(
                      title: 'Top instructors',
                      subtitle: 'By current balance',
                      child: _TopInstructorsList(instructors: stats.topInstructors),
                    );
                    if (narrow) {
                      return Column(
                        children: [
                          recentOrdersCard,
                          const SizedBox(height: AdminSpace.lg),
                          topInstructorsCard,
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: recentOrdersCard),
                        const SizedBox(width: AdminSpace.lg),
                        Expanded(child: topInstructorsCard),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.subtitle, required this.child});
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AdminSpace.xl),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: AdminColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AdminType.display(16, weight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(subtitle, style: AdminType.label(12.5)),
          const SizedBox(height: AdminSpace.xl),
          child,
        ],
      ),
    );
  }
}

class _RecentOrdersList extends StatelessWidget {
  const _RecentOrdersList({required this.orders});
  final List<OrdersRecord> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Text('No orders yet.', style: AdminType.body(13, color: AdminColors.inkFaint));
    }
    return Column(
      children: [
        for (final order in orders) _RecentOrderRow(order: order),
      ],
    );
  }
}

class _RecentOrderRow extends StatelessWidget {
  const _RecentOrderRow({required this.order});
  final OrdersRecord order;

  @override
  Widget build(BuildContext context) {
    final title = order.lineItems.isNotEmpty ? (order.lineItems.first['title'] as String? ?? '—') : '—';
    final status = order.status;
    final color = switch (status) {
      'completed' => AdminColors.success,
      'pending' => AdminColors.warning,
      _ => AdminColors.error,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AdminSpace.sm),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: AdminSpace.md),
          Expanded(
            child: Text(title, style: AdminType.body(13), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: AdminSpace.md),
          Text('${order.amount.toStringAsFixed(0)} ${order.currency}', style: AdminType.mono(13)),
          const SizedBox(width: AdminSpace.md),
          SizedBox(
            width: 64,
            child: Text(
              order.hasCreatedAt() ? dateTimeFormat('M/d', order.createdAt) : '—',
              textAlign: TextAlign.right,
              style: AdminType.label(12, color: AdminColors.inkFaint),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopInstructorsList extends StatelessWidget {
  const _TopInstructorsList({required this.instructors});
  final List<_InstructorRow> instructors;

  @override
  Widget build(BuildContext context) {
    if (instructors.isEmpty) {
      return Text('No instructor balances yet.', style: AdminType.body(13, color: AdminColors.inkFaint));
    }
    return Column(
      children: [
        for (final instructor in instructors)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AdminSpace.sm),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AdminColors.oxblood.withValues(alpha: 0.12),
                  child: Text(
                    instructor.name.isEmpty ? '?' : instructor.name[0].toUpperCase(),
                    style: AdminType.label(12, weight: FontWeight.w700, color: AdminColors.oxblood),
                  ),
                ),
                const SizedBox(width: AdminSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(instructor.name, style: AdminType.body(13, weight: FontWeight.w600)),
                      if (instructor.specialty.isNotEmpty)
                        Text(instructor.specialty, style: AdminType.label(12)),
                    ],
                  ),
                ),
                Text(
                  '${instructor.balance.toStringAsFixed(0)} ${instructor.currency}',
                  style: AdminType.mono(13),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Scopes the "Orders in / Revenue in" KPI tiles to a chosen month, rather
/// than always the current one.
class _MonthYearSelector extends StatelessWidget {
  const _MonthYearSelector({required this.month, required this.year, required this.onChanged});

  final int month;
  final int year;
  final void Function(int month, int year) onChanged;

  @override
  Widget build(BuildContext context) {
    final years = List.generate(5, (i) => DateTime.now().year - 3 + i);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AdminSpace.md, vertical: 2),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminRadius.md),
        border: Border.all(color: AdminColors.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: month,
              items: [
                for (var m = 1; m <= 12; m++)
                  DropdownMenuItem(
                    value: m,
                    child: Text(dateTimeFormat('MMM', DateTime(2000, m)), style: AdminType.body(13)),
                  ),
              ],
              onChanged: (m) {
                if (m != null) onChanged(m, year);
              },
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AdminColors.inkFaint),
            ),
          ),
          Container(width: 1, height: 18, margin: const EdgeInsets.symmetric(horizontal: AdminSpace.sm), color: AdminColors.hairline),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: year,
              items: [
                for (final y in years) DropdownMenuItem(value: y, child: Text('$y', style: AdminType.body(13))),
              ],
              onChanged: (y) {
                if (y != null) onChanged(month, y);
              },
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AdminColors.inkFaint),
            ),
          ),
        ],
      ),
    );
  }
}
