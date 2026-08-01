import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../design/admin_tokens.dart';
import '../widgets/kpi_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardStats {
  const _DashboardStats({
    required this.totalUsers,
    required this.instructors,
    required this.totalCourses,
    required this.publishedCourses,
    required this.pendingRefunds,
    required this.monthRevenue,
    required this.openReports,
  });

  final int totalUsers;
  final int instructors;
  final int totalCourses;
  final int publishedCourses;
  final int pendingRefunds;
  final double monthRevenue;
  final int openReports;
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<_DashboardStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _loadStats();
  }

  Future<_DashboardStats> _loadStats() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final results = await Future.wait([
      queryUsersRecordCount(),
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
      // Unfiltered on purpose: a `where('date', ...)` collection-group query
      // needs a Firestore index that firestore.indexes.json declares but was
      // never actually deployed. Filtering client-side avoids depending on
      // that deploy ever having happened.
      queryPurchaseHistoryRecordOnce(),
      queryCoursesReportRecordCount(),
      queryReviewReportRecordCount(),
      queryLessonReportRecordCount(),
    ]);

    final allPurchases = results[5] as List<PurchaseHistoryRecord>;
    final monthPurchases = allPurchases.where(
      (p) => p.hasDate() && p.date!.isAfter(startOfMonth.subtract(const Duration(seconds: 1))),
    );
    final monthRevenue =
        monthPurchases.fold<double>(0, (sum, p) => sum + p.amount);

    return _DashboardStats(
      totalUsers: results[0] as int,
      instructors: results[1] as int,
      totalCourses: results[2] as int,
      publishedCourses: results[3] as int,
      pendingRefunds: results[4] as int,
      monthRevenue: monthRevenue,
      openReports:
          (results[6] as int) + (results[7] as int) + (results[8] as int),
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
                  Text(dateTimeFormat('EEEE, MMMM d', today), style: AdminType.eyebrow()),
                  const SizedBox(height: AdminSpace.xs),
                  Text('Overview', style: AdminType.display(26, weight: FontWeight.w600)),
                ],
              ),
            ),
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
            return Wrap(
              spacing: AdminSpace.lg,
              runSpacing: AdminSpace.lg,
              children: [
                KpiTile(
                  label: 'Total users',
                  value: '${stats.totalUsers}',
                  icon: Icons.people_outline,
                  status: AdminStatus.brand,
                ),
                KpiTile(
                  label: 'Instructors',
                  value: '${stats.instructors}',
                  icon: Icons.school_outlined,
                  status: AdminStatus.brand,
                ),
                KpiTile(
                  label: 'Published / total courses',
                  value: '${stats.publishedCourses} / ${stats.totalCourses}',
                  icon: Icons.menu_book_outlined,
                  status: AdminStatus.brand,
                ),
                KpiTile(
                  label: 'Revenue this month',
                  value: formatNumber(
                    stats.monthRevenue,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.automatic,
                  ),
                  icon: Icons.payments_outlined,
                  status: AdminStatus.positive,
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
            );
          },
        ),
      ],
    );
  }
}
