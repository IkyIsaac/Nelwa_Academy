import '/courses/components/followers2/followers2_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'followers_widget.dart' show FollowersWidget;
import 'package:flutter/material.dart';

class FollowersModel extends FlutterFlowModel<FollowersWidget> {
  ///  Local state fields for this page.

  int? pageViewItem = 0;

  ///  State fields for stateful widgets in this page.

  // Models for Followers2 dynamic component.
  late FlutterFlowDynamicModels<Followers2Model> followers2Models;

  @override
  void initState(BuildContext context) {
    followers2Models = FlutterFlowDynamicModels(() => Followers2Model());
  }

  @override
  void dispose() {
    followers2Models.dispose();
  }
}
