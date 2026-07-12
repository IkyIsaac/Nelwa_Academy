import '/buttons/text_switch/text_switch_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'notifications_settings_widget.dart' show NotificationsSettingsWidget;
import 'package:flutter/material.dart';

class NotificationsSettingsModel
    extends FlutterFlowModel<NotificationsSettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel1;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel2;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel3;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel4;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel5;

  @override
  void initState(BuildContext context) {
    textSwitchModel1 = createModel(context, () => TextSwitchModel());
    textSwitchModel2 = createModel(context, () => TextSwitchModel());
    textSwitchModel3 = createModel(context, () => TextSwitchModel());
    textSwitchModel4 = createModel(context, () => TextSwitchModel());
    textSwitchModel5 = createModel(context, () => TextSwitchModel());
  }

  @override
  void dispose() {
    textSwitchModel1.dispose();
    textSwitchModel2.dispose();
    textSwitchModel3.dispose();
    textSwitchModel4.dispose();
    textSwitchModel5.dispose();
  }
}
