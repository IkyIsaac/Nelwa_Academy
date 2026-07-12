import '/flutter_flow/flutter_flow_util.dart';
import 'tags_widget.dart' show TagsWidget;
import 'package:flutter/material.dart';

class TagsModel extends FlutterFlowModel<TagsWidget> {
  ///  Local state fields for this component.

  List<String> selectedTags = [];
  void addToSelectedTags(String item) => selectedTags.add(item);
  void removeFromSelectedTags(String item) => selectedTags.remove(item);
  void removeAtIndexFromSelectedTags(int index) => selectedTags.removeAt(index);
  void insertAtIndexInSelectedTags(int index, String item) =>
      selectedTags.insert(index, item);
  void updateSelectedTagsAtIndex(int index, Function(String) updateFn) =>
      selectedTags[index] = updateFn(selectedTags[index]);

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
