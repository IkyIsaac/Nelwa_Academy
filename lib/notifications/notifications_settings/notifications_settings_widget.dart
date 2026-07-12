import '/buttons/text_switch/text_switch_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notifications_settings_model.dart';
export 'notifications_settings_model.dart';

class NotificationsSettingsWidget extends StatefulWidget {
  const NotificationsSettingsWidget({super.key});

  static String routeName = 'NotificationsSettings';
  static String routePath = '/notificationsSettings';

  @override
  State<NotificationsSettingsWidget> createState() =>
      _NotificationsSettingsWidgetState();
}

class _NotificationsSettingsWidgetState
    extends State<NotificationsSettingsWidget> {
  late NotificationsSettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsSettingsModel());

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).transparent,
              borderRadius: 22.0,
              borderWidth: 1.0,
              buttonSize: 44.0,
              icon: Icon(
                FFIcons.karrowLeft,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              'hl89jbie' /* Notifications Settings */,
            ),
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().courseActivityAlerts) {
                    FFAppState().courseActivityAlerts = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().courseActivityAlerts = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel1,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      'v4avybkp' /* Course Activity Alerts */,
                    ),
                    switchBoolean: FFAppState().courseActivityAlerts,
                    description: FFLocalizations.of(context).getText(
                      'd6759atl' /* Get notified about new enrollm... */,
                    ),
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().feedbackReviews) {
                    FFAppState().feedbackReviews = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().feedbackReviews = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel2,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      'li7r4k19' /* Feedback & Reviews */,
                    ),
                    switchBoolean: FFAppState().feedbackReviews,
                    description: FFLocalizations.of(context).getText(
                      'h4o8h938' /* Stay informed about new studen... */,
                    ),
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().systemAnnouncements) {
                    FFAppState().systemAnnouncements = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().systemAnnouncements = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel3,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      '8k8zs0pk' /* System Announcements */,
                    ),
                    switchBoolean: FFAppState().systemAnnouncements,
                    description: FFLocalizations.of(context).getText(
                      '2ovkjki1' /* Be the first to know about pla... */,
                    ),
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().earningsUpdates) {
                    FFAppState().earningsUpdates = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().earningsUpdates = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel4,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      '2cgpyozl' /* Payment & Earnings Updates */,
                    ),
                    switchBoolean: FFAppState().earningsUpdates,
                    description: FFLocalizations.of(context).getText(
                      '9t5oxi7u' /* Get notifications about new pa... */,
                    ),
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().certificateRequests) {
                    FFAppState().certificateRequests = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().certificateRequests = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel5,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      'dhvse64k' /* Certificate Requests */,
                    ),
                    switchBoolean: FFAppState().certificateRequests,
                    description: FFLocalizations.of(context).getText(
                      'bduonwem' /* Receive alerts when students r... */,
                    ),
                  ),
                ),
              ),
            ]
                .divide(SizedBox(height: 24.0))
                .addToStart(SizedBox(height: 16.0))
                .addToEnd(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}
