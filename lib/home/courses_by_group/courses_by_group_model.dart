import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/horizontal_card/horizontal_card_widget.dart';
import '/home/components/square_card/square_card_widget.dart';
import 'courses_by_group_widget.dart' show CoursesByGroupWidget;
import 'package:flutter/material.dart';

class CoursesByGroupModel extends FlutterFlowModel<CoursesByGroupWidget> {
  ///  Local state fields for this page.

  bool? show = true;

  ///  State fields for stateful widgets in this page.

  // Models for SquareCard dynamic component.
  late FlutterFlowDynamicModels<SquareCardModel> squareCardModels;
  // Models for HorizontalCard dynamic component.
  late FlutterFlowDynamicModels<HorizontalCardModel> horizontalCardModels;

  @override
  void initState(BuildContext context) {
    squareCardModels = FlutterFlowDynamicModels(() => SquareCardModel());
    horizontalCardModels =
        FlutterFlowDynamicModels(() => HorizontalCardModel());
  }

  @override
  void dispose() {
    squareCardModels.dispose();
    horizontalCardModels.dispose();
  }
}
