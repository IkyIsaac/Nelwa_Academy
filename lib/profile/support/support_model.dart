import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/profile/components/support_message/support_message_widget.dart';
import '/profile/components/user_message/user_message_widget.dart';
import 'support_widget.dart' show SupportWidget;
import 'package:flutter/material.dart';

class SupportModel extends FlutterFlowModel<SupportWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for UserMessage dynamic component.
  late FlutterFlowDynamicModels<UserMessageModel> userMessageModels;
  // Models for SupportMessage dynamic component.
  late FlutterFlowDynamicModels<SupportMessageModel> supportMessageModels;
  bool isDataUploading_uploadDataX2f = false;
  FFUploadedFile uploadedLocalFile_uploadDataX2f =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataX2f = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Create Document] action in IconButton widget.
  SupportRecord? supportDoc;

  @override
  void initState(BuildContext context) {
    userMessageModels = FlutterFlowDynamicModels(() => UserMessageModel());
    supportMessageModels =
        FlutterFlowDynamicModels(() => SupportMessageModel());
  }

  @override
  void dispose() {
    userMessageModels.dispose();
    supportMessageModels.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
