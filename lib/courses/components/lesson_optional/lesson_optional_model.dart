import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/optionals_buttons/optionals_buttons_widget.dart';
import 'lesson_optional_widget.dart' show LessonOptionalWidget;
import 'package:flutter/material.dart';

class LessonOptionalModel extends FlutterFlowModel<LessonOptionalWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel1;
  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel2;

  @override
  void initState(BuildContext context) {
    optionalsButtonsModel1 =
        createModel(context, () => OptionalsButtonsModel());
    optionalsButtonsModel2 =
        createModel(context, () => OptionalsButtonsModel());
  }

  @override
  void dispose() {
    optionalsButtonsModel1.dispose();
    optionalsButtonsModel2.dispose();
  }
}
