import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/empty_state/empty_sales_reports/empty_sales_reports_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/loading/loading_sales_reports/loading_sales_reports_widget.dart';
import '/profile/components/sales_reports_card/sales_reports_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sales_reports_model.dart';
export 'sales_reports_model.dart';

class SalesReportsWidget extends StatefulWidget {
  const SalesReportsWidget({super.key});

  static String routeName = 'SalesReports';
  static String routePath = '/salesReports';

  @override
  State<SalesReportsWidget> createState() => _SalesReportsWidgetState();
}

class _SalesReportsWidgetState extends State<SalesReportsWidget> {
  late SalesReportsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SalesReportsModel());

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
              'ln6t7nrm' /* Sales Reports */,
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
          actions: [],
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
        body: StreamBuilder<List<PaymentAccountRecord>>(
          stream: queryPaymentAccountRecord(
            parent: currentUserReference,
            singleRecord: true,
          ),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
              return LoadingSalesReportsWidget();
            }
            List<PaymentAccountRecord> containerPaymentAccountRecordList =
                snapshot.data!;
            final containerPaymentAccountRecord =
                containerPaymentAccountRecordList.isNotEmpty
                    ? containerPaymentAccountRecordList.first
                    : null;

            return Container(
              decoration: BoxDecoration(),
              child: Builder(
                builder: (context) {
                  final salesReportsList = containerPaymentAccountRecord
                          ?.salesReports
                          .sortedList(keyOf: (e) => e.date!, desc: true)
                          .toList() ??
                      [];
                  if (salesReportsList.isEmpty) {
                    return EmptySalesReportsWidget();
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
                    itemCount: salesReportsList.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.0),
                    itemBuilder: (context, salesReportsListIndex) {
                      final salesReportsListItem =
                          salesReportsList[salesReportsListIndex];
                      return wrapWithModel(
                        model: _model.salesReportsCardModels.getModel(
                          salesReportsListIndex.toString(),
                          salesReportsListIndex,
                        ),
                        updateCallback: () => safeSetState(() {}),
                        child: SalesReportsCardWidget(
                          key: Key(
                            'Keyxy9_${salesReportsListIndex.toString()}',
                          ),
                          salesReports: salesReportsListItem,
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
