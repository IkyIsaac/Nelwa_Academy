import '/flutter_flow/flutter_flow_util.dart';
import 'compete_profile_widget.dart' show CompeteProfileWidget;
import 'package:flutter/material.dart';

class CompeteProfileModel extends FlutterFlowModel<CompeteProfileWidget> {
  ///  Local state fields for this page.

  bool termPolicy = false;

  bool checkBox = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadData7e8 = false;
  FFUploadedFile uploadedLocalFile_uploadData7e8 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadData7e8 = '';

  // State field(s) for Name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  String? _nameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'xyx6tsfd' /* Please add  your name */,
      );
    }

    return null;
  }

  DateTime? datePicked;

  @override
  void initState(BuildContext context) {
    nameTextControllerValidator = _nameTextControllerValidator;
  }

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();
  }
}
