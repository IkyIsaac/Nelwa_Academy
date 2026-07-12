import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';

import '/auth/base_auth_user_provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? HomePageWidget() : OnboardingWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? HomePageWidget() : OnboardingWidget(),
        ),
        FFRoute(
          name: HomePageWidget.routeName,
          path: HomePageWidget.routePath,
          builder: (context, params) => HomePageWidget(),
        ),
        FFRoute(
          name: OnboardingWidget.routeName,
          path: OnboardingWidget.routePath,
          builder: (context, params) => OnboardingWidget(),
        ),
        FFRoute(
          name: WelcomeWidget.routeName,
          path: WelcomeWidget.routePath,
          builder: (context, params) => WelcomeWidget(),
        ),
        FFRoute(
          name: SignUpWidget.routeName,
          path: SignUpWidget.routePath,
          builder: (context, params) => SignUpWidget(),
        ),
        FFRoute(
          name: SignInWidget.routeName,
          path: SignInWidget.routePath,
          builder: (context, params) => SignInWidget(),
        ),
        FFRoute(
          name: ResetPasswordWidget.routeName,
          path: ResetPasswordWidget.routePath,
          builder: (context, params) => ResetPasswordWidget(),
        ),
        FFRoute(
          name: VerifyCodeWidget.routeName,
          path: VerifyCodeWidget.routePath,
          builder: (context, params) => VerifyCodeWidget(
            verifyCode: params.getParam(
              'verifyCode',
              ParamType.String,
            ),
            email: params.getParam(
              'email',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CreatenewpasswordWidget.routeName,
          path: CreatenewpasswordWidget.routePath,
          builder: (context, params) => CreatenewpasswordWidget(),
        ),
        FFRoute(
          name: CompeteProfileWidget.routeName,
          path: CompeteProfileWidget.routePath,
          builder: (context, params) => CompeteProfileWidget(),
        ),
        FFRoute(
          name: InterestsWidget.routeName,
          path: InterestsWidget.routePath,
          builder: (context, params) => InterestsWidget(),
        ),
        FFRoute(
          name: ProfileWidget.routeName,
          path: ProfileWidget.routePath,
          builder: (context, params) => ProfileWidget(),
        ),
        FFRoute(
          name: PersonalInfoWidget.routeName,
          path: PersonalInfoWidget.routePath,
          builder: (context, params) => PersonalInfoWidget(),
        ),
        FFRoute(
          name: SecurityWidget.routeName,
          path: SecurityWidget.routePath,
          builder: (context, params) => SecurityWidget(),
        ),
        FFRoute(
          name: PaymentAccountWidget.routeName,
          path: PaymentAccountWidget.routePath,
          builder: (context, params) => PaymentAccountWidget(),
        ),
        FFRoute(
          name: SalesReportsWidget.routeName,
          path: SalesReportsWidget.routePath,
          builder: (context, params) => SalesReportsWidget(),
        ),
        FFRoute(
          name: NotificationsSettingsWidget.routeName,
          path: NotificationsSettingsWidget.routePath,
          builder: (context, params) => NotificationsSettingsWidget(),
        ),
        FFRoute(
          name: LanguageWidget.routeName,
          path: LanguageWidget.routePath,
          builder: (context, params) => LanguageWidget(),
        ),
        FFRoute(
          name: SupportWidget.routeName,
          path: SupportWidget.routePath,
          builder: (context, params) => SupportWidget(),
        ),
        FFRoute(
          name: HelpCenterWidget.routeName,
          path: HelpCenterWidget.routePath,
          builder: (context, params) => HelpCenterWidget(),
        ),
        FFRoute(
          name: AboutSkillBaseWidget.routeName,
          path: AboutSkillBaseWidget.routePath,
          builder: (context, params) => AboutSkillBaseWidget(),
        ),
        FFRoute(
          name: TermsandConditionsWidget.routeName,
          path: TermsandConditionsWidget.routePath,
          builder: (context, params) => TermsandConditionsWidget(),
        ),
        FFRoute(
          name: PrivacyPolicyWidget.routeName,
          path: PrivacyPolicyWidget.routePath,
          builder: (context, params) => PrivacyPolicyWidget(),
        ),
        FFRoute(
          name: CoursesByGroupWidget.routeName,
          path: CoursesByGroupWidget.routePath,
          builder: (context, params) => CoursesByGroupWidget(
            group: params.getParam(
              'group',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: NotificationsWidget.routeName,
          path: NotificationsWidget.routePath,
          builder: (context, params) => NotificationsWidget(),
        ),
        FFRoute(
          name: ReviewsWidget.routeName,
          path: ReviewsWidget.routePath,
          asyncParams: {
            'coursesDoc': getDoc(['courses'], CoursesRecord.fromSnapshot),
          },
          builder: (context, params) => ReviewsWidget(
            coursesDoc: params.getParam(
              'coursesDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: WriteReviewWidget.routeName,
          path: WriteReviewWidget.routePath,
          asyncParams: {
            'purchasedCoursesDoc': getDoc(['users', 'purchased_courses'],
                PurchasedCoursesRecord.fromSnapshot),
          },
          builder: (context, params) => WriteReviewWidget(
            purchasedCoursesDoc: params.getParam(
              'purchasedCoursesDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: LessonPageWidget.routeName,
          path: LessonPageWidget.routePath,
          asyncParams: {
            'lessonDoc':
                getDoc(['courses', 'lessons'], LessonsRecord.fromSnapshot),
            'courseDoc': getDoc(['courses'], CoursesRecord.fromSnapshot),
          },
          builder: (context, params) => LessonPageWidget(
            lessonDoc: params.getParam(
              'lessonDoc',
              ParamType.Document,
            ),
            courseDoc: params.getParam(
              'courseDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: CheckoutWidget.routeName,
          path: CheckoutWidget.routePath,
          builder: (context, params) => CheckoutWidget(),
        ),
        FFRoute(
          name: PaymentMethodWidget.routeName,
          path: PaymentMethodWidget.routePath,
          builder: (context, params) => PaymentMethodWidget(),
        ),
        FFRoute(
          name: LearnWidget.routeName,
          path: LearnWidget.routePath,
          builder: (context, params) => LearnWidget(),
        ),
        FFRoute(
          name: MyPaymentMethodsWidget.routeName,
          path: MyPaymentMethodsWidget.routePath,
          builder: (context, params) => MyPaymentMethodsWidget(),
        ),
        FFRoute(
          name: AddCreditCardWidget.routeName,
          path: AddCreditCardWidget.routePath,
          builder: (context, params) => AddCreditCardWidget(),
        ),
        FFRoute(
          name: CreditCardPageWidget.routeName,
          path: CreditCardPageWidget.routePath,
          asyncParams: {
            'paymentDoc': getDoc(
                ['users', 'payment_method'], PaymentMethodRecord.fromSnapshot),
          },
          builder: (context, params) => CreditCardPageWidget(
            paymentDoc: params.getParam(
              'paymentDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: PurchaseHistoryWidget.routeName,
          path: PurchaseHistoryWidget.routePath,
          builder: (context, params) => PurchaseHistoryWidget(),
        ),
        FFRoute(
          name: WishListWidget.routeName,
          path: WishListWidget.routePath,
          builder: (context, params) => WishListWidget(),
        ),
        FFRoute(
          name: SubscriptionsWidget.routeName,
          path: SubscriptionsWidget.routePath,
          builder: (context, params) => SubscriptionsWidget(),
        ),
        FFRoute(
          name: ActivityStatisticsWidget.routeName,
          path: ActivityStatisticsWidget.routePath,
          builder: (context, params) => ActivityStatisticsWidget(),
        ),
        FFRoute(
          name: MyReviewsWidget.routeName,
          path: MyReviewsWidget.routePath,
          builder: (context, params) => MyReviewsWidget(),
        ),
        FFRoute(
          name: BecomeAnInstructorWidget.routeName,
          path: BecomeAnInstructorWidget.routePath,
          builder: (context, params) => BecomeAnInstructorWidget(),
        ),
        FFRoute(
          name: InstructorOnboardingWidget.routeName,
          path: InstructorOnboardingWidget.routePath,
          builder: (context, params) => InstructorOnboardingWidget(),
        ),
        FFRoute(
          name: UpdateRoleWidget.routeName,
          path: UpdateRoleWidget.routePath,
          builder: (context, params) => UpdateRoleWidget(),
        ),
        FFRoute(
          name: FollowersWidget.routeName,
          path: FollowersWidget.routePath,
          asyncParams: {
            'instructorDoc': getDoc(['users', 'instructor_details'],
                InstructorDetailsRecord.fromSnapshot),
          },
          builder: (context, params) => FollowersWidget(
            instructorDoc: params.getParam(
              'instructorDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: CreatNewCourseWidget.routeName,
          path: CreatNewCourseWidget.routePath,
          builder: (context, params) => CreatNewCourseWidget(),
        ),
        FFRoute(
          name: SearchWidget.routeName,
          path: SearchWidget.routePath,
          builder: (context, params) => SearchWidget(),
        ),
        FFRoute(
          name: AllCategoriesPageWidget.routeName,
          path: AllCategoriesPageWidget.routePath,
          builder: (context, params) => AllCategoriesPageWidget(),
        ),
        FFRoute(
          name: CoursesByCategoryWidget.routeName,
          path: CoursesByCategoryWidget.routePath,
          builder: (context, params) => CoursesByCategoryWidget(
            category: params.getParam(
              'category',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CoursesByTagsWidget.routeName,
          path: CoursesByTagsWidget.routePath,
          builder: (context, params) => CoursesByTagsWidget(
            tag: params.getParam(
              'tag',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ExploreWidget.routeName,
          path: ExploreWidget.routePath,
          builder: (context, params) => ExploreWidget(),
        ),
        FFRoute(
          name: CoursesWidget.routeName,
          path: CoursesWidget.routePath,
          builder: (context, params) => CoursesWidget(),
        ),
        FFRoute(
          name: CreatNewLesssonWidget.routeName,
          path: CreatNewLesssonWidget.routePath,
          asyncParams: {
            'coursesDoc': getDoc(['courses'], CoursesRecord.fromSnapshot),
          },
          builder: (context, params) => CreatNewLesssonWidget(
            coursesDoc: params.getParam(
              'coursesDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: InstructorPageWidget.routeName,
          path: InstructorPageWidget.routePath,
          asyncParams: {
            'userDoc': getDoc(['users'], UsersRecord.fromSnapshot),
          },
          builder: (context, params) => InstructorPageWidget(
            userDoc: params.getParam(
              'userDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: LearnCoursesPageWidget.routeName,
          path: LearnCoursesPageWidget.routePath,
          asyncParams: {
            'coursesDoc': getDoc(['courses'], CoursesRecord.fromSnapshot),
          },
          builder: (context, params) => LearnCoursesPageWidget(
            coursesDoc: params.getParam(
              'coursesDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: LearnLessonPageWidget.routeName,
          path: LearnLessonPageWidget.routePath,
          asyncParams: {
            'lessonDoc':
                getDoc(['courses', 'lessons'], LessonsRecord.fromSnapshot),
            'coursesDoc': getDoc(['courses'], CoursesRecord.fromSnapshot),
          },
          builder: (context, params) => LearnLessonPageWidget(
            lessonDoc: params.getParam(
              'lessonDoc',
              ParamType.Document,
            ),
            coursesDoc: params.getParam(
              'coursesDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: RequestaRefundWidget.routeName,
          path: RequestaRefundWidget.routePath,
          asyncParams: {
            'purchasedCoursesDoc': getDoc(['users', 'purchased_courses'],
                PurchasedCoursesRecord.fromSnapshot),
          },
          builder: (context, params) => RequestaRefundWidget(
            purchasedCoursesDoc: params.getParam(
              'purchasedCoursesDoc',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: PaymentSetupWidget.routeName,
          path: PaymentSetupWidget.routePath,
          builder: (context, params) => PaymentSetupWidget(),
        ),
        FFRoute(
          name: AnalyticsWidget.routeName,
          path: AnalyticsWidget.routePath,
          builder: (context, params) => AnalyticsWidget(),
        ),
        FFRoute(
          name: InstructorCoursesWidget.routeName,
          path: InstructorCoursesWidget.routePath,
          builder: (context, params) => InstructorCoursesWidget(
            instructorRef: params.getParam(
              'instructorRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['users'],
            ),
          ),
        ),
        FFRoute(
          name: CoursesByTopicsWidget.routeName,
          path: CoursesByTopicsWidget.routePath,
          builder: (context, params) => CoursesByTopicsWidget(
            topic: params.getParam(
              'topic',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CoursesPageCopyWidget.routeName,
          path: CoursesPageCopyWidget.routePath,
          asyncParams: {
            'coursesDoc': getDoc(['courses'], CoursesRecord.fromSnapshot),
          },
          builder: (context, params) => CoursesPageCopyWidget(
            coursesDoc: params.getParam(
              'coursesDoc',
              ParamType.Document,
            ),
            lessons: params.getParam(
              'lessons',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['courses', 'lessons'],
            ),
          ),
        ),
        FFRoute(
          name: CoursesPageCopyCopyWidget.routeName,
          path: CoursesPageCopyCopyWidget.routePath,
          asyncParams: {
            'coursesDoc': getDoc(['courses'], CoursesRecord.fromSnapshot),
          },
          builder: (context, params) => CoursesPageCopyCopyWidget(
            coursesDoc: params.getParam(
              'coursesDoc',
              ParamType.Document,
            ),
            lessons: params.getParam(
              'lessons',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['courses', 'lessons'],
            ),
          ),
        ),
        FFRoute(
          name: LearnCopyWidget.routeName,
          path: LearnCopyWidget.routePath,
          builder: (context, params) => LearnCopyWidget(),
        ),
        FFRoute(
          name: ConsultationWidget.routeName,
          path: ConsultationWidget.routePath,
          builder: (context, params) => ConsultationWidget(),
        ),
        FFRoute(
          name: ConsultationpageWidget.routeName,
          path: ConsultationpageWidget.routePath,
          builder: (context, params) => ConsultationpageWidget(),
        ),
        FFRoute(
          name: TermsandConditionsCopyWidget.routeName,
          path: TermsandConditionsCopyWidget.routePath,
          builder: (context, params) => TermsandConditionsCopyWidget(),
        ),
        FFRoute(
          name: MobileMoneyWidget.routeName,
          path: MobileMoneyWidget.routePath,
          builder: (context, params) => MobileMoneyWidget(),
        ),
        FFRoute(
          name: CheckoutCopyWidget.routeName,
          path: CheckoutCopyWidget.routePath,
          builder: (context, params) => CheckoutCopyWidget(
            yearly: params.getParam(
              'yearly',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: OptionPageWidget.routeName,
          path: OptionPageWidget.routePath,
          builder: (context, params) => OptionPageWidget(),
        ),
        FFRoute(
          name: ConsultationssWidget.routeName,
          path: ConsultationssWidget.routePath,
          builder: (context, params) => ConsultationssWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: [routeObserver],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/onboarding';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? isWeb
                  ? Container()
                  : Container(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: Center(
                        child: Image.asset(
                          'assets/images/NELWAS_@4x.png',
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.none,
                        ),
                      ),
                    )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
