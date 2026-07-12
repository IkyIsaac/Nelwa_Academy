import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'lesson_page_widget.dart' show LessonPageWidget;
import 'package:flutter/material.dart';

class LessonPageModel extends FlutterFlowModel<LessonPageWidget> {
  ///  Local state fields for this page.

  bool moreDescription = false;

  bool showVideo = false;

  ContinueWatchingStruct? continueWatching;
  void updateContinueWatchingStruct(Function(ContinueWatchingStruct) updateFn) {
    updateFn(continueWatching ??= ContinueWatchingStruct());
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
