import '/flutter_flow/flutter_flow_util.dart';
import 'retings_widget.dart' show RetingsWidget;
import 'package:flutter/material.dart';

class RetingsModel extends FlutterFlowModel<RetingsWidget> {
  ///  Local state fields for this component.

  List<int> ratings = [5, 4, 3, 2, 1];
  void addToRatings(int item) => ratings.add(item);
  void removeFromRatings(int item) => ratings.remove(item);
  void removeAtIndexFromRatings(int index) => ratings.removeAt(index);
  void insertAtIndexInRatings(int index, int item) =>
      ratings.insert(index, item);
  void updateRatingsAtIndex(int index, Function(int) updateFn) =>
      ratings[index] = updateFn(ratings[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
