import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'language1_widget.dart' show Language1Widget;
import 'package:flutter/material.dart';

class Language1Model extends FlutterFlowModel<Language1Widget> {
  ///  Local state fields for this component.

  LanguageStruct? selectedLanguage;
  void updateSelectedLanguageStruct(Function(LanguageStruct) updateFn) {
    updateFn(selectedLanguage ??= LanguageStruct());
  }

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
