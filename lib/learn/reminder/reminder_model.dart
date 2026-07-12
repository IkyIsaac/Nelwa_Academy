import '/flutter_flow/flutter_flow_util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'reminder_widget.dart' show ReminderWidget;
import 'package:flutter/material.dart';

class ReminderModel extends FlutterFlowModel<ReminderWidget> {
  ///  Local state fields for this component.

  String? hour;

  List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  void addToWeekDays(String item) => weekDays.add(item);
  void removeFromWeekDays(String item) => weekDays.remove(item);
  void removeAtIndexFromWeekDays(int index) => weekDays.removeAt(index);
  void insertAtIndexInWeekDays(int index, String item) =>
      weekDays.insert(index, item);
  void updateWeekDaysAtIndex(int index, Function(String) updateFn) =>
      weekDays[index] = updateFn(weekDays[index]);

  String? minut;

  List<String> selectedDays = [];
  void addToSelectedDays(String item) => selectedDays.add(item);
  void removeFromSelectedDays(String item) => selectedDays.remove(item);
  void removeAtIndexFromSelectedDays(int index) => selectedDays.removeAt(index);
  void insertAtIndexInSelectedDays(int index, String item) =>
      selectedDays.insert(index, item);
  void updateSelectedDaysAtIndex(int index, Function(String) updateFn) =>
      selectedDays[index] = updateFn(selectedDays[index]);

  int? hourIndex;

  int? minutIndex;

  bool active = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController1;
  int carouselCurrentIndex1 = 0;

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController2;
  int carouselCurrentIndex2 = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
