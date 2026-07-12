import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'wish_list_card_model.dart';
export 'wish_list_card_model.dart';

class WishListCardWidget extends StatefulWidget {
  const WishListCardWidget({
    super.key,
    required this.coursesDoc,
  });

  final CoursesRecord? coursesDoc;

  @override
  State<WishListCardWidget> createState() => _WishListCardWidgetState();
}

class _WishListCardWidgetState extends State<WishListCardWidget> {
  late WishListCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WishListCardModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          if (widget.coursesDoc!.downloaders.contains(currentUserReference)) {
            context.pushNamed(
              LearnCoursesPageWidget.routeName,
              queryParameters: {
                'coursesDoc': serializeParam(
                  widget.coursesDoc,
                  ParamType.Document,
                ),
              }.withoutNulls,
              extra: <String, dynamic>{
                'coursesDoc': widget.coursesDoc,
              },
            );
          } else {
            context.pushNamed(
              CoursesPageCopyWidget.routeName,
              queryParameters: {
                'coursesDoc': serializeParam(
                  widget.coursesDoc,
                  ParamType.Document,
                ),
              }.withoutNulls,
              extra: <String, dynamic>{
                'coursesDoc': widget.coursesDoc,
              },
            );
          }
        },
        child: Container(
          width: double.infinity,
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
                        widget.coursesDoc!.image,
                      ).image,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget.coursesDoc?.title,
                            'null',
                          ).maybeHandleOverflow(
                            maxChars: 45,
                            replacement: '…',
                          ),
                          maxLines: 2,
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                                    lineHeight: 1.5,
                                  ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            widget.coursesDoc?.instructorName,
                            'null',
                          ),
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
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (FFAppState()
                          .wishList
                          .contains(widget.coursesDoc?.reference)) {
                        FFAppState()
                            .removeFromWishList(widget.coursesDoc!.reference);
                        FFAppState().update(() {});
                      } else {
                        FFAppState()
                            .addToWishList(widget.coursesDoc!.reference);
                        FFAppState().update(() {});
                      }
                    },
                    child: Builder(
                      builder: (context) {
                        if (FFAppState()
                            .wishList
                            .contains(widget.coursesDoc?.reference)) {
                          return Icon(
                            FFIcons.kheartFilled,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24.0,
                          );
                        } else {
                          return Icon(
                            FFIcons.kheart,
                            color: FlutterFlowTheme.of(context).iconColor,
                            size: 24.0,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
