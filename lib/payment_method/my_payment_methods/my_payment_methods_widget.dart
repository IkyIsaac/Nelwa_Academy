import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/empty_state/empty_payment/empty_payment_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/loading/loading_payment/loading_payment_widget.dart';
import '/payment_method/components/add_payment_method/add_payment_method_widget.dart';
import '/payment_method/components/payment_methods_card/payment_methods_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'my_payment_methods_model.dart';
export 'my_payment_methods_model.dart';

class MyPaymentMethodsWidget extends StatefulWidget {
  const MyPaymentMethodsWidget({super.key});

  static String routeName = 'MyPaymentMethods';
  static String routePath = '/myPaymentMethods';

  @override
  State<MyPaymentMethodsWidget> createState() => _MyPaymentMethodsWidgetState();
}

class _MyPaymentMethodsWidgetState extends State<MyPaymentMethodsWidget> {
  late MyPaymentMethodsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyPaymentMethodsModel());

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
          title: Text(
            FFLocalizations.of(context).getText(
              '3vksamd3' /* Payment Method */,
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
        body: StreamBuilder<List<PaymentMethodRecord>>(
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
                return wrapWithModel(
                  model: _model.paymentMethodsCardModels.getModel(
                    listViewIndex.toString(),
                    listViewIndex,
                  ),
                  updateCallback: () => safeSetState(() {}),
                  child: PaymentMethodsCardWidget(
                    key: Key(
                      'Keymdv_${listViewIndex.toString()}',
                    ),
                    paymentMethods: listViewPaymentMethodRecord,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
