import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'verify_code_widget.dart' show VerifyCodeWidget;
import 'package:flutter/material.dart';

class VerifyCodeModel extends FlutterFlowModel<VerifyCodeWidget> {
  ///  Local state fields for this page.

  bool invalidCode = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
  }
}
