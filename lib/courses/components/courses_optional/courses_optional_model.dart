import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/optionals_buttons/optionals_buttons_widget.dart';
import 'courses_optional_widget.dart' show CoursesOptionalWidget;
import 'package:flutter/material.dart';

class CoursesOptionalModel extends FlutterFlowModel<CoursesOptionalWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel1;
  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel2;
  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel3;
  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel4;
  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel5;

  @override
  void initState(BuildContext context) {
    optionalsButtonsModel1 =
        createModel(context, () => OptionalsButtonsModel());
    optionalsButtonsModel2 =
        createModel(context, () => OptionalsButtonsModel());
    optionalsButtonsModel3 =
        createModel(context, () => OptionalsButtonsModel());
    optionalsButtonsModel4 =
        createModel(context, () => OptionalsButtonsModel());
    optionalsButtonsModel5 =
        createModel(context, () => OptionalsButtonsModel());
  }

  @override
  void dispose() {
    optionalsButtonsModel1.dispose();
    optionalsButtonsModel2.dispose();
    optionalsButtonsModel3.dispose();
    optionalsButtonsModel4.dispose();
    optionalsButtonsModel5.dispose();
  }
}
