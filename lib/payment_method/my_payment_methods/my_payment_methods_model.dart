import '/flutter_flow/flutter_flow_util.dart';
import '/payment_method/components/payment_methods_card/payment_methods_card_widget.dart';
import 'my_payment_methods_widget.dart' show MyPaymentMethodsWidget;
import 'package:flutter/material.dart';

class MyPaymentMethodsModel extends FlutterFlowModel<MyPaymentMethodsWidget> {
  ///  Local state fields for this page.

  DocumentReference? paymentMethods;

  ///  State fields for stateful widgets in this page.

  // Models for PaymentMethodsCard dynamic component.
  late FlutterFlowDynamicModels<PaymentMethodsCardModel>
      paymentMethodsCardModels;

  @override
  void initState(BuildContext context) {
    paymentMethodsCardModels =
        FlutterFlowDynamicModels(() => PaymentMethodsCardModel());
  }

  @override
  void dispose() {
    paymentMethodsCardModels.dispose();
  }
}
