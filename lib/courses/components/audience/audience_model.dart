import '/flutter_flow/flutter_flow_util.dart';
import 'audience_widget.dart' show AudienceWidget;
import 'package:flutter/material.dart';

class AudienceModel extends FlutterFlowModel<AudienceWidget> {
  ///  Local state fields for this component.

  List<String> selectedAudience = [];
  void addToSelectedAudience(String item) => selectedAudience.add(item);
  void removeFromSelectedAudience(String item) => selectedAudience.remove(item);
  void removeAtIndexFromSelectedAudience(int index) =>
      selectedAudience.removeAt(index);
  void insertAtIndexInSelectedAudience(int index, String item) =>
      selectedAudience.insert(index, item);
  void updateSelectedAudienceAtIndex(int index, Function(String) updateFn) =>
      selectedAudience[index] = updateFn(selectedAudience[index]);

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
