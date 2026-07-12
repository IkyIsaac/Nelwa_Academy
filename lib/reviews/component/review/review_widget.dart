import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/reviews/component/review_optional/review_optional_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'review_model.dart';
export 'review_model.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    super.key,
    required this.reviewDoc,
    required this.coursesRef,
  });

  final CoursesReviewRecord? reviewDoc;
  final DocumentReference? coursesRef;

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  late ReviewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 54.0,
                          height: 54.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.network(
                                widget.reviewDoc!.userImage,
                              ).image,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    widget.reviewDoc?.userName,
                                    'null',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                        lineHeight: 1.0,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 0.0),
                                  child: Text(
                                    dateTimeFormat(
                                      "yMMMd",
                                      widget.reviewDoc!.createdAt!,
                                      locale: FFLocalizations.of(context)
                                          .languageCode,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                          lineHeight: 1.0,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Builder(
                  builder: (context) => Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 10.0, 0.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 22.0,
                      buttonSize: 44.0,
                      fillColor: FlutterFlowTheme.of(context).transparent,
                      icon: Icon(
                        FFIcons.kdotsVertical,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        await showAlignedDialog(
                          barrierColor:
                              FlutterFlowTheme.of(context).transparent,
                          context: context,
                          isGlobal: false,
                          avoidOverflow: true,
                          targetAnchor: AlignmentDirectional(1.0, 1.0)
                              .resolve(Directionality.of(context)),
                          followerAnchor: AlignmentDirectional(1.0, -1.0)
                              .resolve(Directionality.of(context)),
                          builder: (dialogContext) {
                            return Material(
                              color: Colors.transparent,
                              child: ReviewOptionalWidget(
                                reviewDoc: widget.reviewDoc!,
                                coursesRef: widget.coursesRef!,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
              child: RatingBarIndicator(
                itemBuilder: (context, index) => Icon(
                  FFIcons.kstarFilled,
                  color: FlutterFlowTheme.of(context).warning,
                ),
                direction: Axis.horizontal,
                rating: widget.reviewDoc!.rating,
                unratedColor: FlutterFlowTheme.of(context).unratedColor,
                itemCount: 5,
                itemPadding: EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
                itemSize: 20.0,
              ),
            ),
            if (widget.reviewDoc?.comment != null &&
                widget.reviewDoc?.comment != '')
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Builder(
                  builder: (context) {
                    if (functions
                            .more120Characters(widget.reviewDoc!.comment) ==
                        true) {
                      return RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: valueOrDefault<String>(
                                _model.moreComment
                                    ? widget.reviewDoc?.comment
                                    : '${functions.first120Symbols(widget.reviewDoc!.comment)}...',
                                'null',
                              ),
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: FFLocalizations.of(context).getText(
                                'wx1jv0tr' /*   */,
                              ),
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: _model.moreComment ? 'Hide' : 'Read more',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              mouseCursor: SystemMouseCursors.click,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  if (_model.moreComment) {
                                    _model.moreComment = false;
                                    safeSetState(() {});
                                  } else {
                                    _model.moreComment = true;
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
                      );
                    } else {
                      return Text(
                        valueOrDefault<String>(
                          widget.reviewDoc?.comment,
                          'null',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                            ),
                      );
                    }
                  },
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (widget.reviewDoc!.disliked
                          .contains(currentUserReference)) {
                        await widget.reviewDoc!.reference.update({
                          ...mapToFirestore(
                            {
                              'disliked': FieldValue.arrayRemove(
                                  [currentUserReference]),
                              'liked':
                                  FieldValue.arrayUnion([currentUserReference]),
                            },
                          ),
                        });
                      } else {
                        if (widget.reviewDoc!.liked
                            .contains(currentUserReference)) {
                          await widget.reviewDoc!.reference.update({
                            ...mapToFirestore(
                              {
                                'liked': FieldValue.arrayRemove(
                                    [currentUserReference]),
                              },
                            ),
                          });
                        } else {
                          await widget.reviewDoc!.reference.update({
                            ...mapToFirestore(
                              {
                                'liked': FieldValue.arrayUnion(
                                    [currentUserReference]),
                              },
                            ),
                          });
                        }
                      }
                    },
                    child: Builder(
                      builder: (context) {
                        if (widget.reviewDoc?.liked
                                .contains(currentUserReference) ??
                            false) {
                          return Icon(
                            FFIcons.kthumbUpFilled,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24.0,
                          );
                        } else {
                          return Icon(
                            FFIcons.kthumbUp,
                            color: FlutterFlowTheme.of(context).iconColor,
                            size: 24.0,
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    child: Text(
                      formatNumber(
                        widget.reviewDoc!.liked.length,
                        formatType: FormatType.compact,
                      ),
                      style: FlutterFlowTheme.of(context).labelLarge.override(
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
                          ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (widget.reviewDoc!.liked
                          .contains(currentUserReference)) {
                        await widget.reviewDoc!.reference.update({
                          ...mapToFirestore(
                            {
                              'disliked':
                                  FieldValue.arrayUnion([currentUserReference]),
                              'liked': FieldValue.arrayRemove(
                                  [currentUserReference]),
                            },
                          ),
                        });
                      } else {
                        if (widget.reviewDoc!.disliked
                            .contains(currentUserReference)) {
                          await widget.reviewDoc!.reference.update({
                            ...mapToFirestore(
                              {
                                'disliked': FieldValue.arrayRemove(
                                    [currentUserReference]),
                              },
                            ),
                          });
                        } else {
                          await widget.reviewDoc!.reference.update({
                            ...mapToFirestore(
                              {
                                'disliked': FieldValue.arrayUnion(
                                    [currentUserReference]),
                              },
                            ),
                          });
                        }
                      }
                    },
                    child: Builder(
                      builder: (context) {
                        if (widget.reviewDoc?.disliked
                                .contains(currentUserReference) ??
                            false) {
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Icon(
                              FFIcons.kthumbDownFilled,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24.0,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Icon(
                              FFIcons.kthumbDown,
                              color: FlutterFlowTheme.of(context).iconColor,
                              size: 24.0,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    child: Text(
                      formatNumber(
                        widget.reviewDoc!.disliked.length,
                        formatType: FormatType.compact,
                      ),
                      style: FlutterFlowTheme.of(context).labelLarge.override(
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
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
