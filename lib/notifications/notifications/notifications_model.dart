import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/notifications/notification_card/notification_card_widget.dart';
import '/index.dart';
import 'notifications_widget.dart' show NotificationsWidget;
import 'package:flutter/material.dart';

class NotificationsModel extends FlutterFlowModel<NotificationsWidget> {
  ///  Local state fields for this page.

  DocumentReference? notificationRef;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in Row widget.
  List<NotificationRecord>? newsList;
  // Models for NotificationCard dynamic component.
  late FlutterFlowDynamicModels<NotificationCardModel> notificationCardModels;

  @override
  void initState(BuildContext context) {
    notificationCardModels =
        FlutterFlowDynamicModels(() => NotificationCardModel());
  }

  @override
  void dispose() {
    notificationCardModels.dispose();
  }
}
