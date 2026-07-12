import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/reviews/component/report_comment/report_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reports_type_model.dart';
export 'reports_type_model.dart';

class ReportsTypeWidget extends StatefulWidget {
  const ReportsTypeWidget({
    super.key,
    required this.reportType,
    bool? showDivider,
    this.reviewRef,
    this.coursesRef,
    this.lessonRef,
  }) : this.showDivider = showDivider ?? false;

  final String? reportType;
  final bool showDivider;
  final DocumentReference? reviewRef;
  final DocumentReference? coursesRef;
  final DocumentReference? lessonRef;

  @override
  State<ReportsTypeWidget> createState() => _ReportsTypeWidgetState();
}

class _ReportsTypeWidgetState extends State<ReportsTypeWidget> {
  late ReportsTypeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportsTypeModel());

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
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Navigator.pop(context);
            await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.viewInsetsOf(context),
                  child: ReportCommentWidget(
                    reportType: widget.reportType!,
                    reviewRef: widget.reviewRef,
                    lessonRef: widget.lessonRef,
                    coursesRef: widget.coursesRef,
                  ),
                );
              },
            ).then((value) => safeSetState(() {}));
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                  child: Text(
                    valueOrDefault<String>(
                      widget.reportType,
                      'null',
                    ),
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                child: Icon(
                  FFIcons.kchevronRight,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 22.0,
                ),
              ),
            ],
          ),
        ),
        if (widget.showDivider)
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).dividerColor,
          ),
      ],
    );
  }
}
