import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/app_bar/app_bar_widget.dart';
import '/home/components/continue_watching/continue_watching_widget.dart';
import '/home/components/courses_card/courses_card_widget.dart';
import '/home/components/nav_bar/nav_bar_widget.dart';
import '/home/components/topics/topics_widget.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  CategoriesStruct? selectedCourses;
  void updateSelectedCoursesStruct(Function(CategoriesStruct) updateFn) {
    updateFn(selectedCourses ??= CategoriesStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Model for AppBar component.
  late AppBarModel appBarModel;
  // Model for Topics component.
  late TopicsModel topicsModel;
  // Models for CoursesCard dynamic component.
  late FlutterFlowDynamicModels<CoursesCardModel> coursesCardModels1;
  // Models for CoursesCard dynamic component.
  late FlutterFlowDynamicModels<CoursesCardModel> coursesCardModels2;
  // Models for ContinueWatching dynamic component.
  late FlutterFlowDynamicModels<ContinueWatchingModel> continueWatchingModels;
  // Models for CoursesCard dynamic component.
  late FlutterFlowDynamicModels<CoursesCardModel> coursesCardModels3;
  // Models for CoursesCard dynamic component.
  late FlutterFlowDynamicModels<CoursesCardModel> coursesCardModels4;
  // Model for NavBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    appBarModel = createModel(context, () => AppBarModel());
    topicsModel = createModel(context, () => TopicsModel());
    coursesCardModels1 = FlutterFlowDynamicModels(() => CoursesCardModel());
    coursesCardModels2 = FlutterFlowDynamicModels(() => CoursesCardModel());
    continueWatchingModels =
        FlutterFlowDynamicModels(() => ContinueWatchingModel());
    coursesCardModels3 = FlutterFlowDynamicModels(() => CoursesCardModel());
    coursesCardModels4 = FlutterFlowDynamicModels(() => CoursesCardModel());
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    appBarModel.dispose();
    topicsModel.dispose();
    coursesCardModels1.dispose();
    coursesCardModels2.dispose();
    continueWatchingModels.dispose();
    coursesCardModels3.dispose();
    coursesCardModels4.dispose();
    navBarModel.dispose();
  }
}
