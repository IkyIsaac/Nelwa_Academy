import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'icon_text_right_model.dart';
export 'icon_text_right_model.dart';

class IconTextRightWidget extends StatefulWidget {
  const IconTextRightWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.textColor,
    required this.showDivider,
  });

  final String? text;
  final Widget? icon;
  final Color? textColor;
  final bool? showDivider;

  @override
  State<IconTextRightWidget> createState() => _IconTextRightWidgetState();
}

class _IconTextRightWidgetState extends State<IconTextRightWidget> {
  late IconTextRightModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IconTextRightModel());

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
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              widget.icon!,
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                child: Text(
                  valueOrDefault<String>(
                    widget.text,
                    'null',
                  ),
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        color: widget.textColor,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(1.0, 0.0),
                  child: Icon(
                    FFIcons.kchevronRight,
                    color: FlutterFlowTheme.of(context).iconColor,
                    size: 20.0,
                  ),
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
