import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'payment_method_widget.dart' show PaymentMethodWidget;
import 'package:flutter/material.dart';

class PaymentMethodModel extends FlutterFlowModel<PaymentMethodWidget> {
  ///  Local state fields for this page.

  DocumentReference? paymentMethods;

  int? courses = 0;

  DocumentReference? selectedCourses;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  CoursesRecord? coursesDoc;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PaymentAccountRecord? paymentAccount;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  InstructorDetailsRecord? instructorDoc;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  int? paymentMethod;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
