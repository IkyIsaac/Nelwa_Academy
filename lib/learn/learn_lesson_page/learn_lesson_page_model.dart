import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'learn_lesson_page_widget.dart' show LearnLessonPageWidget;
import 'package:flutter/material.dart';

class LearnLessonPageModel extends FlutterFlowModel<LearnLessonPageWidget> {
  ///  Local state fields for this page.

  bool moreDescription = false;

  bool showVideo = false;

  ContinueWatchingStruct? continueWatching;
  void updateContinueWatchingStruct(Function(ContinueWatchingStruct) updateFn) {
    updateFn(continueWatching ??= ContinueWatchingStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in LearnLessonPage widget.
  PurchasedCoursesRecord? purchasedCourses;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
