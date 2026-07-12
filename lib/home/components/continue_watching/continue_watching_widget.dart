import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'continue_watching_model.dart';
export 'continue_watching_model.dart';

class ContinueWatchingWidget extends StatefulWidget {
  const ContinueWatchingWidget({
    super.key,
    required this.continueWatching,
  });

  final ContinueWatchingStruct? continueWatching;

  @override
  State<ContinueWatchingWidget> createState() => _ContinueWatchingWidgetState();
}

class _ContinueWatchingWidgetState extends State<ContinueWatchingWidget> {
  late ContinueWatchingModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContinueWatchingModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CoursesRecord>(
      stream: CoursesRecord.getDocument(widget.continueWatching!.courses!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 10.0,
              height: 10.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).transparent,
                ),
              ),
            ),
          );
        }

        final containerCoursesRecord = snapshot.data!;

        return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            if (containerCoursesRecord.downloaders
                .contains(currentUserReference)) {
              context.pushNamed(
                LearnCoursesPageWidget.routeName,
                queryParameters: {
                  'coursesDoc': serializeParam(
                    containerCoursesRecord,
                    ParamType.Document,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  'coursesDoc': containerCoursesRecord,
                },
              );
            } else {
              context.pushNamed(
                CoursesPageCopyCopyWidget.routeName,
                queryParameters: {
                  'coursesDoc': serializeParam(
                    containerCoursesRecord,
                    ParamType.Document,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  'coursesDoc': containerCoursesRecord,
                },
              );
            }
          },
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.8,
            height: 118.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 86.0,
                    height: 86.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondary,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.network(
                          containerCoursesRecord.image,
                        ).image,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          containerCoursesRecord.title.maybeHandleOverflow(
                            maxChars: 30,
                            replacement: '…',
                          ),
                          maxLines: 2,
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                    lineHeight: 1.5,
                                  ),
                        ),
                        Text(
                          '${valueOrDefault<String>(
                            widget.continueWatching?.completedLessons.length
                                .toString(),
                            '0',
                          )}/${containerCoursesRecord.totalLessons.toString()}',
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
                                    lineHeight: 1.0,
                                  ),
                        ),
                      ].divide(SizedBox(height: 12.0)),
                    ),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}
