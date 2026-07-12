import '/buttons/text_right/text_right_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'about_skill_base_widget.dart' show AboutSkillBaseWidget;
import 'package:flutter/material.dart';

class AboutSkillBaseModel extends FlutterFlowModel<AboutSkillBaseWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextRight component.
  late TextRightModel textRightModel1;
  // Model for TextRight component.
  late TextRightModel textRightModel2;
  // Model for TextRight component.
  late TextRightModel textRightModel3;
  // Model for TextRight component.
  late TextRightModel textRightModel4;
  // Model for TextRight component.
  late TextRightModel textRightModel5;

  @override
  void initState(BuildContext context) {
    textRightModel1 = createModel(context, () => TextRightModel());
    textRightModel2 = createModel(context, () => TextRightModel());
    textRightModel3 = createModel(context, () => TextRightModel());
    textRightModel4 = createModel(context, () => TextRightModel());
    textRightModel5 = createModel(context, () => TextRightModel());
  }

  @override
  void dispose() {
    textRightModel1.dispose();
    textRightModel2.dispose();
    textRightModel3.dispose();
    textRightModel4.dispose();
    textRightModel5.dispose();
  }
}
