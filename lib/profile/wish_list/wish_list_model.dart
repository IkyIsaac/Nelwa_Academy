import '/flutter_flow/flutter_flow_util.dart';
import '/profile/components/wish_list_card/wish_list_card_widget.dart';
import 'wish_list_widget.dart' show WishListWidget;
import 'package:flutter/material.dart';

class WishListModel extends FlutterFlowModel<WishListWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for WishListCard dynamic component.
  late FlutterFlowDynamicModels<WishListCardModel> wishListCardModels;

  @override
  void initState(BuildContext context) {
    wishListCardModels = FlutterFlowDynamicModels(() => WishListCardModel());
  }

  @override
  void dispose() {
    wishListCardModels.dispose();
  }
}
