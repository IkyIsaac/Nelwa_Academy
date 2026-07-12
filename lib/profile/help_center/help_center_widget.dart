import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/profile/components/faq/faq_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'help_center_model.dart';
export 'help_center_model.dart';

class HelpCenterWidget extends StatefulWidget {
  const HelpCenterWidget({super.key});

  static String routeName = 'HelpCenter';
  static String routePath = '/helpCenter';

  @override
  State<HelpCenterWidget> createState() => _HelpCenterWidgetState();
}

class _HelpCenterWidgetState extends State<HelpCenterWidget> {
  late HelpCenterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpCenterModel());

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
              'xdn4i8be' /* Help Center */,
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
              wrapWithModel(
                model: _model.faqModel1,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: FFLocalizations.of(context).getText(
                    'fy70vwlg' /* What is Nelway's Academy? */,
                  ),
                  answer: FFLocalizations.of(context).getText(
                    'ugu570dm' /* Nelways's academy is an online... */,
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.faqModel2,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: FFLocalizations.of(context).getText(
                    '49uhacnr' /* How do I create an account? */,
                  ),
                  answer: FFLocalizations.of(context).getText(
                    'tbqakmhs' /* You can sign up using your ema... */,
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.faqModel3,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: FFLocalizations.of(context).getText(
                    'nl62lcfo' /* Is Nelway's Academy free to us... */,
                  ),
                  answer: FFLocalizations.of(context).getText(
                    'it39nxva' /* Nelway's Acedmy  offers both f... */,
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.faqModel4,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: FFLocalizations.of(context).getText(
                    '4mfwx7vm' /* How do I enroll in a course? */,
                  ),
                  answer: FFLocalizations.of(context).getText(
                    'eflfo6zq' /* Browse courses in the app, sel... */,
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.faqModel5,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: FFLocalizations.of(context).getText(
                    'r94xfd4p' /* Can I download courses for off... */,
                  ),
                  answer: FFLocalizations.of(context).getText(
                    'ygyr9qo6' /* Yes, some courses allow offlin... */,
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.faqModel6,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'Can I download courses for offline viewing?',
                  answer:
                      'Yes, some courses allow offline access. Check the course details for availability.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel7,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'Can I download courses for offline viewing?',
                  answer:
                      'Yes, some courses allow offline access. Check the course details for availability.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel8,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'How long do I have access to a purchased course?',
                  answer:
                      'Once purchased, you get lifetime access unless otherwise stated.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel9,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions:
                      'Will I receive a certificate after completing a course?',
                  answer:
                      'Yes! Many courses provide a certificate upon completion.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel10,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'What payment methods are available?',
                  answer:
                      'We accept credit/debit cards, PayPal, and other digital payment methods.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel11,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'Can I get a refund if I’m not satisfied?',
                  answer:
                      'Refunds are available within 7 days of purchase, provided you haven\'t completed more than 20% of the course.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel12,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'Is there a subscription option?',
                  answer:
                      'Yes, you can subscribe to get access to multiple courses at a discounted rate.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel13,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'Can I change my email or username?',
                  answer:
                      'Yes, in Settings → Profile, but some restrictions apply.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel14,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'How do I reset my password?',
                  answer:
                      'Yes, you can subscribe to get access to multiple courses at a discounted rate.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel15,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'How do I delete my account?',
                  answer:
                      'You can request account deletion in Settings → Privacy or contact support.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel16,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions:
                      'I\'m having trouble playing a video. What should I do?',
                  answer:
                      'Check your internet connection, update the app, or try clearing the cache in Settings → Storage.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel17,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'I can’t log in. What should I do?',
                  answer:
                      'Make sure you entered the correct credentials. If you forgot your password, reset it using the Forgot Password option.',
                ),
              ),
              wrapWithModel(
                model: _model.faqModel18,
                updateCallback: () => safeSetState(() {}),
                child: FaqWidget(
                  questions: 'How do I contact customer support?',
                  answer:
                      'You can reach us via email at support@skillbase.com or through the Help Center in the app.',
                ),
              ),
            ]
                .divide(SizedBox(height: 12.0))
                .addToStart(SizedBox(height: 16.0))
                .addToEnd(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}
