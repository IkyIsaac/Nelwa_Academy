import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/horizontal_card/horizontal_card_widget.dart';
import '/home/components/square_card/square_card_widget.dart';
import 'instructor_courses_widget.dart' show InstructorCoursesWidget;
import 'package:flutter/material.dart';

class InstructorCoursesModel extends FlutterFlowModel<InstructorCoursesWidget> {
  ///  Local state fields for this page.

  bool? show = false;

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
