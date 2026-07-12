import '/buttons/text_right/text_right_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'about_skill_base_model.dart';
export 'about_skill_base_model.dart';

class AboutSkillBaseWidget extends StatefulWidget {
  const AboutSkillBaseWidget({super.key});

  static String routeName = 'AboutSkillBase';
  static String routePath = '/aboutSkillBase';

  @override
  State<AboutSkillBaseWidget> createState() => _AboutSkillBaseWidgetState();
}

class _AboutSkillBaseWidgetState extends State<AboutSkillBaseWidget> {
  late AboutSkillBaseModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AboutSkillBaseModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              '256dxpjt' /* About Nelway's Academy */,
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 281.5,
                  height: 152.5,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 42.0, 0.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(TermsandConditionsWidget.routeName);
                  },
                  child: wrapWithModel(
                    model: _model.textRightModel1,
                    updateCallback: () => safeSetState(() {}),
                    child: TextRightWidget(
                      text: FFLocalizations.of(context).getText(
                        'iia4iy9i' /* Terms and Conditions */,
                      ),
                      description: FFLocalizations.of(context).getText(
                        'm6adssnr' /* Read the rules and terms for u... */,
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
                    context.pushNamed(PrivacyPolicyWidget.routeName);
                  },
                  child: wrapWithModel(
                    model: _model.textRightModel2,
                    updateCallback: () => safeSetState(() {}),
                    child: TextRightWidget(
                      text: FFLocalizations.of(context).getText(
                        'bbey4ypf' /* Privacy Policy */,
                      ),
                      description: FFLocalizations.of(context).getText(
                        'k7hx1vvl' /* Learn how we handle your data ... */,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: wrapWithModel(
                  model: _model.textRightModel3,
                  updateCallback: () => safeSetState(() {}),
                  child: TextRightWidget(
                    text: FFLocalizations.of(context).getText(
                      '3f5ql24g' /* Job Vacancy */,
                    ),
                    description: FFLocalizations.of(context).getText(
                      '4t6n8qbr' /* Want to join the Cookio team? ... */,
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
                    context.pushNamed(SupportWidget.routeName);
                  },
                  child: wrapWithModel(
                    model: _model.textRightModel4,
                    updateCallback: () => safeSetState(() {}),
                    child: TextRightWidget(
                      text: FFLocalizations.of(context).getText(
                        'atse1r4x' /* Contact Us */,
                      ),
                      description: FFLocalizations.of(context).getText(
                        'da9xr2sv' /* Need help or have suggestions?... */,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: wrapWithModel(
                  model: _model.textRightModel5,
                  updateCallback: () => safeSetState(() {}),
                  child: TextRightWidget(
                    text: FFLocalizations.of(context).getText(
                      'kg63auef' /* Accessibility */,
                    ),
                    description: FFLocalizations.of(context).getText(
                      'kueyrtbf' /* We strive to make SkillBase ac... */,
                    ),
                  ),
                ),
              ),
            ]
                .addToStart(SizedBox(height: 42.0))
                .addToEnd(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}
