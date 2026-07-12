import '/courses/components/adda_new_lesson/adda_new_lesson_widget.dart';
import '/courses/components/lessons_card/lessons_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/learn/learn_lessons_card/learn_lessons_card_widget.dart';
import '/index.dart';
import 'courses_page_copy_copy_widget.dart' show CoursesPageCopyCopyWidget;
import 'package:flutter/material.dart';

class CoursesPageCopyCopyModel
    extends FlutterFlowModel<CoursesPageCopyCopyWidget> {
  ///  Local state fields for this page.

  bool moreDescription = false;

  bool showVideo = true;

  bool? yearlySelected = false;

  ///  State fields for stateful widgets in this page.

  // Model for AddaNewLesson component.
  late AddaNewLessonModel addaNewLessonModel;
  // Models for LearnLessonsCard dynamic component.
  late FlutterFlowDynamicModels<LearnLessonsCardModel> learnLessonsCardModels;
  // Models for LessonsCard dynamic component.
  late FlutterFlowDynamicModels<LessonsCardModel> lessonsCardModels;
  // State field(s) for monthly widget.
  bool? monthlyValue;
  // State field(s) for yearly widget.
  bool? yearlyValue;

  @override
  void initState(BuildContext context) {
    addaNewLessonModel = createModel(context, () => AddaNewLessonModel());
    learnLessonsCardModels =
        FlutterFlowDynamicModels(() => LearnLessonsCardModel());
    lessonsCardModels = FlutterFlowDynamicModels(() => LessonsCardModel());
  }

  @override
  void dispose() {
    addaNewLessonModel.dispose();
    learnLessonsCardModels.dispose();
    lessonsCardModels.dispose();
  }
}
