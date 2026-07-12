import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/nav_bar/nav_bar_widget.dart';
import '/home/components/square_card/square_card_widget.dart';
import '/index.dart';
import 'courses_widget.dart' show CoursesWidget;
import 'package:flutter/material.dart';

class CoursesModel extends FlutterFlowModel<CoursesWidget> {
  ///  Local state fields for this page.

  CategoriesStruct? selectedCourses;
  void updateSelectedCoursesStruct(Function(CategoriesStruct) updateFn) {
    updateFn(selectedCourses ??= CategoriesStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Models for SquareCard dynamic component.
  late FlutterFlowDynamicModels<SquareCardModel> squareCardModels;
  // Model for NavBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    squareCardModels = FlutterFlowDynamicModels(() => SquareCardModel());
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    squareCardModels.dispose();
    navBarModel.dispose();
  }
}
