import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'creat_new_course_widget.dart' show CreatNewCourseWidget;
import 'package:flutter/material.dart';

class CreatNewCourseModel extends FlutterFlowModel<CreatNewCourseWidget> {
  ///  Local state fields for this page.

  List<String> tags = [];
  void addToTags(String item) => tags.add(item);
  void removeFromTags(String item) => tags.remove(item);
  void removeAtIndexFromTags(int index) => tags.removeAt(index);
  void insertAtIndexInTags(int index, String item) => tags.insert(index, item);
  void updateTagsAtIndex(int index, Function(String) updateFn) =>
      tags[index] = updateFn(tags[index]);

  bool? emptyImage = false;

  bool emptyVideo = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_image22 = false;
  FFUploadedFile uploadedLocalFile_image22 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_image22 = '';

  bool isDataUploading_image11 = false;
  FFUploadedFile uploadedLocalFile_image11 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_image11 = '';

  // State field(s) for CourseName widget.
  FocusNode? courseNameFocusNode;
  TextEditingController? courseNameTextController;
  String? Function(BuildContext, String?)? courseNameTextControllerValidator;
  String? _courseNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '7spwlmy0' /* Course name is required. */,
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
        'kossc090' /* Course description is required... */,
      );
    }

    return null;
  }

  bool isDataUploading_uploadDataXku = false;
  FFUploadedFile uploadedLocalFile_uploadDataXku =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataXku = '';

  bool isDataUploading_uploadDataN80 = false;
  FFUploadedFile uploadedLocalFile_uploadDataN80 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataN80 = '';

  // State field(s) for TotalLessons widget.
  FocusNode? totalLessonsFocusNode;
  TextEditingController? totalLessonsTextController;
  String? Function(BuildContext, String?)? totalLessonsTextControllerValidator;
  // State field(s) for totalDuration widget.
  FocusNode? totalDurationFocusNode;
  TextEditingController? totalDurationTextController;
  String? Function(BuildContext, String?)? totalDurationTextControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for Price widget.
  FocusNode? priceFocusNode1;
  TextEditingController? priceTextController1;
  String? Function(BuildContext, String?)? priceTextController1Validator;
  String? _priceTextController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '6kah78lf' /* Price is required. */,
      );
    }

    return null;
  }

  // State field(s) for Price widget.
  FocusNode? priceFocusNode2;
  TextEditingController? priceTextController2;
  String? Function(BuildContext, String?)? priceTextController2Validator;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  CoursesRecord? newCourse;

  @override
  void initState(BuildContext context) {
    courseNameTextControllerValidator = _courseNameTextControllerValidator;
    descriptionTextControllerValidator = _descriptionTextControllerValidator;
    priceTextController1Validator = _priceTextController1Validator;
  }

  @override
  void dispose() {
    courseNameFocusNode?.dispose();
    courseNameTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();

    totalLessonsFocusNode?.dispose();
    totalLessonsTextController?.dispose();

    totalDurationFocusNode?.dispose();
    totalDurationTextController?.dispose();

    priceFocusNode1?.dispose();
    priceTextController1?.dispose();

    priceFocusNode2?.dispose();
    priceTextController2?.dispose();
  }
}
