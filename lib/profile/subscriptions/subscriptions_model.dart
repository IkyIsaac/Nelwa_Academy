import '/flutter_flow/flutter_flow_util.dart';
import '/profile/components/subscriptions_card/subscriptions_card_widget.dart';
import 'subscriptions_widget.dart' show SubscriptionsWidget;
import 'package:flutter/material.dart';

class SubscriptionsModel extends FlutterFlowModel<SubscriptionsWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for SubscriptionsCard dynamic component.
  late FlutterFlowDynamicModels<SubscriptionsCardModel> subscriptionsCardModels;

  @override
  void initState(BuildContext context) {
    subscriptionsCardModels =
        FlutterFlowDynamicModels(() => SubscriptionsCardModel());
  }

  @override
  void dispose() {
    subscriptionsCardModels.dispose();
  }
}
