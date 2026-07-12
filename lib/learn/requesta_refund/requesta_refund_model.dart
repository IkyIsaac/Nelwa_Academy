import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'requesta_refund_widget.dart' show RequestaRefundWidget;
import 'package:flutter/material.dart';

class RequestaRefundModel extends FlutterFlowModel<RequestaRefundWidget> {
  ///  Local state fields for this page.

  List<String> reasonForFefund = [
    'I purchased this by mistake',
    'The content didn’t meet my expectations',
    'Technical issues with the course',
    'I want to cancel the purchase',
    'Other'
  ];
  void addToReasonForFefund(String item) => reasonForFefund.add(item);
  void removeFromReasonForFefund(String item) => reasonForFefund.remove(item);
  void removeAtIndexFromReasonForFefund(int index) =>
      reasonForFefund.removeAt(index);
  void insertAtIndexInReasonForFefund(int index, String item) =>
      reasonForFefund.insert(index, item);
  void updateReasonForFefundAtIndex(int index, Function(String) updateFn) =>
      reasonForFefund[index] = updateFn(reasonForFefund[index]);

  String? selectedReason = 'I purchased this by mistake';

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataX5w = false;
  FFUploadedFile uploadedLocalFile_uploadDataX5w =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataX5w = '';

  bool isDataUploading_uploadDataD1d = false;
  FFUploadedFile uploadedLocalFile_uploadDataD1d =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataD1d = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PaymentAccountRecord? paymentAccount;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
