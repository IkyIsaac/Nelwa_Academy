import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/optionals_buttons/optionals_buttons_widget.dart';
import '/reviews/component/report/report_widget.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'review_optional_model.dart';
export 'review_optional_model.dart';

class ReviewOptionalWidget extends StatefulWidget {
  const ReviewOptionalWidget({
    super.key,
    required this.reviewDoc,
    required this.coursesRef,
  });

  final CoursesReviewRecord? reviewDoc;
  final DocumentReference? coursesRef;

  @override
  State<ReviewOptionalWidget> createState() => _ReviewOptionalWidgetState();
}

class _ReviewOptionalWidgetState extends State<ReviewOptionalWidget> {
  late ReviewOptionalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewOptionalModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).optional,
        boxShadow: [
          BoxShadow(
            blurRadius: 13.0,
            color: Color(0x25000000),
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
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              if (widget.reviewDoc!.disliked.contains(currentUserReference)) {
                await widget.reviewDoc!.reference.update({
                  ...mapToFirestore(
                    {
                      'liked': FieldValue.arrayUnion([currentUserReference]),
                      'disliked':
                          FieldValue.arrayRemove([currentUserReference]),
                    },
                  ),
                });
              } else {
                if (widget.reviewDoc!.liked.contains(currentUserReference)) {
                  await widget.reviewDoc!.reference.update({
                    ...mapToFirestore(
                      {
                        'liked': FieldValue.arrayRemove([currentUserReference]),
                      },
                    ),
                  });
                } else {
                  await widget.reviewDoc!.reference.update({
                    ...mapToFirestore(
                      {
                        'liked': FieldValue.arrayUnion([currentUserReference]),
                      },
                    ),
                  });
                }
              }

              Navigator.pop(context);
            },
            child: Builder(
              builder: (context) {
                if (widget.reviewDoc?.liked.contains(currentUserReference) ??
                    false) {
                  return wrapWithModel(
                    model: _model.optionalsButtonsModel1,
                    updateCallback: () => safeSetState(() {}),
                    child: OptionalsButtonsWidget(
                      icon: Icon(
                        FFIcons.kthumbUpFilled,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24.0,
                      ),
                      text: 'Like',
                      textColor: FlutterFlowTheme.of(context).primaryText,
                    ),
                  );
                } else {
                  return wrapWithModel(
                    model: _model.optionalsButtonsModel2,
                    updateCallback: () => safeSetState(() {}),
                    child: OptionalsButtonsWidget(
                      icon: Icon(
                        FFIcons.kthumbUp,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      text: 'Like',
                      textColor: FlutterFlowTheme.of(context).primaryText,
                    ),
                  );
                }
              },
            ),
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
                  widget.reviewDoc!.reference.id,
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
                      reviewRef: widget.reviewDoc?.reference,
                      coursesRef: widget.coursesRef,
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
        ],
      ),
    );
  }
}
