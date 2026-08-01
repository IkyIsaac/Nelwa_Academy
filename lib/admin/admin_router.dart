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
          GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UsersListPage(),
          ),
          GoRoute(
            path: '/users/:id',
            builder: (context, state) =>
                UserDetailPage(userId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/courses',
            builder: (context, state) => const CoursesListPage(),
          ),
          GoRoute(
            path: '/courses/:id',
            builder: (context, state) =>
                CourseDetailPage(courseId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/instructors',
            builder: (context, state) => const InstructorApplicationsPage(),
          ),
          GoRoute(
            path: '/refunds',
            builder: (context, state) => const RefundsPage(),
          ),
          GoRoute(
            path: '/payouts',
            builder: (context, state) => const PayoutsPage(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const BroadcastPage(),
          ),
        ],
      ),
    ],
  );
}
