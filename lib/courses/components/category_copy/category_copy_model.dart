import '/flutter_flow/flutter_flow_util.dart';
import 'category_copy_widget.dart' show CategoryCopyWidget;
import 'package:flutter/material.dart';

class CategoryCopyModel extends FlutterFlowModel<CategoryCopyWidget> {
  ///  Local state fields for this component.

  String? selectedCategory;

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
