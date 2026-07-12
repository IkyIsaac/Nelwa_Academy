import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'empty_lessons_model.dart';
export 'empty_lessons_model.dart';

class EmptyLessonsWidget extends StatefulWidget {
  const EmptyLessonsWidget({
    super.key,
    required this.instructorRef,
  });

  final DocumentReference? instructorRef;

  @override
  State<EmptyLessonsWidget> createState() => _EmptyLessonsWidgetState();
}

class _EmptyLessonsWidgetState extends State<EmptyLessonsWidget> {
  late EmptyLessonsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptyLessonsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/documents.png',
              width: 150.0,
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(40.0, 24.0, 40.0, 0.0),
          child: Text(
            widget.instructorRef == currentUserReference
                ? 'No Lessons Yet'
                : 'No Lessons Available',
            textAlign: TextAlign.center,
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
                  lineHeight: 1.5,
                ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              40.0,
              8.0,
              40.0,
              valueOrDefault<double>(
                widget.instructorRef == currentUserReference ? 0.0 : 64.0,
                0.0,
              )),
          child: Text(
            widget.instructorRef == currentUserReference
                ? 'Start building your course by adding valuable lessons for your students.'
                : 'This course doesn\'t have any lessons yet. Please check back later or explore other courses.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  lineHeight: 1.5,
                ),
          ),
        ),
        if (widget.instructorRef == currentUserReference)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(40.0, 24.0, 40.0, 64.0),
            child: Text(
              FFLocalizations.of(context).getText(
                'rscxyg5h' /* Add Your First Lesson */,
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.normal,
                fontSize: 16.0,
                decoration: TextDecoration.underline,
                height: 1.0,
              ),
            ),
          ),
      ],
    );
  }
}
