import 'package:flutter/material.dart';

class AdminNavItem {
  const AdminNavItem({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}

/// Every section is reachable from the nav — including the ones that are
/// list-only in this pass. Hiding them would make it look like the feature
/// doesn't exist; showing the page with a PendingFeatureNotice explains why
/// it isn't fully live yet.
const List<AdminNavItem> kAdminNavItems = [
  AdminNavItem(label: 'Dashboard', icon: Icons.dashboard_outlined, path: '/'),
  AdminNavItem(label: 'Users', icon: Icons.people_outline, path: '/users'),
  AdminNavItem(label: 'Courses', icon: Icons.menu_book_outlined, path: '/courses'),
  AdminNavItem(
    label: 'Instructor applications',
    icon: Icons.school_outlined,
    path: '/instructors',
  ),
  AdminNavItem(label: 'Refunds', icon: Icons.currency_exchange, path: '/refunds'),
  AdminNavItem(label: 'Payouts', icon: Icons.account_balance_wallet_outlined, path: '/payouts'),
  AdminNavItem(
    label: 'Broadcast notifications',
    icon: Icons.campaign_outlined,
    path: '/notifications',
  ),
];
