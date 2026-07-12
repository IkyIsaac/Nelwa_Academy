import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

Future changeLanguage(BuildContext context) async {
  setAppLanguage(context, 'en');
  context.safePop();
}
