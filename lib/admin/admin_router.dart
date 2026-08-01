import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'admin_auth_notifier.dart';
import 'auth/admin_login_page.dart';
import 'shell/admin_shell.dart';
import 'dashboard/dashboard_page.dart';
import 'users/users_list_page.dart';
import 'users/user_detail_page.dart';
import 'courses/courses_list_page.dart';
import 'courses/course_detail_page.dart';
import 'instructors/instructor_applications_page.dart';
import 'refunds/refunds_page.dart';
import 'payouts/payouts_page.dart';
import 'notifications/broadcast_page.dart';

/// Every nav-rail destination fades in rather than sliding/scaling — the
/// default Material page transition renders the outgoing and incoming
/// pages together mid-animation, and since they're different heights that
/// briefly overflows the shell's content area (visible as Flutter's
/// yellow/black debug overflow banner). A pure opacity fade doesn't touch
/// layout at all, so it can't trigger that, and it reads as calmer for
/// switching between sibling sections of one console than a slide would.
Page<void> _fadePage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: const Duration(milliseconds: 160),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// A brand-new, independent GoRouter — deliberately not `createRouter` from
/// lib/flutter_flow/nav/nav.dart, since that router's guard only checks
/// `loggedIn`, not admin access.
GoRouter createAdminRouter(AdminAuthNotifier authNotifier) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      final authorized = authNotifier.user != null && authNotifier.isAdmin;
      if (!authorized) return loggingIn ? null : '/login';
      if (loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AdminLoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AdminShell(currentPath: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => _fadePage(const DashboardPage()),
          ),
          GoRoute(
            path: '/users',
            pageBuilder: (context, state) => _fadePage(const UsersListPage()),
          ),
          GoRoute(
            path: '/users/:id',
            pageBuilder: (context, state) =>
                _fadePage(UserDetailPage(userId: state.pathParameters['id']!)),
          ),
          GoRoute(
            path: '/courses',
            pageBuilder: (context, state) => _fadePage(const CoursesListPage()),
          ),
          GoRoute(
            path: '/courses/:id',
            pageBuilder: (context, state) => _fadePage(
                CourseDetailPage(courseId: state.pathParameters['id']!)),
          ),
          GoRoute(
            path: '/instructors',
            pageBuilder: (context, state) =>
                _fadePage(const InstructorApplicationsPage()),
          ),
          GoRoute(
            path: '/refunds',
            pageBuilder: (context, state) => _fadePage(const RefundsPage()),
          ),
          GoRoute(
            path: '/payouts',
            pageBuilder: (context, state) => _fadePage(const PayoutsPage()),
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (context, state) => _fadePage(const BroadcastPage()),
          ),
        ],
      ),
    ],
  );
}
