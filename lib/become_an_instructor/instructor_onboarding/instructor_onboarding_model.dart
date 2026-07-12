import '/flutter_flow/flutter_flow_util.dart';
import 'instructor_onboarding_widget.dart' show InstructorOnboardingWidget;
import 'package:flutter/material.dart';

class InstructorOnboardingModel
    extends FlutterFlowModel<InstructorOnboardingWidget> {
  ///  Local state fields for this page.

  bool? yourSpecialty = false;

  bool? aboutYou = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for AboutYou widget.
  FocusNode? aboutYouFocusNode;
  TextEditingController? aboutYouTextController;
  String? Function(BuildContext, String?)? aboutYouTextControllerValidator;
  // State field(s) for Education widget.
  FocusNode? educationFocusNode;
  TextEditingController? educationTextController;
  String? Function(BuildContext, String?)? educationTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    aboutYouFocusNode?.dispose();
    aboutYouTextController?.dispose();

    educationFocusNode?.dispose();
    educationTextController?.dispose();
  }
}
