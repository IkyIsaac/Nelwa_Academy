import '/flutter_flow/flutter_flow_util.dart';
import '/reviews/component/reports_type/reports_type_widget.dart';
import 'report_widget.dart' show ReportWidget;
import 'package:flutter/material.dart';

class ReportModel extends FlutterFlowModel<ReportWidget> {
  ///  Local state fields for this component.

  List<String> reviewReports = [
    'Technical Issues',
    'Content Issues',
    'User Behavior',
    'Payment & Refund Issues',
    'Accessibility Issues',
    'Other'
  ];
  void addToReviewReports(String item) => reviewReports.add(item);
  void removeFromReviewReports(String item) => reviewReports.remove(item);
  void removeAtIndexFromReviewReports(int index) =>
      reviewReports.removeAt(index);
  void insertAtIndexInReviewReports(int index, String item) =>
      reviewReports.insert(index, item);
  void updateReviewReportsAtIndex(int index, Function(String) updateFn) =>
      reviewReports[index] = updateFn(reviewReports[index]);

  List<String> lessonReports = [
    'Technical Issues',
    'Content Issues',
    'Language & Accessibility Issues',
    'Inappropriate Content',
    'Other'
  ];
  void addToLessonReports(String item) => lessonReports.add(item);
  void removeFromLessonReports(String item) => lessonReports.remove(item);
  void removeAtIndexFromLessonReports(int index) =>
      lessonReports.removeAt(index);
  void insertAtIndexInLessonReports(int index, String item) =>
      lessonReports.insert(index, item);
  void updateLessonReportsAtIndex(int index, Function(String) updateFn) =>
      lessonReports[index] = updateFn(lessonReports[index]);

  List<String> coursesReports = [
    'Technical Issues',
    'Content Issues',
    'Language & Accessibility Issues',
    'Inappropriate Content',
    'Instructor Misconduct',
    'Duplicate or Low-Quality Course',
    'Course Not as Described',
    'Spam or Promotional Content',
    'Plagiarized Content',
    'Other'
  ];
  void addToCoursesReports(String item) => coursesReports.add(item);
  void removeFromCoursesReports(String item) => coursesReports.remove(item);
  void removeAtIndexFromCoursesReports(int index) =>
      coursesReports.removeAt(index);
  void insertAtIndexInCoursesReports(int index, String item) =>
      coursesReports.insert(index, item);
  void updateCoursesReportsAtIndex(int index, Function(String) updateFn) =>
      coursesReports[index] = updateFn(coursesReports[index]);

  ///  State fields for stateful widgets in this component.

  // Models for ReportsType dynamic component.
  late FlutterFlowDynamicModels<ReportsTypeModel> reportsTypeModels1;
  // Models for ReportsType dynamic component.
  late FlutterFlowDynamicModels<ReportsTypeModel> reportsTypeModels2;
  // Models for ReportsType dynamic component.
  late FlutterFlowDynamicModels<ReportsTypeModel> reportsTypeModels3;

  @override
  void initState(BuildContext context) {
    reportsTypeModels1 = FlutterFlowDynamicModels(() => ReportsTypeModel());
    reportsTypeModels2 = FlutterFlowDynamicModels(() => ReportsTypeModel());
    reportsTypeModels3 = FlutterFlowDynamicModels(() => ReportsTypeModel());
  }

  @override
  void dispose() {
    reportsTypeModels1.dispose();
    reportsTypeModels2.dispose();
    reportsTypeModels3.dispose();
  }
}
