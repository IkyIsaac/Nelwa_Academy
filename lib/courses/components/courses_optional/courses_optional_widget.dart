import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/courses/components/delete_courses/delete_courses_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/optionals_buttons/optionals_buttons_widget.dart';
import '/reviews/component/report/report_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'courses_optional_model.dart';
export 'courses_optional_model.dart';

class CoursesOptionalWidget extends StatefulWidget {
  const CoursesOptionalWidget({
    super.key,
    required this.coursesDoc,
  });

  final CoursesRecord? coursesDoc;

  @override
  State<CoursesOptionalWidget> createState() => _CoursesOptionalWidgetState();
}

class _CoursesOptionalWidgetState extends State<CoursesOptionalWidget> {
  late CoursesOptionalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CoursesOptionalModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
      child: Container(
        width: 200.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).optional,
          boxShadow: [
            BoxShadow(
              blurRadius: 13.0,
              color: FlutterFlowTheme.of(context).shadow,
              offset: Offset(
                0.0,
                4.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                if (FFAppState()
                    .wishList
                    .contains(widget.coursesDoc?.reference)) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      FFAppState()
                          .removeFromWishList(widget.coursesDoc!.reference);
                      FFAppState().update(() {});
                      Navigator.pop(context);
                    },
                    child: wrapWithModel(
                      model: _model.optionalsButtonsModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: OptionalsButtonsWidget(
                        icon: Icon(
                          FFIcons.kbookmarkw1,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 24.0,
                        ),
                        text: 'Remove ',
                        textColor: FlutterFlowTheme.of(context).primaryText,
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
                      FFAppState().addToWishList(widget.coursesDoc!.reference);
                      FFAppState().update(() {});
                      Navigator.pop(context);
                    },
                    child: wrapWithModel(
                      model: _model.optionalsButtonsModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: OptionalsButtonsWidget(
                        icon: Icon(
                          FFIcons.kbookmark,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        text: 'Save',
                        textColor: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  );
                }
              },
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: FlutterFlowTheme.of(context).dividerColor,
            ),
            Builder(
              builder: (context) => InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  Navigator.pop(context);
                  await Share.share(
                    widget.coursesDoc!.reference.id,
                    sharePositionOrigin: getWidgetBoundingBox(context),
                  );
                },
                child: wrapWithModel(
                  model: _model.optionalsButtonsModel3,
                  updateCallback: () => safeSetState(() {}),
                  child: OptionalsButtonsWidget(
                    icon: Icon(
                      FFIcons.kshare06,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    text: 'Share',
                    textColor: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: FlutterFlowTheme.of(context).dividerColor,
            ),
            if (widget.coursesDoc?.instructorRef != currentUserReference)
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
                        child: ReportWidget(
                          coursesRef: widget.coursesDoc?.reference,
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
                child: wrapWithModel(
                  model: _model.optionalsButtonsModel4,
                  updateCallback: () => safeSetState(() {}),
                  child: OptionalsButtonsWidget(
                    icon: Icon(
                      FFIcons.kalertCircle,
                      color: FlutterFlowTheme.of(context).error,
                      size: 24.0,
                    ),
                    text: 'Report',
                    textColor: FlutterFlowTheme.of(context).error,
                  ),
                ),
              ),
            if (widget.coursesDoc?.instructorRef == currentUserReference)
              Builder(
                builder: (context) => InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pop(context);
                    await showDialog(
                      barrierColor: FlutterFlowTheme.of(context).background,
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          elevation: 0,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          alignment: AlignmentDirectional(0.0, 0.0)
                              .resolve(Directionality.of(context)),
                          child: DeleteCoursesWidget(
                            coursesRef: widget.coursesDoc!.reference,
                          ),
                        );
                      },
                    );
                  },
                  child: wrapWithModel(
                    model: _model.optionalsButtonsModel5,
                    updateCallback: () => safeSetState(() {}),
                    child: OptionalsButtonsWidget(
                      icon: Icon(
                        FFIcons.ktrash01,
                        color: FlutterFlowTheme.of(context).error,
                        size: 24.0,
                      ),
                      text: 'Delete',
                      textColor: FlutterFlowTheme.of(context).error,
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
