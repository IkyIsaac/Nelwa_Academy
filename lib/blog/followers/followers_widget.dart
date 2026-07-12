import '/backend/backend.dart';
import '/courses/components/followers2/followers2_widget.dart';
import '/empty_state/empty_followers/empty_followers_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'followers_model.dart';
export 'followers_model.dart';

class FollowersWidget extends StatefulWidget {
  const FollowersWidget({
    super.key,
    required this.instructorDoc,
  });

  final InstructorDetailsRecord? instructorDoc;

  static String routeName = 'Followers';
  static String routePath = '/followers';

  @override
  State<FollowersWidget> createState() => _FollowersWidgetState();
}

class _FollowersWidgetState extends State<FollowersWidget> {
  late FollowersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FollowersModel());

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
              'm8oic1k6' /* Followers */,
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
        body: Builder(
          builder: (context) {
            final followersList =
                widget.instructorDoc?.followers.toList() ?? [];
            if (followersList.isEmpty) {
              return EmptyFollowersWidget();
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
              itemCount: followersList.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.0),
              itemBuilder: (context, followersListIndex) {
                final followersListItem = followersList[followersListIndex];
                return StreamBuilder<UsersRecord>(
                  stream: UsersRecord.getDocument(followersListItem),
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

                    final followers2UsersRecord = snapshot.data!;

                    return wrapWithModel(
                      model: _model.followers2Models.getModel(
                        followersListIndex.toString(),
                        followersListIndex,
                      ),
                      updateCallback: () => safeSetState(() {}),
                      child: Followers2Widget(
                        key: Key(
                          'Keyzsl_${followersListIndex.toString()}',
                        ),
                        userDoc: followers2UsersRecord,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
