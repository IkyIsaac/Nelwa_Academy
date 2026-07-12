import '/flutter_flow/flutter_flow_util.dart';
import 'loading_analytics_widget.dart' show LoadingAnalyticsWidget;
import 'package:flutter/material.dart';

class LoadingAnalyticsModel extends FlutterFlowModel<LoadingAnalyticsWidget> {
  ///  Local state fields for this component.

  List<int> items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
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
