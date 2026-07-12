import '/auth/firebase_auth/auth_util.dart';
import '/buttons/icon_text_right/icon_text_right_widget.dart';
import '/buttons/icon_text_switch/icon_text_switch_widget.dart';
import '/buttons/icon_text_text_right/icon_text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/nav_bar/nav_bar_widget.dart';
import '/profile/components/account_role/account_role_widget.dart';
import '/profile/components/sign_out/sign_out_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  static String routeName = 'Profile';
  static String routePath = '/profile';

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with TickerProviderStateMixin {
  late ProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().navBar = 3;
      safeSetState(() {});
    });

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: Offset(0.95, 0.95),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 56.0, 0.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        if (valueOrDefault<bool>(
                            currentUserDocument?.instructor, false)) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: AccountRoleWidget(),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).info,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 14.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      valueOrDefault<String>(
                                        valueOrDefault(
                                            currentUserDocument?.role, ''),
                                        'null',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF242424),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                    ),
                                    Icon(
                                      FFIcons.kchevronDown,
                                      color: Color(0xFF242424),
                                      size: 20.0,
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  BecomeAnInstructorWidget.routeName);
                            },
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'fd6q08z5' /* Want to become an instructor? */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: AuthUserStreamWidget(
                      builder: (context) => Container(
                        width: 110.0,
                        height: 110.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).info,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.network(
                              currentUserPhoto != ''
                                  ? currentUserPhoto
                                  : FFAppConstants.user,
                            ).image,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).info,
                            width: 3.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                    child: AuthUserStreamWidget(
                      builder: (context) => Text(
                        currentUserDisplayName,
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).info,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontStyle,
                              lineHeight: 1.0,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 32.0),
                    child: Text(
                      currentUserEmail,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).info,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                            lineHeight: 1.0,
                          ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22.0),
                        topRight: Radius.circular(22.0),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                          PersonalInfoWidget.routeName);
                                    },
                                    child: wrapWithModel(
                                      model: _model.iconTextRightModel1,
                                      updateCallback: () => safeSetState(() {}),
                                      child: IconTextRightWidget(
                                        text:
                                            FFLocalizations.of(context).getText(
                                          '0ny108w4' /* Personal Info */,
                                        ),
                                        icon: Icon(
                                          FFIcons.kuserCircle,
                                          color: FlutterFlowTheme.of(context)
                                              .iconColor,
                                          size: 24.0,
                                        ),
                                        textColor: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        showDivider: true,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context
                                          .pushNamed(SecurityWidget.routeName);
                                    },
                                    child: wrapWithModel(
                                      model: _model.iconTextRightModel2,
                                      updateCallback: () => safeSetState(() {}),
                                      child: IconTextRightWidget(
                                        text:
                                            FFLocalizations.of(context).getText(
                                          '8h2uvtzv' /* Security */,
                                        ),
                                        icon: Icon(
                                          FFIcons.kshield02,
                                          color: FlutterFlowTheme.of(context)
                                              .iconColor,
                                          size: 24.0,
                                        ),
                                        textColor: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        showDivider: true,
                                      ),
                                    ),
                                  ),
                                  AuthUserStreamWidget(
                                    builder: (context) => InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (valueOrDefault(
                                                currentUserDocument?.role,
                                                '') ==
                                            'Instructor') {
                                          context.pushNamed(
                                              PaymentAccountWidget.routeName);
                                        } else {
                                          context.pushNamed(
                                              MyPaymentMethodsWidget.routeName);
                                        }
                                      },
                                      child: wrapWithModel(
                                        model: _model.iconTextRightModel3,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: IconTextRightWidget(
                                          text: valueOrDefault(
                                                      currentUserDocument?.role,
                                                      '') ==
                                                  'Instructor'
                                              ? 'Payment Account'
                                              : 'Payment Methods',
                                          icon: Icon(
                                            FFIcons.kcreditCard,
                                            color: FlutterFlowTheme.of(context)
                                                .iconColor,
                                            size: 24.0,
                                          ),
                                          textColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          showDivider: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  AuthUserStreamWidget(
                                    builder: (context) => InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (valueOrDefault(
                                                currentUserDocument?.role,
                                                '') ==
                                            'Instructor') {
                                          context.pushNamed(
                                              SalesReportsWidget.routeName);
                                        } else {
                                          context.pushNamed(
                                              PurchaseHistoryWidget.routeName);
                                        }
                                      },
                                      child: wrapWithModel(
                                        model: _model.iconTextRightModel4,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: IconTextRightWidget(
                                          text: valueOrDefault(
                                                      currentUserDocument?.role,
                                                      '') ==
                                                  'Instructor'
                                              ? 'Sales reports'
                                              : 'Purchase History',
                                          icon: Icon(
                                            FFIcons.khistoryToggle,
                                            color: FlutterFlowTheme.of(context)
                                                .iconColor,
                                            size: 24.0,
                                          ),
                                          textColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          showDivider: valueOrDefault(
                                                      currentUserDocument?.role,
                                                      '') ==
                                                  'Instructor'
                                              ? true
                                              : false,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (valueOrDefault(
                                          currentUserDocument?.role, '') ==
                                      'Instructor')
                                    AuthUserStreamWidget(
                                      builder: (context) => InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                              AnalyticsWidget.routeName);
                                        },
                                        child: wrapWithModel(
                                          model: _model.iconTextRightModel5,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: IconTextRightWidget(
                                            text: FFLocalizations.of(context)
                                                .getText(
                                              '4eiq3wnh' /* Analytics */,
                                            ),
                                            icon: Icon(
                                              FFIcons.kreportAnalytics,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .iconColor,
                                              size: 24.0,
                                            ),
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            showDivider: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (valueOrDefault(currentUserDocument?.role, '') ==
                              'Learner')
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 16.0, 0.0, 0.0),
                              child: AuthUserStreamWidget(
                                builder: (context) => Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                              WishListWidget.routeName);
                                        },
                                        child: wrapWithModel(
                                          model: _model.iconTextRightModel6,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: IconTextRightWidget(
                                            text: FFLocalizations.of(context)
                                                .getText(
                                              'rly9o702' /* Wish List */,
                                            ),
                                            icon: Icon(
                                              FFIcons.kbookmark,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .iconColor,
                                              size: 24.0,
                                            ),
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            showDivider: true,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                              SubscriptionsWidget.routeName);
                                        },
                                        child: wrapWithModel(
                                          model: _model.iconTextRightModel7,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: IconTextRightWidget(
                                            text: FFLocalizations.of(context)
                                                .getText(
                                              'fdbetejg' /* Subscriptions */,
                                            ),
                                            icon: Icon(
                                              FFIcons.kusersPlus,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .iconColor,
                                              size: 24.0,
                                            ),
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            showDivider: true,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                              ActivityStatisticsWidget
                                                  .routeName);
                                        },
                                        child: wrapWithModel(
                                          model: _model.iconTextRightModel8,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: IconTextRightWidget(
                                            text: FFLocalizations.of(context)
                                                .getText(
                                              '5ntverai' /* Activity Statistics */,
                                            ),
                                            icon: Icon(
                                              FFIcons.kbarChart10,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .iconColor,
                                              size: 24.0,
                                            ),
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            showDivider: true,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                              MyReviewsWidget.routeName);
                                        },
                                        child: wrapWithModel(
                                          model: _model.iconTextRightModel9,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: IconTextRightWidget(
                                            text: FFLocalizations.of(context)
                                                .getText(
                                              'hrms9g08' /* My Reviews */,
                                            ),
                                            icon: Icon(
                                              FFIcons.kmessageCircle2,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .iconColor,
                                              size: 24.0,
                                            ),
                                            textColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            showDivider: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                          NotificationsSettingsWidget
                                              .routeName);
                                    },
                                    child: wrapWithModel(
                                      model: _model.iconTextRightModel10,
                                      updateCallback: () => safeSetState(() {}),
                                      child: IconTextRightWidget(
                                        text:
                                            FFLocalizations.of(context).getText(
                                          '8wjs06xv' /* Notifications */,
                                        ),
                                        icon: Icon(
                                          FFIcons.kbell,
                                          color: FlutterFlowTheme.of(context)
                                              .iconColor,
                                          size: 24.0,
                                        ),
                                        textColor: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        showDivider: true,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context
                                          .pushNamed(LanguageWidget.routeName);
                                    },
                                    child: wrapWithModel(
                                      model: _model.iconTextTextRightModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: IconTextTextRightWidget(
                                        text:
                                            FFLocalizations.of(context).getText(
                                          'efv1yewh' /* Language */,
                                        ),
                                        icon: Icon(
                                          FFIcons.kworld,
                                          color: FlutterFlowTheme.of(context)
                                              .iconColor,
                                          size: 24.0,
                                        ),
                                        textColor: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        showDivider: true,
                                        rigthText:
                                            FFAppState().selectedLang.language,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (FFAppState().darkMode) {
                                        FFAppState().darkMode = false;
                                        safeSetState(() {});
                                      } else {
                                        FFAppState().darkMode = true;
                                        safeSetState(() {});
                                      }
                                    },
                                    child: wrapWithModel(
                                      model: _model.iconTextSwitchModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: IconTextSwitchWidget(
                                        text:
                                            FFLocalizations.of(context).getText(
                                          '0l6j4g8y' /* Dark Mode */,
                                        ),
                                        icon: Icon(
                                          FFIcons.ksun,
                                          color: FlutterFlowTheme.of(context)
                                              .iconColor,
                                          size: 24.0,
                                        ),
                                        textColor: FlutterFlowTheme.of(context)
                                            .iconColor,
                                        showDivider: true,
                                        switchBoolean: FFAppState().darkMode,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context
                                          .pushNamed(SupportWidget.routeName);
                                    },
                                    child: wrapWithModel(
                                      model: _model.iconTextRightModel11,
                                      updateCallback: () => safeSetState(() {}),
                                      child: IconTextRightWidget(
                                        text:
                                            FFLocalizations.of(context).getText(
                                          'itgmtteg' /* Support */,
                                        ),
                                        icon: Icon(
                                          FFIcons.khelpCircle,
                                          color: FlutterFlowTheme.of(context)
                                              .iconColor,
                                          size: 24.0,
                                        ),
                                        textColor: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        showDivider: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                          HelpCenterWidget.routeName);
                                    },
                                    child: wrapWithModel(
                                      model: _model.iconTextRightModel12,
                                      updateCallback: () => safeSetState(() {}),
                                      child: IconTextRightWidget(
                                        text:
                                            FFLocalizations.of(context).getText(
                                          '4dbmn8i1' /* Help Center */,
                                        ),
                                        icon: Icon(
                                          FFIcons.kfileText,
                                          color: FlutterFlowTheme.of(context)
                                              .iconColor,
                                          size: 24.0,
                                        ),
                                        textColor: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        showDivider: true,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                          AboutSkillBaseWidget.routeName);
                                    },
                                    child: wrapWithModel(
                                      model: _model.iconTextRightModel13,
                                      updateCallback: () => safeSetState(() {}),
                                      child: IconTextRightWidget(
                                        text:
                                            FFLocalizations.of(context).getText(
                                          'afiejruc' /* About Nelwa's Academy */,
                                        ),
                                        icon: Icon(
                                          FFIcons.kinfoSquareRounded,
                                          color: FlutterFlowTheme.of(context)
                                              .iconColor,
                                          size: 24.0,
                                        ),
                                        textColor: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        showDivider: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 24.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Builder(
                                builder: (context) => InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await showDialog(
                                      barrierColor: FlutterFlowTheme.of(context)
                                          .background,
                                      context: context,
                                      builder: (dialogContext) {
                                        return Dialog(
                                          elevation: 0,
                                          insetPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          alignment: AlignmentDirectional(
                                                  0.0, 0.0)
                                              .resolve(
                                                  Directionality.of(context)),
                                          child: GestureDetector(
                                            onTap: () {
                                              FocusScope.of(dialogContext)
                                                  .unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: SignOutWidget(),
                                          ),
                                        );
                                      },
                                    );

                                    context
                                        .pushNamed(OnboardingWidget.routeName);
                                  },
                                  child: wrapWithModel(
                                    model: _model.iconTextRightModel14,
                                    updateCallback: () => safeSetState(() {}),
                                    child: IconTextRightWidget(
                                      text: FFLocalizations.of(context).getText(
                                        '1hx86a4t' /* Sign Out */,
                                      ),
                                      icon: Icon(
                                        FFIcons.klogout,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 24.0,
                                      ),
                                      textColor:
                                          FlutterFlowTheme.of(context).error,
                                      showDivider: false,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!),
              wrapWithModel(
                model: _model.navBarModel,
                updateCallback: () => safeSetState(() {}),
                child: NavBarWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
