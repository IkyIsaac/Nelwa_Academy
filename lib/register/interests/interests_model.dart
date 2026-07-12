import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'interests_widget.dart' show InterestsWidget;
import 'package:flutter/material.dart';

class InterestsModel extends FlutterFlowModel<InterestsWidget> {
  ///  Local state fields for this page.

  int? pageViewItem = 0;

  List<String> selectedInterests = [];
  void addToSelectedInterests(String item) => selectedInterests.add(item);
  void removeFromSelectedInterests(String item) =>
      selectedInterests.remove(item);
  void removeAtIndexFromSelectedInterests(int index) =>
      selectedInterests.removeAt(index);
  void insertAtIndexInSelectedInterests(int index, String item) =>
      selectedInterests.insert(index, item);
  void updateSelectedInterestsAtIndex(int index, Function(String) updateFn) =>
      selectedInterests[index] = updateFn(selectedInterests[index]);

  String selectedExperience = 'Newcomer';

  String? useFor = 'I want to improve my skills';

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for interestsSearch widget.
  FocusNode? interestsSearchFocusNode;
  TextEditingController? interestsSearchTextController;
  String? Function(BuildContext, String?)?
      interestsSearchTextControllerValidator;
  List<String> simpleSearchResults = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    interestsSearchFocusNode?.dispose();
    interestsSearchTextController?.dispose();
  }
}
