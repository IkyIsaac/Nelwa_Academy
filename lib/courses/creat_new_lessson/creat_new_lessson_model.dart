import '/backend/backend.dart';
import '/buttons/text_switch/text_switch_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'creat_new_lessson_widget.dart' show CreatNewLesssonWidget;
import 'package:flutter/material.dart';

class CreatNewLesssonModel extends FlutterFlowModel<CreatNewLesssonWidget> {
  ///  Local state fields for this page.

  bool freeViewing = false;

  bool emptyVideo = false;

  bool emptyphoto = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadDataX23 = false;
  FFUploadedFile uploadedLocalFile_uploadDataX23 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataX23 = '';

  bool isDataUploading_video1 = false;
  FFUploadedFile uploadedLocalFile_video1 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_video1 = '';

  // State field(s) for LessonNo widget.
  FocusNode? lessonNoFocusNode;
  TextEditingController? lessonNoTextController;
  String? Function(BuildContext, String?)? lessonNoTextControllerValidator;
  String? _lessonNoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'a49xmbrc' /* Course name is required. */,
      );
    }

    return null;
  }

  // State field(s) for LessonName widget.
  FocusNode? lessonNameFocusNode1;
  TextEditingController? lessonNameTextController1;
  String? Function(BuildContext, String?)? lessonNameTextController1Validator;
  String? _lessonNameTextController1Validator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'd2afv4km' /* Course description is required... */,
      );
    }

    return null;
  }

  // State field(s) for LessonName widget.
  FocusNode? lessonNameFocusNode2;
  TextEditingController? lessonNameTextController2;
  String? Function(BuildContext, String?)? lessonNameTextController2Validator;
  String? _lessonNameTextController2Validator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '7kxjjsv0' /* Durartion  is required */,
      );
    }

    return null;
  }

  // State field(s) for Description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;
  String? _descriptionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'whyp0b77' /* Description is required */,
      );
    }

    return null;
  }

  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel;
  bool isDataUploading_image2 = false;
  FFUploadedFile uploadedLocalFile_image2 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_image2 = '';

  bool isDataUploading_image1 = false;
  FFUploadedFile uploadedLocalFile_image1 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_image1 = '';

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  InstructorDetailsRecord? instructorRef;

  @override
  void initState(BuildContext context) {
    lessonNoTextControllerValidator = _lessonNoTextControllerValidator;
    lessonNameTextController1Validator = _lessonNameTextController1Validator;
    lessonNameTextController2Validator = _lessonNameTextController2Validator;
    descriptionTextControllerValidator = _descriptionTextControllerValidator;
    textSwitchModel = createModel(context, () => TextSwitchModel());
  }

  @override
  void dispose() {
    lessonNoFocusNode?.dispose();
    lessonNoTextController?.dispose();

    lessonNameFocusNode1?.dispose();
    lessonNameTextController1?.dispose();

    lessonNameFocusNode2?.dispose();
    lessonNameTextController2?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();

    textSwitchModel.dispose();
  }
}
