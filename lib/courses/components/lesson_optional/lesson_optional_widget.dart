import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/optionals_buttons/optionals_buttons_widget.dart';
import '/reviews/component/report/report_widget.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'lesson_optional_model.dart';
export 'lesson_optional_model.dart';

class LessonOptionalWidget extends StatefulWidget {
  const LessonOptionalWidget({
    super.key,
    required this.lessonRef,
    required this.courseRef,
  });

  final DocumentReference? lessonRef;
  final DocumentReference? courseRef;

  @override
  State<LessonOptionalWidget> createState() => _LessonOptionalWidgetState();
}

class _LessonOptionalWidgetState extends State<LessonOptionalWidget> {
  late LessonOptionalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LessonOptionalModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              builder: (context) => InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  Navigator.pop(context);
                  await Share.share(
                    widget.lessonRef!.id,
                    sharePositionOrigin: getWidgetBoundingBox(context),
                  );
                },
                child: wrapWithModel(
                  model: _model.optionalsButtonsModel1,
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
                        lessonRef: widget.lessonRef,
                        coursesRef: widget.courseRef,
                      ),
                    );
                  },
                ).then((value) => safeSetState(() {}));
              },
              child: wrapWithModel(
                model: _model.optionalsButtonsModel2,
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
          ],
        ),
      ),
    );
  }
}
