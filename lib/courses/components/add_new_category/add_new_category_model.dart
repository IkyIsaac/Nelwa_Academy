import '/flutter_flow/flutter_flow_util.dart';
import 'add_new_category_widget.dart' show AddNewCategoryWidget;
import 'package:flutter/material.dart';

class AddNewCategoryModel extends FlutterFlowModel<AddNewCategoryWidget> {
  ///  Local state fields for this component.

  bool error = false;

  bool emptyImage = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for CategoryName widget.
  FocusNode? categoryNameFocusNode;
  TextEditingController? categoryNameTextController;
  String? Function(BuildContext, String?)? categoryNameTextControllerValidator;
  bool isDataUploading_categoryImage22 = false;
  FFUploadedFile uploadedLocalFile_categoryImage22 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_categoryImage22 = '';

  bool isDataUploading_categoryImage = false;
  FFUploadedFile uploadedLocalFile_categoryImage =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_categoryImage = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    categoryNameFocusNode?.dispose();
    categoryNameTextController?.dispose();
  }
}
