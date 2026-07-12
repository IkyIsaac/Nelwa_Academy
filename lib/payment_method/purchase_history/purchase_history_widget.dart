import '/backend/backend.dart';
import '/empty_state/empty_purchase_history/empty_purchase_history_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/loading/loading_sales_reports/loading_sales_reports_widget.dart';
import '/profile/components/purchase_history2/purchase_history2_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'purchase_history_model.dart';
export 'purchase_history_model.dart';

class PurchaseHistoryWidget extends StatefulWidget {
  const PurchaseHistoryWidget({super.key});

  static String routeName = 'PurchaseHistory';
  static String routePath = '/purchaseHistory';

  @override
  State<PurchaseHistoryWidget> createState() => _PurchaseHistoryWidgetState();
}

class _PurchaseHistoryWidgetState extends State<PurchaseHistoryWidget> {
  late PurchaseHistoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PurchaseHistoryModel());

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
              '5bhwug57' /* Purchase History */,
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
        body: StreamBuilder<List<PurchaseHistoryRecord>>(
          stream: queryPurchaseHistoryRecord(
            queryBuilder: (purchaseHistoryRecord) =>
                purchaseHistoryRecord.orderBy('date', descending: true),
          ),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
              return LoadingSalesReportsWidget();
            }
            List<PurchaseHistoryRecord> listViewPurchaseHistoryRecordList =
                snapshot.data!;
            if (listViewPurchaseHistoryRecordList.isEmpty) {
              return EmptyPurchaseHistoryWidget();
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
              itemCount: listViewPurchaseHistoryRecordList.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.0),
              itemBuilder: (context, listViewIndex) {
                final listViewPurchaseHistoryRecord =
                    listViewPurchaseHistoryRecordList[listViewIndex];
                return wrapWithModel(
                  model: _model.purchaseHistory2Models.getModel(
                    listViewIndex.toString(),
                    listViewIndex,
                  ),
                  updateCallback: () => safeSetState(() {}),
                  child: PurchaseHistory2Widget(
                    key: Key(
                      'Keyr07_${listViewIndex.toString()}',
                    ),
                    purchaseHistory: listViewPurchaseHistoryRecord,
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
