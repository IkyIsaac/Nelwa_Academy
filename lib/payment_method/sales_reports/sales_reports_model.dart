import '/flutter_flow/flutter_flow_util.dart';
import '/profile/components/sales_reports_card/sales_reports_card_widget.dart';
import 'sales_reports_widget.dart' show SalesReportsWidget;
import 'package:flutter/material.dart';

class SalesReportsModel extends FlutterFlowModel<SalesReportsWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for SalesReportsCard dynamic component.
  late FlutterFlowDynamicModels<SalesReportsCardModel> salesReportsCardModels;

  @override
  void initState(BuildContext context) {
    salesReportsCardModels =
        FlutterFlowDynamicModels(() => SalesReportsCardModel());
  }

  @override
  void dispose() {
    salesReportsCardModels.dispose();
  }
}
