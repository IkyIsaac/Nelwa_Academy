import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/category_card/category_card_widget.dart';
import 'all_categories_page_widget.dart' show AllCategoriesPageWidget;
import 'package:flutter/material.dart';

class AllCategoriesPageModel extends FlutterFlowModel<AllCategoriesPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for CategoryCard dynamic component.
  late FlutterFlowDynamicModels<CategoryCardModel> categoryCardModels;

  @override
  void initState(BuildContext context) {
    categoryCardModels = FlutterFlowDynamicModels(() => CategoryCardModel());
  }

  @override
  void dispose() {
    categoryCardModels.dispose();
  }
}
