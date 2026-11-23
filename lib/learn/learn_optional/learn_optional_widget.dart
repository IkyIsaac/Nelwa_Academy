import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/components/optionals_buttons/optionals_buttons_widget.dart';
import '/learn/reminder/reminder_widget.dart';
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
                text: FFLocalizations.of(context)
                    .getText('nwmnu001' /* Reminder */),
                textColor: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).dividerColor,
          ),
          // Refund requests are switched off by the academy (2026-11-17);
          // the Request a refund item used to sit here.
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              // Learners can't delete a purchase (security rules); they hide
              // it from Learn instead and can bring it back any time.
              final archive = !widget.purchasedCoursesDoc!.archived;
              final messenger = ScaffoldMessenger.of(context);
              final message = FFLocalizations.of(context)
                  .getText(archive ? 'nwarc002' : 'nwarc003');
              Navigator.pop(context);
              await widget.purchasedCoursesDoc!.reference
                  .update({'archived': archive});
              messenger.showSnackBar(SnackBar(content: Text(message)));
            },
            child: wrapWithModel(
              model: _model.optionalsButtonsModel3,
              updateCallback: () => safeSetState(() {}),
              child: OptionalsButtonsWidget(
                icon: Icon(
                  widget.purchasedCoursesDoc!.archived
                      ? Icons.unarchive_outlined
                      : Icons.archive_outlined,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                text: FFLocalizations.of(context)
                    .getText(widget.purchasedCoursesDoc!.archived
                        ? 'nwarc001' /* Unarchive course */
                        : 'nwmnu003' /* Archive course */),
                textColor: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
