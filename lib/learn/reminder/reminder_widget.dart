import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reminder_model.dart';
export 'reminder_model.dart';

class ReminderWidget extends StatefulWidget {
  const ReminderWidget({
    super.key,
    required this.purchasedCoursesDoc,
  });

  final PurchasedCoursesRecord? purchasedCoursesDoc;

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  late ReminderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReminderModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState()
          .reminders
          .where((e) =>
              e.purchasedCoursesRef == widget.purchasedCoursesDoc?.reference)
          .toList()
          .isNotEmpty) {
        _model.hour = FFAppState()
            .reminders
            .where((e) =>
                e.purchasedCoursesRef == widget.purchasedCoursesDoc?.reference)
            .toList()
            .firstOrNull
            ?.hour;
        _model.selectedDays = FFAppState()
            .reminders
            .where((e) =>
                e.purchasedCoursesRef == widget.purchasedCoursesDoc?.reference)
            .toList()
            .firstOrNull!
            .days
            .toList()
            .cast<String>();
        _model.minut = FFAppState()
            .reminders
            .where((e) =>
                e.purchasedCoursesRef == widget.purchasedCoursesDoc?.reference)
            .toList()
            .firstOrNull
            ?.minut;
        _model.active = FFAppState()
            .reminders
            .where((e) =>
                e.purchasedCoursesRef == widget.purchasedCoursesDoc?.reference)
            .toList()
            .firstOrNull!
            .active;
        safeSetState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 22.0,
                        buttonSize: 44.0,
                        fillColor: FlutterFlowTheme.of(context).transparent,
                        icon: Icon(
                          FFIcons.karrowLeft,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 50.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'ku7gojbl' /* Reminder */,
                          ),
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
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
                                    lineHeight: 1.0,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    if (FFAppState().reminder) {
                      FFAppState().reminder = false;
                      safeSetState(() {});
                    } else {
                      FFAppState().reminder = true;
                      safeSetState(() {});
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              FFLocalizations.of(context).getText(
                                '6pfl9ly7' /* Active */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
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
                                    color: FFAppState().reminder
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondary,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(
                                      valueOrDefault<double>(
                                        FFAppState().reminder ? 1.0 : -1.0,
                                        0.0,
                                      ),
                                      0.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Container(
                                      width: 26.0,
                                      height: 26.0,
                                      decoration: BoxDecoration(
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2.0,
                                            color: Color(0x10000000),
                                            offset: Offset(
                                              FFAppState().reminder
                                                  ? -1.0
                                                  : 1.0,
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
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Text(
                  FFLocalizations.of(context).getText(
                    'a2c4qksu' /* Title */,
                  ),
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleLarge
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleLarge.fontStyle,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 24.0, 15.0, 24.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final hourList =
                                      functions.hoursList().toList();

                                  return Container(
                                    width: 150.0,
                                    height: 135.0,
                                    child: CarouselSlider.builder(
                                      itemCount: hourList.length,
                                      itemBuilder: (context, hourListIndex, _) {
                                        final hourListItem =
                                            hourList[hourListIndex];
                                        return Text(
                                          hourListItem,
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .displaySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .displaySmall
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .fontStyle,
                                              ),
                                        );
                                      },
                                      carouselController:
                                          _model.carouselController1 ??=
                                              CarouselSliderController(),
                                      options: CarouselOptions(
                                        initialPage:
                                            max(0, min(0, hourList.length - 1)),
                                        viewportFraction: 0.4,
                                        disableCenter: true,
                                        enlargeCenterPage: true,
                                        enlargeFactor: 0.5,
                                        enableInfiniteScroll: true,
                                        scrollDirection: Axis.vertical,
                                        autoPlay: false,
                                        onPageChanged: (index, _) async {
                                          _model.carouselCurrentIndex1 = index;
                                          _model.hour =
                                              hourList.elementAtOrNull(
                                                  _model.carouselCurrentIndex1);
                                          safeSetState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              FFLocalizations.of(context).getText(
                                'tpfjr66k' /* : */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .fontStyle,
                                  ),
                            ),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final minutesList =
                                      functions.minutesList().toList();

                                  return Container(
                                    width: 150.0,
                                    height: 135.0,
                                    child: CarouselSlider.builder(
                                      itemCount: minutesList.length,
                                      itemBuilder:
                                          (context, minutesListIndex, _) {
                                        final minutesListItem =
                                            minutesList[minutesListIndex];
                                        return Text(
                                          minutesListItem,
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .displaySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .displaySmall
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .fontStyle,
                                              ),
                                        );
                                      },
                                      carouselController:
                                          _model.carouselController2 ??=
                                              CarouselSliderController(),
                                      options: CarouselOptions(
                                        initialPage: max(
                                            0, min(0, minutesList.length - 1)),
                                        viewportFraction: 0.4,
                                        disableCenter: true,
                                        enlargeCenterPage: true,
                                        enlargeFactor: 0.45,
                                        enableInfiniteScroll: true,
                                        scrollDirection: Axis.vertical,
                                        autoPlay: false,
                                        onPageChanged: (index, _) async {
                                          _model.carouselCurrentIndex2 = index;
                                          _model.minut =
                                              minutesList.elementAtOrNull(
                                                  _model.carouselCurrentIndex2);
                                          safeSetState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ].divide(SizedBox(width: 24.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Text(
                  FFLocalizations.of(context).getText(
                    '9svi7kqw' /* Title */,
                  ),
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleLarge
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleLarge.fontStyle,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: Builder(
                  builder: (context) {
                    final weeks = _model.weekDays.toList();

                    return Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      runAlignment: WrapAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      clipBehavior: Clip.none,
                      children: List.generate(weeks.length, (weeksIndex) {
                        final weeksItem = weeks[weeksIndex];
                        return InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_model.selectedDays.contains(weeksItem)) {
                              _model.removeFromSelectedDays(weeksItem);
                              safeSetState(() {});
                            } else {
                              _model.addToSelectedDays(weeksItem);
                              safeSetState(() {});
                            }
                          },
                          child: Container(
                            height: 44.0,
                            decoration: BoxDecoration(
                              color: _model.selectedDays.contains(weeksItem)
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    weeksItem,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: _model.selectedDays
                                                  .contains(weeksItem)
                                              ? FlutterFlowTheme.of(context)
                                                  .info
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 16.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    if (FFAppState()
                        .reminders
                        .where((e) =>
                            e.purchasedCoursesRef ==
                            widget.purchasedCoursesDoc?.reference)
                        .toList()
                        .isNotEmpty) {
                      FFAppState().removeFromReminders(FFAppState()
                          .reminders
                          .where((e) =>
                              e.purchasedCoursesRef ==
                              widget.purchasedCoursesDoc?.reference)
                          .toList()
                          .firstOrNull!);
                      safeSetState(() {});
                      FFAppState().addToReminders(ReminderStruct(
                        days: _model.selectedDays,
                        active: _model.active,
                        purchasedCoursesRef:
                            widget.purchasedCoursesDoc?.reference,
                        hour: _model.hour,
                        minut: _model.minut,
                      ));
                      safeSetState(() {});
                    }
                    Navigator.pop(context);
                  },
                  text: FFLocalizations.of(context).getText(
                    'nj7p6959' /* Save */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).info,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
