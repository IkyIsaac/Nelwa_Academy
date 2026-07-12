import '/flutter_flow/flutter_flow_util.dart';
import 'filter_widget.dart' show FilterWidget;
import 'package:flutter/material.dart';

class FilterModel extends FlutterFlowModel<FilterWidget> {
  ///  Local state fields for this component.

  double? rating;

  String? skillLevel;

  String? dateAdded;

  int? durationFrom = 0;

  int? durationTo = 6000;

  double? start;

  double? end;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
