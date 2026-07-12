import '/flutter_flow/flutter_flow_util.dart';
import 'instructor_specialty_widget.dart' show InstructorSpecialtyWidget;
import 'package:flutter/material.dart';

class InstructorSpecialtyModel
    extends FlutterFlowModel<InstructorSpecialtyWidget> {
  ///  Local state fields for this component.

  String? selectedSpecialty = 'UI/UX Design';

  ///  State fields for stateful widgets in this component.

  // State field(s) for Search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;
  String? Function(BuildContext, String?)? searchTextControllerValidator;
  List<String> simpleSearchResults = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchTextController?.dispose();
  }
}
