import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/nav_bar/nav_bar_widget.dart';
import '/learn/my_courses/my_courses_widget.dart';
import '/index.dart';
import 'learn_copy_widget.dart' show LearnCopyWidget;
import 'package:flutter/material.dart';

class LearnCopyModel extends FlutterFlowModel<LearnCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for MyCourses dynamic component.
  late FlutterFlowDynamicModels<MyCoursesModel> myCoursesModels;
  // Model for NavBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    myCoursesModels = FlutterFlowDynamicModels(() => MyCoursesModel());
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    myCoursesModels.dispose();
    navBarModel.dispose();
  }
}
