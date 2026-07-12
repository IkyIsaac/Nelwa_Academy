import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'country_widget.dart' show CountryWidget;
import 'package:flutter/material.dart';

class CountryModel extends FlutterFlowModel<CountryWidget> {
  ///  Local state fields for this component.

  CountryStruct? selectedCountry;
  void updateSelectedCountryStruct(Function(CountryStruct) updateFn) {
    updateFn(selectedCountry ??= CountryStruct());
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
