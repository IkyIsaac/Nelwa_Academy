import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'bell_model.dart';
export 'bell_model.dart';

class BellWidget extends StatefulWidget {
  const BellWidget({super.key});

  @override
  State<BellWidget> createState() => _BellWidgetState();
}

class _BellWidgetState extends State<BellWidget> {
  late BellModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BellModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.0,
      height: 44.0,
      child: Stack(
        alignment: AlignmentDirectional(0.0, 0.0),
        children: [
          FlutterFlowIconButton(
            borderRadius: 22.0,
            buttonSize: 44.0,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            icon: Icon(
              FFIcons.kbell,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.pushNamed(NotificationsWidget.routeName);
            },
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 0.0, 7.0),
            child: FutureBuilder<List<NotificationRecord>>(
              future: queryNotificationRecordOnce(
                parent: currentUserReference,
                queryBuilder: (notificationRecord) => notificationRecord.where(
                  'seen',
                  isEqualTo: false,
                ),
                singleRecord: true,
              ),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 10.0,
                      height: 10.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).transparent,
                        ),
                      ),
                    ),
                  );
                }
                List<NotificationRecord> containerNotificationRecordList =
                    snapshot.data!;
                // Return an empty Container when the item does not exist.
                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                final containerNotificationRecord =
                    containerNotificationRecordList.isNotEmpty
                        ? containerNotificationRecordList.first
                        : null;

                return Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    shape: BoxShape.circle,
                  ),
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).error,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
