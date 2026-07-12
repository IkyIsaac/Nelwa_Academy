import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'order_courses_model.dart';
export 'order_courses_model.dart';

class OrderCoursesWidget extends StatefulWidget {
  const OrderCoursesWidget({
    super.key,
    required this.coursesDoc,
    bool? isYearly,
  }) : this.isYearly = isYearly ?? false;

  final CoursesRecord? coursesDoc;
  final bool isYearly;

  @override
  State<OrderCoursesWidget> createState() => _OrderCoursesWidgetState();
}

class _OrderCoursesWidgetState extends State<OrderCoursesWidget> {
  late OrderCoursesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderCoursesModel());

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
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.network(
                    widget.coursesDoc!.image,
                  ).image,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valueOrDefault<String>(
                      widget.coursesDoc?.title,
                      'null',
                    ).maybeHandleOverflow(
                      maxChars: 30,
                      replacement: '…',
                    ),
                    maxLines: 2,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
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
                    '${widget.isYearly ? formatNumber(
                        widget.coursesDoc?.yearPrice,
                        formatType: FormatType.decimal,
                        decimalType: DecimalType.periodDecimal,
                        currency: 'Tsh ',
                      ) : formatNumber(
                        widget.coursesDoc?.price,
                        formatType: FormatType.decimal,
                        decimalType: DecimalType.periodDecimal,
                        currency: 'Tsh ',
                      )}',
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
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                          lineHeight: 1.0,
                        ),
                  ),
                ].divide(SizedBox(height: 12.0)),
              ),
            ),
            FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 44.0,
              fillColor: FlutterFlowTheme.of(context).secondary,
              icon: Icon(
                FFIcons.ktrash03,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                if (FFAppState().order.coursesRef.length == 1) {
                  FFAppState().updateOrderStruct(
                    (e) => e
                      ..updateCoursesRef(
                        (e) => e.remove(widget.coursesDoc?.reference),
                      )
                      ..incrementQuantity(-1)
                      ..incrementTotalPrice(widget.coursesDoc!.price),
                  );
                  FFAppState().update(() {});
                  context.safePop();
                } else {
                  FFAppState().updateOrderStruct(
                    (e) => e
                      ..updateCoursesRef(
                        (e) => e.remove(widget.coursesDoc?.reference),
                      )
                      ..incrementQuantity(-1)
                      ..incrementTotalPrice(widget.coursesDoc!.price),
                  );
                  FFAppState().update(() {});
                }
              },
            ),
          ].divide(SizedBox(width: 16.0)),
        ),
      ),
    );
  }
}
