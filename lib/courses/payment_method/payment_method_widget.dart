import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/courses/components/error_text/error_text_widget.dart';
import '/courses/components/order_successfully/order_successfully_widget.dart';
import '/empty_state/empty_payment/empty_payment_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/loading/loading_payment/loading_payment_widget.dart';
import '/payment_method/components/add_payment_method/add_payment_method_widget.dart';
import 'dart:async';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'payment_method_model.dart';
export 'payment_method_model.dart';

class PaymentMethodWidget extends StatefulWidget {
  const PaymentMethodWidget({super.key});

  static String routeName = 'PaymentMethod';
  static String routePath = '/paymentMethod';

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  late PaymentMethodModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentMethodModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.paymentMethods = currentUserDocument?.defaultPayment;
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
        resizeToAvoidBottomInset: false,
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
            FFLocalizations.of(context).getText(
              'iw9mkyb2' /* Payment Method */,
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
                    FFIcons.kplus,
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
                            child: AddPaymentMethodWidget(),
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
          children: [
            Expanded(
              child: StreamBuilder<List<PaymentMethodRecord>>(
                stream: queryPaymentMethodRecord(
                  parent: currentUserReference,
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return LoadingPaymentWidget();
                  }
                  List<PaymentMethodRecord> listViewPaymentMethodRecordList =
                      snapshot.data!;
                  if (listViewPaymentMethodRecordList.isEmpty) {
                    return EmptyPaymentWidget();
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      16.0,
                      0,
                      24.0,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewPaymentMethodRecordList.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.0),
                    itemBuilder: (context, listViewIndex) {
                      final listViewPaymentMethodRecord =
                          listViewPaymentMethodRecordList[listViewIndex];
                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _model.paymentMethods =
                                listViewPaymentMethodRecord.reference;
                            safeSetState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
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
                                      if (listViewPaymentMethodRecord.type ==
                                          PaymentMethods.Visa.name) {
                                        return Container(
                                          width: 60.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .accent1,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(),
                                            child: SvgPicture.asset(
                                              'assets/images/visa.svg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else if (listViewPaymentMethodRecord
                                              .type ==
                                          PaymentMethods.Mastercard.name) {
                                        return Container(
                                          width: 60.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFDEACE),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(),
                                            child: SvgPicture.asset(
                                              'assets/images/mastercard.svg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else if (listViewPaymentMethodRecord
                                              .type ==
                                          PaymentMethods.PayPal.name) {
                                        return Container(
                                          width: 60.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD8DDF3),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(),
                                            child: SvgPicture.asset(
                                              'assets/images/paypal.svg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else if (listViewPaymentMethodRecord
                                              .type ==
                                          PaymentMethods.GooglePay.name) {
                                        return Container(
                                          width: 60.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE4E5E7),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(),
                                            child: SvgPicture.asset(
                                              'assets/images/google_pay.svg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else if (listViewPaymentMethodRecord
                                              .type ==
                                          PaymentMethods.ApplePay.name) {
                                        return Container(
                                          width: 60.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE6E6E6),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(),
                                            child: SvgPicture.asset(
                                              'assets/images/apple_pay.svg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else if (listViewPaymentMethodRecord
                                              .type ==
                                          PaymentMethods.Discover.name) {
                                        return Container(
                                          width: 60.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFECDF),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
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
                                            color: Color(0xFFD3DEF7),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(),
                                            child: SvgPicture.asset(
                                              'assets/images/american_express.svg',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              listViewPaymentMethodRecord
                                                              .cardNickname !=
                                                          ''
                                                  ? listViewPaymentMethodRecord
                                                      .cardNickname
                                                  : listViewPaymentMethodRecord
                                                      .type,
                                              'null',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                  lineHeight: 1.0,
                                                ),
                                          ),
                                          if ((listViewPaymentMethodRecord
                                                      .type !=
                                                  PaymentMethods.PayPal.name) ||
                                              (listViewPaymentMethodRecord
                                                      .type !=
                                                  PaymentMethods
                                                      .GooglePay.name) ||
                                              (listViewPaymentMethodRecord
                                                      .type !=
                                                  PaymentMethods.ApplePay.name))
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  functions.hiddenText(
                                                      listViewPaymentMethodRecord
                                                          .cardNumber,
                                                      2,
                                                      2),
                                                  'null',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                  Container(
                                    width: 24.0,
                                    height: 24.0,
                                    decoration: BoxDecoration(
                                      color: _model.paymentMethods ==
                                              listViewPaymentMethodRecord
                                                  .reference
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _model.paymentMethods ==
                                                listViewPaymentMethodRecord
                                                    .reference
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : FlutterFlowTheme.of(context)
                                                .iconColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Visibility(
                                      visible: _model.paymentMethods ==
                                          listViewPaymentMethodRecord.reference,
                                      child: Icon(
                                        FFIcons.kcheck,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Builder(
                builder: (context) {
                  if (_model.paymentMethods != null) {
                    return Builder(
                      builder: (context) => Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            _model.courses = FFAppState().order.quantity;
                            safeSetState(() {});
                            while (_model.courses! > 0) {
                              _model.coursesDoc = await queryCoursesRecordOnce(
                                queryBuilder: (coursesRecord) =>
                                    coursesRecord.where(
                                  'courses_id',
                                  isEqualTo:
                                      FFAppState().order.coursesRef.firstOrNull,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              _model.paymentAccount =
                                  await queryPaymentAccountRecordOnce(
                                parent: _model.coursesDoc?.instructorRef,
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              _model.instructorDoc =
                                  await queryInstructorDetailsRecordOnce(
                                parent: _model.coursesDoc?.instructorRef,
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              unawaited(
                                () async {
                                  await PurchasedCoursesRecord.createDoc(
                                          currentUserReference!)
                                      .set(createPurchasedCoursesRecordData(
                                    coursesRef: _model.coursesDoc?.reference,
                                    purchaseDate: getCurrentTimestamp,
                                    reviwed: false,
                                    instructorName:
                                        _model.coursesDoc?.instructorName,
                                    lessons: _model.coursesDoc?.totalLessons,
                                  ));
                                }(),
                              );
                              unawaited(
                                () async {
                                  await PurchaseHistoryRecord.createDoc(
                                          currentUserReference!)
                                      .set(createPurchaseHistoryRecordData(
                                    userRef: currentUserReference,
                                    amount: _model.coursesDoc?.price,
                                    currency: 'USD',
                                    status: Status.Paid,
                                    transactionType: 'Bank Transfer',
                                    date: getCurrentTimestamp,
                                    coursesName: _model.coursesDoc?.title,
                                    paymentMethod: _model.paymentMethods,
                                    coursesRef: _model.coursesDoc?.reference,
                                  ));
                                }(),
                              );
                              unawaited(
                                () async {
                                  await _model.paymentAccount!.reference
                                      .update({
                                    ...createPaymentAccountRecordData(
                                      accountType: '',
                                    ),
                                    ...mapToFirestore(
                                      {
                                        'sales_reports': FieldValue.arrayUnion([
                                          getSalesReportsFirestoreData(
                                            createSalesReportsStruct(
                                              userRef: currentUserReference,
                                              amount: _model.coursesDoc?.price,
                                              currency: 'USD',
                                              status: Status.Paid,
                                              transactionType: _model
                                                  .paymentAccount?.accountType,
                                              date: getCurrentTimestamp,
                                              paymentMethod:
                                                  _model.paymentMethods,
                                              courseRef:
                                                  _model.coursesDoc?.reference,
                                              courseName:
                                                  _model.coursesDoc?.title,
                                              clearUnsetFields: false,
                                            ),
                                            true,
                                          )
                                        ]),
                                        'balance': FieldValue.increment(
                                            _model.coursesDoc!.price),
                                      },
                                    ),
                                  });
                                }(),
                              );
                              unawaited(
                                () async {
                                  await _model.coursesDoc!.reference.update({
                                    ...mapToFirestore(
                                      {
                                        'downloaders': FieldValue.arrayUnion(
                                            [currentUserReference]),
                                      },
                                    ),
                                  });
                                }(),
                              );
                              unawaited(
                                () async {
                                  await _model.instructorDoc!.reference.update({
                                    ...mapToFirestore(
                                      {
                                        'students': FieldValue.arrayUnion(
                                            [currentUserReference]),
                                      },
                                    ),
                                  });
                                }(),
                              );
                              FFAppState().updateOrderStruct(
                                (e) => e
                                  ..updateCoursesRef(
                                    (e) =>
                                        e.remove(_model.coursesDoc?.reference),
                                  )
                                  ..incrementQuantity(-1),
                              );
                              safeSetState(() {});
                              _model.courses = _model.courses! + -1;
                              safeSetState(() {});
                            }
                            FFAppState().order = OrderStruct();
                            safeSetState(() {});
                            if (valueOrDefault(currentUserDocument?.role, '') ==
                                'instructor') {
                              await currentUserReference!
                                  .update(createUsersRecordData(
                                role: 'Learner',
                              ));
                            }
                            await showDialog(
                              barrierColor:
                                  FlutterFlowTheme.of(context).background,
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(dialogContext).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: OrderSuccessfullyWidget(),
                                  ),
                                );
                              },
                            );

                            safeSetState(() {});
                          },
                          text: FFLocalizations.of(context).getText(
                            'icx6jk3n' /* Confirm */,
                          ),
                          options: FFButtonOptions(
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Builder(
                      builder: (context) => Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            if (!(_model.selectedCourses != null)) {
                              _model.paymentMethod =
                                  await queryPaymentMethodRecordCount(
                                parent: currentUserReference,
                              );
                              if (_model.paymentMethod! > 0) {
                                await showAlignedDialog(
                                  barrierColor:
                                      FlutterFlowTheme.of(context).transparent,
                                  context: context,
                                  isGlobal: false,
                                  avoidOverflow: false,
                                  targetAnchor: AlignmentDirectional(0.0, -1.0)
                                      .resolve(Directionality.of(context)),
                                  followerAnchor: AlignmentDirectional(0.0, 1.0)
                                      .resolve(Directionality.of(context)),
                                  builder: (dialogContext) {
                                    return Material(
                                      color: Colors.transparent,
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(dialogContext)
                                              .unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: ErrorTextWidget(
                                          text:
                                              'Please select a payment method before proceeding',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: AddPaymentMethodWidget(),
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              }
                            }

                            safeSetState(() {});
                          },
                          text: FFLocalizations.of(context).getText(
                            'sw6qi9le' /* Done */,
                          ),
                          options: FFButtonOptions(
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          showLoadingIndicator: false,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
