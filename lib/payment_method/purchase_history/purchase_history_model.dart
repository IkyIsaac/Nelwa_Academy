import '/flutter_flow/flutter_flow_util.dart';
import '/profile/components/purchase_history2/purchase_history2_widget.dart';
import 'purchase_history_widget.dart' show PurchaseHistoryWidget;
import 'package:flutter/material.dart';

class PurchaseHistoryModel extends FlutterFlowModel<PurchaseHistoryWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for PurchaseHistory2 dynamic component.
  late FlutterFlowDynamicModels<PurchaseHistory2Model> purchaseHistory2Models;

  @override
  void initState(BuildContext context) {
    purchaseHistory2Models =
        FlutterFlowDynamicModels(() => PurchaseHistory2Model());
  }

  @override
  void dispose() {
    purchaseHistory2Models.dispose();
  }
}
