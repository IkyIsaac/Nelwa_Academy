import '/flutter_flow/flutter_flow_util.dart';
import '/reviews/component/my_review_card/my_review_card_widget.dart';
import '/reviews/component/pending_review/pending_review_widget.dart';
import 'my_reviews_widget.dart' show MyReviewsWidget;
import 'package:flutter/material.dart';

class MyReviewsModel extends FlutterFlowModel<MyReviewsWidget> {
  ///  Local state fields for this page.

  int? pageViewItem = 0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Models for PendingReview dynamic component.
  late FlutterFlowDynamicModels<PendingReviewModel> pendingReviewModels;
  // Models for MyReviewCard dynamic component.
  late FlutterFlowDynamicModels<MyReviewCardModel> myReviewCardModels;

  @override
  void initState(BuildContext context) {
    pendingReviewModels = FlutterFlowDynamicModels(() => PendingReviewModel());
    myReviewCardModels = FlutterFlowDynamicModels(() => MyReviewCardModel());
  }

  @override
  void dispose() {
    pendingReviewModels.dispose();
    myReviewCardModels.dispose();
  }
}
