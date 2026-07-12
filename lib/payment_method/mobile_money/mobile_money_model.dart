import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'mobile_money_widget.dart' show MobileMoneyWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MobileMoneyModel extends FlutterFlowModel<MobileMoneyWidget> {
  ///  Local state fields for this page.

  bool unknownCard = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for CardNumber widget.
  FocusNode? cardNumberFocusNode;
  TextEditingController? cardNumberTextController;
  late MaskTextInputFormatter cardNumberMask;
  String? Function(BuildContext, String?)? cardNumberTextControllerValidator;
  String? _cardNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 10) {
      return 'Requires at least 10 characters.';
    }
    if (val.length > 10) {
      return 'Maximum 10 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for M-PESA widget.
  FormFieldController<List<String>>? mPesaValueController;
  String? get mPesaValue => mPesaValueController?.value?.firstOrNull;
  set mPesaValue(String? val) =>
      mPesaValueController?.value = val != null ? [val] : [];
  // State field(s) for CardHolder widget.
  FocusNode? cardHolderFocusNode;
  TextEditingController? cardHolderTextController;
  String? Function(BuildContext, String?)? cardHolderTextControllerValidator;
  String? _cardHolderTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  PaymentMethodRecord? creditCardDoc;

  @override
  void initState(BuildContext context) {
    cardNumberTextControllerValidator = _cardNumberTextControllerValidator;
    cardHolderTextControllerValidator = _cardHolderTextControllerValidator;
  }

  @override
  void dispose() {
    cardNumberFocusNode?.dispose();
    cardNumberTextController?.dispose();

    cardHolderFocusNode?.dispose();
    cardHolderTextController?.dispose();
  }
}
