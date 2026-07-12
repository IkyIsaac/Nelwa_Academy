import '/flutter_flow/flutter_flow_util.dart';
import 'add_new_tag_widget.dart' show AddNewTagWidget;
import 'package:flutter/material.dart';

class AddNewTagModel extends FlutterFlowModel<AddNewTagWidget> {
  ///  Local state fields for this component.

  bool? error = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for CategoryName widget.
  FocusNode? categoryNameFocusNode;
  TextEditingController? categoryNameTextController;
  String? Function(BuildContext, String?)? categoryNameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    categoryNameFocusNode?.dispose();
    categoryNameTextController?.dispose();
  }
}
