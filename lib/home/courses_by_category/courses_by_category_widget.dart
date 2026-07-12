import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/filter/filter_widget.dart';
import '/home/components/horizontal_card/horizontal_card_widget.dart';
import '/home/components/square_card/square_card_widget.dart';
import '/loading/loading_horizontal_card/loading_horizontal_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'courses_by_category_model.dart';
export 'courses_by_category_model.dart';

class CoursesByCategoryWidget extends StatefulWidget {
  const CoursesByCategoryWidget({
    super.key,
    required this.category,
  });

  final String? category;

  static String routeName = 'CoursesByCategory';
  static String routePath = '/coursesByCategory';

  @override
  State<CoursesByCategoryWidget> createState() =>
      _CoursesByCategoryWidgetState();
}

class _CoursesByCategoryWidgetState extends State<CoursesByCategoryWidget> {
  late CoursesByCategoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CoursesByCategoryModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().updateFilterStruct(
        (e) => e
          ..rating = 0.0
          ..start = 0.0
          ..end = 500.0
          ..skillLevel = null
          ..dateAdded = null
          ..durationFrom = 0
          ..durationTo = 6000,
      );
      safeSetState(() {});
    });

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
            valueOrDefault<String>(
              widget.category,
              'null',
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
          actions: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
                child: FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).transparent,
                  borderRadius: 22.0,
                  borderWidth: 1.0,
                  buttonSize: 44.0,
                  icon: Icon(
                    FFIcons.kadjustmentsHorizontal,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: FilterWidget(),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                ),
              ),
            ),
          ],
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      FFLocalizations.of(context).getText(
                        '9btmnc75' /* View Mode */,
                      ),
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                            lineHeight: 1.5,
                          ),
                    ),
                  ),
                  Container(
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 36.0,
                            fillColor: !_model.show!
                                ? FlutterFlowTheme.of(context).secondary
                                : FlutterFlowTheme.of(context).transparent,
                            icon: Icon(
                              FFIcons.klistDetails,
                              color: !_model.show!
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).iconColor,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              _model.show = false;
                              safeSetState(() {});
                            },
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 36.0,
                            fillColor: _model.show!
                                ? FlutterFlowTheme.of(context).secondary
                                : FlutterFlowTheme.of(context).transparent,
                            icon: Icon(
                              FFIcons.kgrid01,
                              color: _model.show!
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).iconColor,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              _model.show = true;
                              safeSetState(() {});
                            },
                          ),
                        ].divide(SizedBox(width: 4.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<CoursesRecord>>(
                stream: queryCoursesRecord(
                  queryBuilder: (coursesRecord) => coursesRecord.where(
                    'language.lang_code',
                    isEqualTo: FFLocalizations.of(context).languageCode,
                  ),
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return LoadingHorizontalCardWidget();
                  }
                  List<CoursesRecord> conditionalBuilderCoursesRecordList =
                      snapshot.data!;

                  return Builder(
                    builder: (context) {
                      if (_model.show ?? false) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                child: Builder(
                                  builder: (context) {
                                    final conditionalBuilderVar =
                                        conditionalBuilderCoursesRecordList
                                            .where((e) => !((e.totalDuration >
                                                    FFAppState()
                                                        .filter
                                                        .durationFrom) &&
                                                (e.totalDuration <=
                                                    FFAppState()
                                                        .filter
                                                        .durationTo) &&
                                                (e.price >
                                                    FFAppState()
                                                        .filter
                                                        .start) &&
                                                (e.price <=
                                                    FFAppState().filter.end) &&
                                                (e.rating >=
                                                    FFAppState()
                                                        .filter
                                                        .rating)))
                                            .toList();

                                    return Wrap(
                                      spacing: 12.0,
                                      runSpacing: 16.0,
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      direction: Axis.horizontal,
                                      runAlignment: WrapAlignment.start,
                                      verticalDirection: VerticalDirection.down,
                                      clipBehavior: Clip.none,
                                      children: List.generate(
                                          conditionalBuilderVar.length,
                                          (conditionalBuilderVarIndex) {
                                        final conditionalBuilderVarItem =
                                            conditionalBuilderVar[
                                                conditionalBuilderVarIndex];
                                        return wrapWithModel(
                                          model:
                                              _model.squareCardModels.getModel(
                                            conditionalBuilderVarIndex
                                                .toString(),
                                            conditionalBuilderVarIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: SquareCardWidget(
                                            key: Key(
                                              'Keyhrq_${conditionalBuilderVarIndex.toString()}',
                                            ),
                                            coursesDoc:
                                                conditionalBuilderVarItem,
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                ),
                              ),
                            ]
                                .addToStart(SizedBox(height: 12.0))
                                .addToEnd(SizedBox(height: 24.0)),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final coursesVertical =
                                  conditionalBuilderCoursesRecordList
                                      .where((e) =>
                                          (e.totalDuration >
                                              FFAppState()
                                                  .filter
                                                  .durationFrom) ||
                                          (e.totalDuration <=
                                              FFAppState().filter.durationTo) ||
                                          (e.price >
                                              FFAppState().filter.start) ||
                                          (e.price <=
                                              FFAppState().filter.end) ||
                                          (e.rating >=
                                              FFAppState().filter.rating))
                                      .toList();

                              return ListView.separated(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  12.0,
                                  0,
                                  24.0,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: coursesVertical.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 12.0),
                                itemBuilder: (context, coursesVerticalIndex) {
                                  final coursesVerticalItem =
                                      coursesVertical[coursesVerticalIndex];
                                  return wrapWithModel(
                                    model: _model.horizontalCardModels.getModel(
                                      coursesVerticalIndex.toString(),
                                      coursesVerticalIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: HorizontalCardWidget(
                                      key: Key(
                                        'Key1bc_${coursesVerticalIndex.toString()}',
                                      ),
                                      coursesDoc: coursesVerticalItem,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
