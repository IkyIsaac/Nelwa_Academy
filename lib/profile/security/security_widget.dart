import '/buttons/text_switch/text_switch_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'security_model.dart';
export 'security_model.dart';

class SecurityWidget extends StatefulWidget {
  const SecurityWidget({super.key});

  static String routeName = 'Security';
  static String routePath = '/security';

  @override
  State<SecurityWidget> createState() => _SecurityWidgetState();
}

class _SecurityWidgetState extends State<SecurityWidget> {
  late SecurityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SecurityModel());

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
              'b1grrayh' /* Security */,
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
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            0,
            16.0,
            0,
            24.0,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (FFAppState().rememberMe) {
                  FFAppState().rememberMe = false;
                  safeSetState(() {});
                } else {
                  FFAppState().rememberMe = true;
                  safeSetState(() {});
                }
              },
              child: wrapWithModel(
                model: _model.textSwitchModel1,
                updateCallback: () => safeSetState(() {}),
                child: TextSwitchWidget(
                  text: FFLocalizations.of(context).getText(
                    '04y7r26a' /* Remember me */,
                  ),
                  switchBoolean: FFAppState().rememberMe,
                  description: FFLocalizations.of(context).getText(
                    '0htpr3si' /* Stay signed in on this device. */,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().biometricID) {
                    FFAppState().biometricID = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().biometricID = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel2,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      '1yq8glsm' /* Biometric ID */,
                    ),
                    switchBoolean: FFAppState().biometricID,
                    description: FFLocalizations.of(context).getText(
                      'l9f5qpk8' /* Use fingerprint to sign in sec... */,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().faceID) {
                    FFAppState().faceID = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().faceID = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel3,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      'cd8m85bi' /* Face ID */,
                    ),
                    switchBoolean: FFAppState().faceID,
                    description: FFLocalizations.of(context).getText(
                      'm8e08880' /* Use Face ID to sign in quickly... */,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().smsAuthenticator) {
                    FFAppState().smsAuthenticator = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().smsAuthenticator = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel4,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      'o2d5js42' /* SMS Authenticator */,
                    ),
                    switchBoolean: FFAppState().smsAuthenticator,
                    description: FFLocalizations.of(context).getText(
                      '3rhpk4t3' /* Receive a verification code vi... */,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().googleAuthenticator) {
                    FFAppState().googleAuthenticator = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().googleAuthenticator = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel5,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      '57atblbu' /* Google Authenticator */,
                    ),
                    switchBoolean: FFAppState().googleAuthenticator,
                    description: FFLocalizations.of(context).getText(
                      '665eb3ey' /* Use Google Authenticator for t... */,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (FFAppState().deviceManagement) {
                    FFAppState().deviceManagement = false;
                    safeSetState(() {});
                  } else {
                    FFAppState().deviceManagement = true;
                    safeSetState(() {});
                  }
                },
                child: wrapWithModel(
                  model: _model.textSwitchModel6,
                  updateCallback: () => safeSetState(() {}),
                  child: TextSwitchWidget(
                    text: FFLocalizations.of(context).getText(
                      'v0smchxp' /* Device Management */,
                    ),
                    switchBoolean: FFAppState().deviceManagement,
                    description: FFLocalizations.of(context).getText(
                      '6adcdb1l' /* Manage and view all devices li... */,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
