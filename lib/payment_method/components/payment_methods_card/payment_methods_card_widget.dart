import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment_methods_card_model.dart';
export 'payment_methods_card_model.dart';

class PaymentMethodsCardWidget extends StatefulWidget {
  const PaymentMethodsCardWidget({
    super.key,
    required this.paymentMethods,
  });

  final PaymentMethodRecord? paymentMethods;

  @override
  State<PaymentMethodsCardWidget> createState() =>
      _PaymentMethodsCardWidgetState();
}

class _PaymentMethodsCardWidgetState extends State<PaymentMethodsCardWidget> {
  late PaymentMethodsCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentMethodsCardModel());

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
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            CreditCardPageWidget.routeName,
            queryParameters: {
              'paymentDoc': serializeParam(
                widget.paymentMethods,
                ParamType.Document,
              ),
            }.withoutNulls,
            extra: <String, dynamic>{
              'paymentDoc': widget.paymentMethods,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    if (widget.paymentMethods?.type ==
                        PaymentMethods.Visa.name) {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent1,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(),
                          child: SvgPicture.asset(
                            'assets/images/visa.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget.paymentMethods?.type ==
                        PaymentMethods.Mastercard.name) {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFFDEACE),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(),
                          child: SvgPicture.asset(
                            'assets/images/mastercard.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget.paymentMethods?.type ==
                        PaymentMethods.PayPal.name) {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFD8DDF3),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(),
                          child: SvgPicture.asset(
                            'assets/images/paypal.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget.paymentMethods?.type ==
                        PaymentMethods.GooglePay.name) {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFE4E5E7),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(),
                          child: SvgPicture.asset(
                            'assets/images/google_pay.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget.paymentMethods?.type ==
                        PaymentMethods.ApplePay.name) {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(),
                          child: SvgPicture.asset(
                            'assets/images/apple_pay.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (widget.paymentMethods?.type ==
                        PaymentMethods.Discover.name) {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFECDF),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(),
                          child: Image.asset(
                            'assets/images/discover.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(),
                              child: Image.asset(
                                'assets/images/mobile_10188498.png',
                                fit: BoxFit.contain,
                                alignment: Alignment(0.0, 0.0),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget.paymentMethods?.cardNickname != null &&
                                    widget.paymentMethods?.cardNickname != ''
                                ? widget.paymentMethods?.cardNickname
                                : (widget.paymentMethods?.hasType() == null
                                    ? widget.paymentMethods?.providerName
                                    : widget.paymentMethods?.type),
                            'null',
                          ),
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
                                    lineHeight: 1.0,
                                  ),
                        ),
                        if ((widget.paymentMethods?.type !=
                                PaymentMethods.PayPal.name) ||
                            (widget.paymentMethods?.type !=
                                PaymentMethods.GooglePay.name) ||
                            (widget.paymentMethods?.type !=
                                PaymentMethods.ApplePay.name))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              valueOrDefault<String>(
                                functions.hiddenText(
                                    widget.paymentMethods?.cardNumber, 2, 2),
                                'null',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
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
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      'jfk3xk8f' /* Connected */,
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
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
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
