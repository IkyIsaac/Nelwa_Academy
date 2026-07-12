import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/category_card/category_card_widget.dart';
import '/home/components/courses_card/courses_card_widget.dart';
import '/home/components/search_results/search_results_widget.dart';
import '/index.dart';
import 'search_widget.dart' show SearchWidget;
import 'package:flutter/material.dart';

class SearchModel extends FlutterFlowModel<SearchWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for SearchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;
  List<CoursesRecord> simpleSearchResults = [];
  // Models for SearchResults dynamic component.
  late FlutterFlowDynamicModels<SearchResultsModel> searchResultsModels;
  // Models for CategoryCard dynamic component.
  late FlutterFlowDynamicModels<CategoryCardModel> categoryCardModels1;
  // Models for CategoryCard dynamic component.
  late FlutterFlowDynamicModels<CategoryCardModel> categoryCardModels2;
  // Models for CoursesCard dynamic component.
  late FlutterFlowDynamicModels<CoursesCardModel> coursesCardModels;

  @override
  void initState(BuildContext context) {
    searchResultsModels = FlutterFlowDynamicModels(() => SearchResultsModel());
    categoryCardModels1 = FlutterFlowDynamicModels(() => CategoryCardModel());
    categoryCardModels2 = FlutterFlowDynamicModels(() => CategoryCardModel());
    coursesCardModels = FlutterFlowDynamicModels(() => CoursesCardModel());
  }

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();

    searchResultsModels.dispose();
    categoryCardModels1.dispose();
    categoryCardModels2.dispose();
    coursesCardModels.dispose();
  }
}
