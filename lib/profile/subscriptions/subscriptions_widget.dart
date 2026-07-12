import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/empty_state/empty_subscriptions/empty_subscriptions_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/profile/components/subscriptions_card/subscriptions_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'subscriptions_model.dart';
export 'subscriptions_model.dart';

class SubscriptionsWidget extends StatefulWidget {
  const SubscriptionsWidget({super.key});

  static String routeName = 'Subscriptions';
  static String routePath = '/subscriptions';

  @override
  State<SubscriptionsWidget> createState() => _SubscriptionsWidgetState();
}

class _SubscriptionsWidgetState extends State<SubscriptionsWidget> {
  late SubscriptionsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Align(
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
          title: Text(
            FFLocalizations.of(context).getText(
              'p9bpaq4o' /* Subscriptions */,
            ),
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: AuthUserStreamWidget(
          builder: (context) => Builder(
            builder: (context) {
              final subscriptionsList =
                  (currentUserDocument?.subscriptions.toList() ?? []).toList();
              if (subscriptionsList.isEmpty) {
                return EmptySubscriptionsWidget();
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
                itemCount: subscriptionsList.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.0),
                itemBuilder: (context, subscriptionsListIndex) {
                  final subscriptionsListItem =
                      subscriptionsList[subscriptionsListIndex];
                  return StreamBuilder<UsersRecord>(
                    stream: UsersRecord.getDocument(subscriptionsListItem),
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

                      final subscriptionsCardUsersRecord = snapshot.data!;

                      return wrapWithModel(
                        model: _model.subscriptionsCardModels.getModel(
                          subscriptionsListIndex.toString(),
                          subscriptionsListIndex,
                        ),
                        updateCallback: () => safeSetState(() {}),
                        child: SubscriptionsCardWidget(
                          key: Key(
                            'Keyi9n_${subscriptionsListIndex.toString()}',
                          ),
                          usersDoc: subscriptionsCardUsersRecord,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
