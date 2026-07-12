import '/flutter_flow/flutter_flow_util.dart';
import 'loading_my_review_widget.dart' show LoadingMyReviewWidget;
import 'package:flutter/material.dart';

class LoadingMyReviewModel extends FlutterFlowModel<LoadingMyReviewWidget> {
  ///  Local state fields for this component.

  List<int> items = [1, 2];
  void addToItems(int item) => items.add(item);
  void removeFromItems(int item) => items.remove(item);
  void removeAtIndexFromItems(int index) => items.removeAt(index);
  void insertAtIndexInItems(int index, int item) => items.insert(index, item);
  void updateItemsAtIndex(int index, Function(int) updateFn) =>
      items[index] = updateFn(items[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
