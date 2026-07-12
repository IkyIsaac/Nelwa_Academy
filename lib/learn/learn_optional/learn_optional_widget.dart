import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/optionals_buttons/optionals_buttons_widget.dart';
import '/learn/delete_learn_courses/delete_learn_courses_widget.dart';
import '/learn/reminder/reminder_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'learn_optional_model.dart';
export 'learn_optional_model.dart';

class LearnOptionalWidget extends StatefulWidget {
  const LearnOptionalWidget({
    super.key,
    required this.purchasedCoursesDoc,
  });

  final PurchasedCoursesRecord? purchasedCoursesDoc;

  @override
  State<LearnOptionalWidget> createState() => _LearnOptionalWidgetState();
}

class _LearnOptionalWidgetState extends State<LearnOptionalWidget> {
  late LearnOptionalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LearnOptionalModel());

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
      width: 245.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).optional,
        boxShadow: [
          BoxShadow(
            blurRadius: 13.0,
            color: Color(0x25000000),
            offset: Offset(
              0.0,
              4.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.pop(context);
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.viewInsetsOf(context),
                    child: ReminderWidget(
                      purchasedCoursesDoc: widget.purchasedCoursesDoc!,
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));
            },
            child: wrapWithModel(
              model: _model.optionalsButtonsModel1,
              updateCallback: () => safeSetState(() {}),
              child: OptionalsButtonsWidget(
                icon: Icon(
                  FFIcons.kclockHour2,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                text: 'Reminder',
                textColor: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).dividerColor,
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.pop(context);

              context.pushNamed(
                RequestaRefundWidget.routeName,
                queryParameters: {
                  'purchasedCoursesDoc': serializeParam(
                    widget.purchasedCoursesDoc,
                    ParamType.Document,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  'purchasedCoursesDoc': widget.purchasedCoursesDoc,
                },
              );
            },
            child: wrapWithModel(
              model: _model.optionalsButtonsModel2,
              updateCallback: () => safeSetState(() {}),
              child: OptionalsButtonsWidget(
                icon: Icon(
                  FFIcons.kreceiptRefund,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                text: 'Request a refund',
                textColor: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).dividerColor,
          ),
          Builder(
            builder: (context) => InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                Navigator.pop(context);
                await showDialog(
                  barrierColor: FlutterFlowTheme.of(context).background,
                  context: context,
                  builder: (dialogContext) {
                    return Dialog(
                      elevation: 0,
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      alignment: AlignmentDirectional(0.0, 0.0)
                          .resolve(Directionality.of(context)),
                      child: DeleteLearnCoursesWidget(
                        purchasedCoursesRef:
                            widget.purchasedCoursesDoc!.reference,
                      ),
                    );
                  },
                );
              },
              child: wrapWithModel(
                model: _model.optionalsButtonsModel3,
                updateCallback: () => safeSetState(() {}),
                child: OptionalsButtonsWidget(
                  icon: Icon(
                    FFIcons.ktrash03,
                    color: FlutterFlowTheme.of(context).error,
                    size: 24.0,
                  ),
                  text: 'Delete course',
                  textColor: FlutterFlowTheme.of(context).error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
