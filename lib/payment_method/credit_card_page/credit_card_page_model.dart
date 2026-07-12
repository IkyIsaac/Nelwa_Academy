import '/flutter_flow/flutter_flow_util.dart';
import 'credit_card_page_widget.dart' show CreditCardPageWidget;
import 'package:flutter/material.dart';

class CreditCardPageModel extends FlutterFlowModel<CreditCardPageWidget> {
  ///  Local state fields for this page.

  bool defaultCard = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Nickname widget.
  FocusNode? nicknameFocusNode;
  TextEditingController? nicknameTextController;
  String? Function(BuildContext, String?)? nicknameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nicknameFocusNode?.dispose();
    nicknameTextController?.dispose();
  }
}
