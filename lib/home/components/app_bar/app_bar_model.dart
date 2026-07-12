import '/flutter_flow/flutter_flow_util.dart';
import '/notifications/bell/bell_widget.dart';
import 'app_bar_widget.dart' show AppBarWidget;
import 'package:flutter/material.dart';

class AppBarModel extends FlutterFlowModel<AppBarWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for Bell component.
  late BellModel bellModel;

  @override
  void initState(BuildContext context) {
    bellModel = createModel(context, () => BellModel());
  }

  @override
  void dispose() {
    bellModel.dispose();
  }
}
