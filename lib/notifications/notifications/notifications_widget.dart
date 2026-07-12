import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/empty_state/empty_notifications/empty_notifications_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/loading/loading_notifications/loading_notifications_widget.dart';
import '/notifications/notification_card/notification_card_widget.dart';
import '/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notifications_model.dart';
export 'notifications_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  static String routeName = 'Notifications';
  static String routePath = '/notifications';

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget>
    with TickerProviderStateMixin {
  late NotificationsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsModel());

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(0.8, 0.8),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (!(FFAppState().selectedNotifications.isNotEmpty))
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderColor: FlutterFlowTheme.of(context).transparent,
                          borderRadius: 22.0,
                          borderWidth: 1.0,
                          buttonSize: 44.0,
                          icon: Icon(
                            FFIcons.karrowLeft,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context.pop();
                          },
                        ),
                      ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (FFAppState().selectedNotifications.isNotEmpty) {
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (FFAppState().allNotifications) {
                                    FFAppState().allNotifications = false;
                                    FFAppState().selectedNotifications = [];
                                    safeSetState(() {});
                                  } else {
                                    _model.newsList =
                                        await queryNotificationRecordOnce(
                                      parent: currentUserReference,
                                    );
                                    FFAppState().allNotifications = true;
                                    FFAppState().selectedNotifications = _model
                                        .newsList!
                                        .map((e) => e.reference)
                                        .toList()
                                        .cast<DocumentReference>();
                                    safeSetState(() {});
                                  }

                                  safeSetState(() {});
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 24.0,
                                      height: 24.0,
                                      decoration: BoxDecoration(
                                        color: FFAppState().allNotifications
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : FlutterFlowTheme.of(context)
                                                .transparent,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: FFAppState().allNotifications
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .iconColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Visibility(
                                        visible: FFAppState().allNotifications,
                                        child: Icon(
                                          FFIcons.kcheck,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 18.0,
                                        ),
                                      ),
                                    ).animateOnActionTrigger(
                                      animationsMap[
                                          'containerOnActionTriggerAnimation']!,
                                    ),
                                    Text(
                                      FFAppState().allNotifications
                                          ? 'Deselect All'
                                          : 'Select All',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            );
                          } else {
                            return Text(
                              FFLocalizations.of(context).getText(
                                'oo1t3t8t' /* Notifications */,
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                            );
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Builder(
                        builder: (context) {
                          if (FFAppState().selectedNotifications.isNotEmpty) {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FlutterFlowIconButton(
                                  borderColor:
                                      FlutterFlowTheme.of(context).transparent,
                                  borderRadius: 22.0,
                                  borderWidth: 1.0,
                                  buttonSize: 44.0,
                                  icon: Icon(
                                    FFIcons.ktrash03,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    while (FFAppState()
                                            .selectedNotifications
                                            .length >
                                        0) {
                                      _model.notificationRef = FFAppState()
                                          .selectedNotifications
                                          .firstOrNull;
                                      safeSetState(() {});
                                      FFAppState()
                                          .removeFromSelectedNotifications(
                                              _model.notificationRef!);
                                      _model.updatePage(() {});
                                      await _model.notificationRef!.delete();
                                      _model.notificationRef = null;
                                      safeSetState(() {});
                                    }
                                  },
                                ),
                                FlutterFlowIconButton(
                                  borderColor:
                                      FlutterFlowTheme.of(context).transparent,
                                  borderRadius: 22.0,
                                  borderWidth: 1.0,
                                  buttonSize: 44.0,
                                  icon: Icon(
                                    FFIcons.kmail04,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    while (FFAppState()
                                            .selectedNotifications
                                            .length >
                                        0) {
                                      _model.notificationRef = FFAppState()
                                          .selectedNotifications
                                          .firstOrNull;
                                      safeSetState(() {});
                                      FFAppState()
                                          .removeFromSelectedNotifications(
                                              _model.notificationRef!);
                                      _model.updatePage(() {});

                                      await _model.notificationRef!
                                          .update(createNotificationRecordData(
                                        seen: true,
                                      ));
                                      _model.notificationRef = null;
                                      safeSetState(() {});
                                    }
                                  },
                                ),
                              ],
                            );
                          } else {
                            return FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).transparent,
                              borderRadius: 22.0,
                              borderWidth: 1.0,
                              buttonSize: 44.0,
                              icon: Icon(
                                FFIcons.ksettings,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.pushNamed(
                                    NotificationsSettingsWidget.routeName);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<NotificationRecord>>(
                stream: queryNotificationRecord(
                  parent: currentUserReference,
                  queryBuilder: (notificationRecord) => notificationRecord
                      .orderBy('time_stamp', descending: true),
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return LoadingNotificationsWidget();
                  }
                  List<NotificationRecord> listViewNotificationRecordList =
                      snapshot.data!;
                  if (listViewNotificationRecordList.isEmpty) {
                    return EmptyNotificationsWidget();
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      16.0,
                      0,
                      24.0,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewNotificationRecordList.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.0),
                    itemBuilder: (context, listViewIndex) {
                      final listViewNotificationRecord =
                          listViewNotificationRecordList[listViewIndex];
                      return wrapWithModel(
                        model: _model.notificationCardModels.getModel(
                          listViewIndex.toString(),
                          listViewIndex,
                        ),
                        updateCallback: () => safeSetState(() {}),
                        child: NotificationCardWidget(
                          key: Key(
                            'Keyqdl_${listViewIndex.toString()}',
                          ),
                          notificationDoc: listViewNotificationRecord,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
