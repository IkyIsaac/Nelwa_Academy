import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/square_card/square_card_widget.dart';
import '/notifications/bell/bell_widget.dart';
import '/index.dart';
import 'instructor_page_widget.dart' show InstructorPageWidget;
import 'package:flutter/material.dart';

class InstructorPageModel extends FlutterFlowModel<InstructorPageWidget> {
  ///  Local state fields for this page.

  CategoriesStruct? selectedCourses;
  void updateSelectedCoursesStruct(Function(CategoriesStruct) updateFn) {
    updateFn(selectedCourses ??= CategoriesStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Models for SquareCard dynamic component.
  late FlutterFlowDynamicModels<SquareCardModel> squareCardModels1;
  // Models for SquareCard dynamic component.
  late FlutterFlowDynamicModels<SquareCardModel> squareCardModels2;
  // Model for Bell component.
  late BellModel bellModel;

  @override
  void initState(BuildContext context) {
    squareCardModels1 = FlutterFlowDynamicModels(() => SquareCardModel());
    squareCardModels2 = FlutterFlowDynamicModels(() => SquareCardModel());
    bellModel = createModel(context, () => BellModel());
  }

  @override
  void dispose() {
    squareCardModels1.dispose();
    squareCardModels2.dispose();
    bellModel.dispose();
  }
}
