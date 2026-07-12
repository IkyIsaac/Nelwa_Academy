import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'icon_text_switch_model.dart';
export 'icon_text_switch_model.dart';

class IconTextSwitchWidget extends StatefulWidget {
  const IconTextSwitchWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.textColor,
    required this.showDivider,
    bool? switchBoolean,
  }) : this.switchBoolean = switchBoolean ?? false;

  final String? text;
  final Widget? icon;
  final Color? textColor;
  final bool? showDivider;
  final bool switchBoolean;

  @override
  State<IconTextSwitchWidget> createState() => _IconTextSwitchWidgetState();
}

class _IconTextSwitchWidgetState extends State<IconTextSwitchWidget> {
  late IconTextSwitchModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IconTextSwitchModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 13.0, 16.0, 13.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              widget.icon!,
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    valueOrDefault<String>(
                      widget.text,
                      'null',
                    ),
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                  ),
                ),
              ),
              Container(
                width: 50.0,
                height: 30.0,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: valueOrDefault<Color>(
                          widget.switchBoolean
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).secondary,
                          FlutterFlowTheme.of(context).secondary,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(
                          valueOrDefault<double>(
                            widget.switchBoolean ? 1.0 : -1.0,
                            0.0,
                          ),
                          0.0),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Container(
                          width: 26.0,
                          height: 26.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).info,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2.0,
                                color: Color(0x10000000),
                                offset: Offset(
                                  widget.switchBoolean ? -1.0 : 1.0,
                                  0.0,
                                ),
                              )
                            ],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.showDivider ?? true)
          Divider(
            height: 1.0,
            thickness: 1.0,
            indent: 56.0,
            color: FlutterFlowTheme.of(context).dividerColor,
          ),
      ],
    );
  }
}
