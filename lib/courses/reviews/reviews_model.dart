import '/flutter_flow/flutter_flow_util.dart';
import '/reviews/component/retings/retings_widget.dart';
import '/reviews/component/review/review_widget.dart';
import 'reviews_widget.dart' show ReviewsWidget;
import 'package:flutter/material.dart';

class ReviewsModel extends FlutterFlowModel<ReviewsWidget> {
  ///  Local state fields for this page.

  List<int> rates = [5, 4, 3, 2, 1];
  void addToRates(int item) => rates.add(item);
  void removeFromRates(int item) => rates.remove(item);
  void removeAtIndexFromRates(int index) => rates.removeAt(index);
  void insertAtIndexInRates(int index, int item) => rates.insert(index, item);
  void updateRatesAtIndex(int index, Function(int) updateFn) =>
      rates[index] = updateFn(rates[index]);

  double? selectedRate = 0.0;

  ///  State fields for stateful widgets in this page.

  // Model for Retings component.
  late RetingsModel retingsModel;
  // Models for Review dynamic component.
  late FlutterFlowDynamicModels<ReviewModel> reviewModels;

  @override
  void initState(BuildContext context) {
    retingsModel = createModel(context, () => RetingsModel());
    reviewModels = FlutterFlowDynamicModels(() => ReviewModel());
  }

  @override
  void dispose() {
    retingsModel.dispose();
    reviewModels.dispose();
  }
}
