import '/courses/components/order_courses/order_courses_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'checkout_widget.dart' show CheckoutWidget;
import 'package:flutter/material.dart';

class CheckoutModel extends FlutterFlowModel<CheckoutWidget> {
  ///  Local state fields for this page.

  int? pageViewItem = 0;

  ///  State fields for stateful widgets in this page.

  // Models for OrderCourses dynamic component.
  late FlutterFlowDynamicModels<OrderCoursesModel> orderCoursesModels;

  @override
  void initState(BuildContext context) {
    orderCoursesModels = FlutterFlowDynamicModels(() => OrderCoursesModel());
  }

  @override
  void dispose() {
    orderCoursesModels.dispose();
  }
}
