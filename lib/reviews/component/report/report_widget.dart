import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/reviews/component/reports_type/reports_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'report_model.dart';
export 'report_model.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({
    super.key,
    this.reviewRef,
    this.coursesRef,
    this.lessonRef,
  });

  final DocumentReference? reviewRef;
  final DocumentReference? coursesRef;
  final DocumentReference? lessonRef;

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  late ReportModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 24.0, 16.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            '3axlrydl' /* Report an Issue */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                                lineHeight: 1.0,
                              ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 24.0, 16.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'qf277srk' /* Encountering a problem? Let us... */,
                          ),
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                    lineHeight: 1.5,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (widget.reviewRef != null) {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 24.0, 16.0, 24.0),
                      child: Builder(
                        builder: (context) {
                          final reportsType = _model.reviewReports.toList();

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(reportsType.length,
                                  (reportsTypeIndex) {
                                final reportsTypeItem =
                                    reportsType[reportsTypeIndex];
                                return Expanded(
                                  child: wrapWithModel(
                                    model: _model.reportsTypeModels1.getModel(
                                      reportsTypeIndex.toString(),
                                      reportsTypeIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ReportsTypeWidget(
                                      key: Key(
                                        'Keyrgy_${reportsTypeIndex.toString()}',
                                      ),
                                      reportType: reportsTypeItem,
                                      showDivider:
                                          _model.reviewReports.lastOrNull ==
                                                  reportsTypeItem
                                              ? false
                                              : true,
                                      reviewRef: widget.reviewRef,
                                      coursesRef: widget.coursesRef,
                                      lessonRef: widget.lessonRef,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (widget.coursesRef != null) {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 24.0, 16.0, 24.0),
                      child: Builder(
                        builder: (context) {
                          final coursesType = _model.coursesReports.toList();

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(coursesType.length,
                                  (coursesTypeIndex) {
                                final coursesTypeItem =
                                    coursesType[coursesTypeIndex];
                                return Expanded(
                                  child: wrapWithModel(
                                    model: _model.reportsTypeModels2.getModel(
                                      coursesTypeIndex.toString(),
                                      coursesTypeIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ReportsTypeWidget(
                                      key: Key(
                                        'Key7m7_${coursesTypeIndex.toString()}',
                                      ),
                                      reportType: coursesTypeItem,
                                      showDivider:
                                          _model.reviewReports.lastOrNull ==
                                                  coursesTypeItem
                                              ? false
                                              : true,
                                      reviewRef: widget.reviewRef,
                                      coursesRef: widget.coursesRef,
                                      lessonRef: widget.lessonRef,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 24.0, 16.0, 24.0),
                      child: Builder(
                        builder: (context) {
                          final lessonsType = _model.lessonReports.toList();

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(lessonsType.length,
                                  (lessonsTypeIndex) {
                                final lessonsTypeItem =
                                    lessonsType[lessonsTypeIndex];
                                return Expanded(
                                  child: wrapWithModel(
                                    model: _model.reportsTypeModels3.getModel(
                                      lessonsTypeIndex.toString(),
                                      lessonsTypeIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ReportsTypeWidget(
                                      key: Key(
                                        'Key0kj_${lessonsTypeIndex.toString()}',
                                      ),
                                      reportType: lessonsTypeItem,
                                      showDivider:
                                          _model.reviewReports.lastOrNull ==
                                                  lessonsTypeItem
                                              ? false
                                              : true,
                                      reviewRef: widget.reviewRef,
                                      coursesRef: widget.coursesRef,
                                      lessonRef: widget.lessonRef,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
