import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/optionals_buttons/optionals_buttons_widget.dart';
import 'learn_optional_widget.dart' show LearnOptionalWidget;
import 'package:flutter/material.dart';

class LearnOptionalModel extends FlutterFlowModel<LearnOptionalWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel1;
  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel2;
  // Model for OptionalsButtons component.
  late OptionalsButtonsModel optionalsButtonsModel3;

  @override
  void initState(BuildContext context) {
    optionalsButtonsModel1 =
        createModel(context, () => OptionalsButtonsModel());
    optionalsButtonsModel2 =
        createModel(context, () => OptionalsButtonsModel());
    optionalsButtonsModel3 =
        createModel(context, () => OptionalsButtonsModel());
  }

  @override
  void dispose() {
    optionalsButtonsModel1.dispose();
    optionalsButtonsModel2.dispose();
    optionalsButtonsModel3.dispose();
  }
}
