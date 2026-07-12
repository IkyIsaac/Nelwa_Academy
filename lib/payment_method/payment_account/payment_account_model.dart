import '/empty_state/empty_payment_account/empty_payment_account_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/profile/components/sales_reports_card/sales_reports_card_widget.dart';
import '/index.dart';
import 'payment_account_widget.dart' show PaymentAccountWidget;
import 'package:flutter/material.dart';

class PaymentAccountModel extends FlutterFlowModel<PaymentAccountWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for SalesReportsCard dynamic component.
  late FlutterFlowDynamicModels<SalesReportsCardModel> salesReportsCardModels;
  // Model for EmptyPaymentAccount component.
  late EmptyPaymentAccountModel emptyPaymentAccountModel;

  @override
  void initState(BuildContext context) {
    salesReportsCardModels =
        FlutterFlowDynamicModels(() => SalesReportsCardModel());
    emptyPaymentAccountModel =
        createModel(context, () => EmptyPaymentAccountModel());
  }

  @override
  void dispose() {
    salesReportsCardModels.dispose();
    emptyPaymentAccountModel.dispose();
  }
}
