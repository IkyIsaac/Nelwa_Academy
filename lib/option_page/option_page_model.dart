import '/components/option_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'option_page_widget.dart' show OptionPageWidget;
import 'package:flutter/material.dart';

class OptionPageModel extends FlutterFlowModel<OptionPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for optionComponent component.
  late OptionComponentModel optionComponentModel;

  @override
  void initState(BuildContext context) {
    optionComponentModel = createModel(context, () => OptionComponentModel());
  }

  @override
  void dispose() {
    optionComponentModel.dispose();
  }
}
