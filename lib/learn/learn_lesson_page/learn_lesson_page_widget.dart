import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/courses/components/lesson_optional/lesson_optional_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'learn_lesson_page_model.dart';
export 'learn_lesson_page_model.dart';

class LearnLessonPageWidget extends StatefulWidget {
  const LearnLessonPageWidget({
    super.key,
    required this.lessonDoc,
    required this.coursesDoc,
  });

  final LessonsRecord? lessonDoc;
  final CoursesRecord? coursesDoc;

  static String routeName = 'LearnLessonPage';
  static String routePath = '/learnLessonPage';

  @override
  State<LearnLessonPageWidget> createState() => _LearnLessonPageWidgetState();
}

class _LearnLessonPageWidgetState extends State<LearnLessonPageWidget> {
  late LearnLessonPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LearnLessonPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.coursesDoc?.instructorRef != currentUserReference) {
        _model.purchasedCourses = await queryPurchasedCoursesRecordOnce(
          parent: currentUserReference,
          queryBuilder: (purchasedCoursesRecord) =>
              purchasedCoursesRecord.where(
            'courses_ref',
            isEqualTo: widget.coursesDoc?.reference,
          ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);
        if (!_model.purchasedCourses!.watchedLessons
            .contains(widget.lessonDoc?.reference)) {
          await _model.purchasedCourses!.reference.update({
            ...mapToFirestore(
              {
                'watched_lessons':
                    FieldValue.arrayUnion([widget.lessonDoc?.reference]),
              },
            ),
          });
        }
        if ((currentUserDocument?.continueWatching.toList() ?? [])
            .where((e) => e.courses == widget.coursesDoc?.reference)
            .toList()
            .isNotEmpty) {
          if (!(currentUserDocument?.continueWatching.toList() ?? [])
              .where((e) => e.courses == widget.coursesDoc?.reference)
              .toList()
              .firstOrNull!
              .completedLessons
              .contains(widget.lessonDoc?.reference)) {
            _model.continueWatching =
                (currentUserDocument?.continueWatching.toList() ?? [])
                    .where((e) => e.courses == widget.coursesDoc?.reference)
                    .toList()
                    .firstOrNull;
            safeSetState(() {});

            await currentUserReference!.update({
              ...mapToFirestore(
                {
                  'continue_watching': FieldValue.arrayRemove([
                    getContinueWatchingFirestoreData(
                      updateContinueWatchingStruct(
                        _model.continueWatching,
                        clearUnsetFields: false,
                      ),
                      true,
                    )
                  ]),
                },
              ),
            });
            _model.updateContinueWatchingStruct(
              (e) => e
                ..updateCompletedLessons(
                  (e) => e.add(widget.lessonDoc!.reference),
                ),
            );
            safeSetState(() {});

            await currentUserReference!.update({
              ...mapToFirestore(
                {
                  'continue_watching': FieldValue.arrayUnion([
                    getContinueWatchingFirestoreData(
                      updateContinueWatchingStruct(
                        _model.continueWatching,
                        clearUnsetFields: false,
                      ),
                      true,
                    )
                  ]),
                },
              ),
            });
          }
        } else {
          _model.updateContinueWatchingStruct(
            (e) => e
              ..courses = widget.coursesDoc?.reference
              ..updateCompletedLessons(
                (e) => e.add(widget.lessonDoc!.reference),
              ),
          );
          safeSetState(() {});

          await currentUserReference!.update({
            ...mapToFirestore(
              {
                'continue_watching': FieldValue.arrayUnion([
                  getContinueWatchingFirestoreData(
                    updateContinueWatchingStruct(
                      _model.continueWatching,
                      clearUnsetFields: false,
                    ),
                    true,
                  )
                ]),
              },
            ),
          });
        }
      }
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
          actions: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Builder(
                builder: (context) => Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
                  child: FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).transparent,
                    borderRadius: 22.0,
                    borderWidth: 1.0,
                    buttonSize: 44.0,
                    icon: Icon(
                      FFIcons.kdotsVertical,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      await showAlignedDialog(
                        barrierColor: FlutterFlowTheme.of(context).transparent,
                        context: context,
                        isGlobal: false,
                        avoidOverflow: false,
                        targetAnchor: AlignmentDirectional(1.0, 1.0)
                            .resolve(Directionality.of(context)),
                        followerAnchor: AlignmentDirectional(1.0, -1.0)
                            .resolve(Directionality.of(context)),
                        builder: (dialogContext) {
                          return Material(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(dialogContext).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: LessonOptionalWidget(
                                lessonRef: widget.lessonDoc!.reference,
                                courseRef: widget.coursesDoc!.reference,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
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
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Builder(
                        builder: (context) {
                          if (_model.showVideo) {
                            return FlutterFlowVideoPlayer(
                              path: widget.lessonDoc!.videoUrl,
                              videoType: VideoType.network,
                              height: 200.0,
                              autoPlay: true,
                              looping: true,
                              showControls: true,
                              allowFullScreen: true,
                              allowPlaybackSpeedMenu: false,
                            );
                          } else {
                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.showVideo = true;
                                safeSetState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                height: 200.0,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.network(
                                            widget.lessonDoc!.image,
                                          ).image,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: ClipOval(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 12.0,
                                              sigmaY: 12.0,
                                            ),
                                            child: Container(
                                              width: 48.0,
                                              height: 48.0,
                                              decoration: BoxDecoration(
                                                color: Color(0x66FFFFFF),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          4.0, 0.0, 0.0, 0.0),
                                                  child: Icon(
                                                    FFIcons.kplayw1,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .info,
                                                    size: 18.0,
                                                  ),
                                                ),
                                              ),
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
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget.lessonDoc?.title,
                          'null',
                        ),
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                  lineHeight: 1.5,
                                ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: FFLocalizations.of(context).getText(
                                '2hk9cr3q' /* Video duration:  */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontStyle,
                                    lineHeight: 1.0,
                                  ),
                            ),
                            TextSpan(
                              text: functions
                                  .lessonDuration(widget.lessonDoc!.duration),
                              style: TextStyle(),
                            )
                          ],
                          style:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontStyle,
                                    lineHeight: 1.0,
                                  ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: valueOrDefault<String>(
                                _model.moreDescription
                                    ? widget.lessonDoc?.description
                                    : '${functions.first120Symbols(widget.lessonDoc!.description)}...',
                                'null',
                              ),
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: FFLocalizations.of(context).getText(
                                'yhpsu6i8' /*   */,
                              ),
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text:
                                  _model.moreDescription ? 'Hide' : 'Read more',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              mouseCursor: SystemMouseCursors.click,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  if (_model.moreDescription) {
                                    _model.moreDescription = false;
                                    safeSetState(() {});
                                  } else {
                                    _model.moreDescription = true;
                                    safeSetState(() {});
                                  }
                                },
                            )
                          ],
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.5,
                                  ),
                        ),
                      ),
                    ),
                  ]
                      .addToStart(SizedBox(height: 16.0))
                      .addToEnd(SizedBox(height: 24.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
