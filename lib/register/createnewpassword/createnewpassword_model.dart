import '/flutter_flow/flutter_flow_util.dart';
import 'createnewpassword_widget.dart' show CreatenewpasswordWidget;
import 'package:flutter/material.dart';

class CreatenewpasswordModel extends FlutterFlowModel<CreatenewpasswordWidget> {
  ///  Local state fields for this page.

  bool rememberMe = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Password widget.
  FocusNode? passwordFocusNode1;
  TextEditingController? passwordTextController1;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? passwordTextController1Validator;
  String? _passwordTextController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'snvqt97d' /* Please enter your password */,
      );
    }

    if (val.length < 6) {
      return FFLocalizations.of(context).getText(
        '7nybg9hi' /* Password must be at least 6 ch... */,
      );
    }

    return null;
  }

  // State field(s) for Password widget.
  FocusNode? passwordFocusNode2;
  TextEditingController? passwordTextController2;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)? passwordTextController2Validator;
  String? _passwordTextController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'tggqymyc' /* Please enter your password */,
      );
    }

    if (val.length < 6) {
      return FFLocalizations.of(context).getText(
        'abbdkja1' /* Password must be at least 6 ch... */,
      );
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    passwordVisibility1 = false;
    passwordTextController1Validator = _passwordTextController1Validator;
    passwordVisibility2 = false;
    passwordTextController2Validator = _passwordTextController2Validator;
  }

  @override
  void dispose() {
    passwordFocusNode1?.dispose();
    passwordTextController1?.dispose();

    passwordFocusNode2?.dispose();
    passwordTextController2?.dispose();
  }
}
