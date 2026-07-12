import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      if (prefs.containsKey('ff_selectedLang')) {
        try {
          final serializedData = prefs.getString('ff_selectedLang') ?? '{}';
          _selectedLang =
              LanguageStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _specialty = prefs.getString('ff_specialty') ?? _specialty;
    });
    _safeInit(() {
      _rememberMe = prefs.getBool('ff_rememberMe') ?? _rememberMe;
    });
    _safeInit(() {
      _biometricID = prefs.getBool('ff_biometricID') ?? _biometricID;
    });
    _safeInit(() {
      _faceID = prefs.getBool('ff_faceID') ?? _faceID;
    });
    _safeInit(() {
      _smsAuthenticator =
          prefs.getBool('ff_smsAuthenticator') ?? _smsAuthenticator;
    });
    _safeInit(() {
      _deviceManagement =
          prefs.getBool('ff_deviceManagement') ?? _deviceManagement;
    });
    _safeInit(() {
      _courseActivityAlerts =
          prefs.getBool('ff_courseActivityAlerts') ?? _courseActivityAlerts;
    });
    _safeInit(() {
      _feedbackReviews =
          prefs.getBool('ff_feedbackReviews') ?? _feedbackReviews;
    });
    _safeInit(() {
      _systemAnnouncements =
          prefs.getBool('ff_systemAnnouncements') ?? _systemAnnouncements;
    });
    _safeInit(() {
      _earningsUpdates =
          prefs.getBool('ff_earningsUpdates') ?? _earningsUpdates;
    });
    _safeInit(() {
      _certificateRequests =
          prefs.getBool('ff_certificateRequests') ?? _certificateRequests;
    });
    _safeInit(() {
      _darkMode = prefs.getBool('ff_darkMode') ?? _darkMode;
    });
    _safeInit(() {
      _allNotifications =
          prefs.getBool('ff_allNotifications') ?? _allNotifications;
    });
    _safeInit(() {
      _reminder = prefs.getBool('ff_reminder') ?? _reminder;
    });
    _safeInit(() {
      _reminderHours = prefs.getString('ff_reminderHours') ?? _reminderHours;
    });
    _safeInit(() {
      _reminderMinut = prefs.getString('ff_reminderMinut') ?? _reminderMinut;
    });
    _safeInit(() {
      _wishList = prefs
              .getStringList('ff_wishList')
              ?.map((path) => path.ref)
              .toList() ??
          _wishList;
    });
    _safeInit(() {
      _walkthroughsCourses =
          prefs.getBool('ff_walkthroughsCourses') ?? _walkthroughsCourses;
    });
    _safeInit(() {
      _walkthroughsLesson =
          prefs.getBool('ff_walkthroughsLesson') ?? _walkthroughsLesson;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_order')) {
        try {
          final serializedData = prefs.getString('ff_order') ?? '{}';
          _order = OrderStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _reminders = prefs
              .getStringList('ff_reminders')
              ?.map((x) {
                try {
                  return ReminderStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _reminders;
    });
    _safeInit(() {
      _hasOption = prefs.getBool('ff_hasOption') ?? _hasOption;
    });
    _safeInit(() {
      _isCompleteOnboarding =
          prefs.getBool('ff_isCompleteOnboarding') ?? _isCompleteOnboarding;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<String> _interests = ['ICE-CREAM', 'BAKERY', 'CATERING'];
  List<String> get interests => _interests;
  set interests(List<String> value) {
    _interests = value;
  }

  void addToInterests(String value) {
    interests.add(value);
  }

  void removeFromInterests(String value) {
    interests.remove(value);
  }

  void removeAtIndexFromInterests(int index) {
    interests.removeAt(index);
  }

  void updateInterestsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    interests[index] = updateFn(_interests[index]);
  }

  void insertAtIndexInInterests(int index, String value) {
    interests.insert(index, value);
  }

  List<String> _experienceLevel = [
    'Newcomer',
    'Beginner',
    'Student',
    'Enthusiast',
    'Intermediate',
    'Professional'
  ];
  List<String> get experienceLevel => _experienceLevel;
  set experienceLevel(List<String> value) {
    _experienceLevel = value;
  }

  void addToExperienceLevel(String value) {
    experienceLevel.add(value);
  }

  void removeFromExperienceLevel(String value) {
    experienceLevel.remove(value);
  }

  void removeAtIndexFromExperienceLevel(int index) {
    experienceLevel.removeAt(index);
  }

  void updateExperienceLevelAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    experienceLevel[index] = updateFn(_experienceLevel[index]);
  }

  void insertAtIndexInExperienceLevel(int index, String value) {
    experienceLevel.insert(index, value);
  }

  List<String> _useFor = [
    'I want to start my business ',
    'I want to improve my skills',
    'I want to improve my team\'s skills',
    'I\'m just looking around'
  ];
  List<String> get useFor => _useFor;
  set useFor(List<String> value) {
    _useFor = value;
  }

  void addToUseFor(String value) {
    useFor.add(value);
  }

  void removeFromUseFor(String value) {
    useFor.remove(value);
  }

  void removeAtIndexFromUseFor(int index) {
    useFor.removeAt(index);
  }

  void updateUseForAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    useFor[index] = updateFn(_useFor[index]);
  }

  void insertAtIndexInUseFor(int index, String value) {
    useFor.insert(index, value);
  }

  List<LanguageStruct> _langList = [
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"English\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fgreat_britain.png?alt=media&token=4065decd-2928-4f87-ba81-6dabdd17dde1\",\"lang_code\":\"en\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Français\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Ffrance.png?alt=media&token=bd059836-7859-43a7-9600-0a0b7855ae80\",\"lang_code\":\"fr\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Italiano\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fitaly.png?alt=media&token=684ff3e6-b796-40ba-9e42-0fd5f9cc35b6\",\"lang_code\":\"it\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Swahili\",\"flag\":\"https://seekflag.com/wp-content/uploads/2021/12/Tanzania-01-1.svg\",\"lang_code\":\"sw\"}'))
  ];
  List<LanguageStruct> get langList => _langList;
  set langList(List<LanguageStruct> value) {
    _langList = value;
  }

  void addToLangList(LanguageStruct value) {
    langList.add(value);
  }

  void removeFromLangList(LanguageStruct value) {
    langList.remove(value);
  }

  void removeAtIndexFromLangList(int index) {
    langList.removeAt(index);
  }

  void updateLangListAtIndex(
    int index,
    LanguageStruct Function(LanguageStruct) updateFn,
  ) {
    langList[index] = updateFn(_langList[index]);
  }

  void insertAtIndexInLangList(int index, LanguageStruct value) {
    langList.insert(index, value);
  }

  LanguageStruct _selectedLang = LanguageStruct.fromSerializableMap(jsonDecode(
      '{\"language\":\"English\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fgreat_britain.png?alt=media&token=4065decd-2928-4f87-ba81-6dabdd17dde1\",\"lang_code\":\"en\"}'));
  LanguageStruct get selectedLang => _selectedLang;
  set selectedLang(LanguageStruct value) {
    _selectedLang = value;
    prefs.setString('ff_selectedLang', value.serialize());
  }

  void updateSelectedLangStruct(Function(LanguageStruct) updateFn) {
    updateFn(_selectedLang);
    prefs.setString('ff_selectedLang', _selectedLang.serialize());
  }

  String _specialty = '';
  String get specialty => _specialty;
  set specialty(String value) {
    _specialty = value;
    prefs.setString('ff_specialty', value);
  }

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;
  set rememberMe(bool value) {
    _rememberMe = value;
    prefs.setBool('ff_rememberMe', value);
  }

  bool _biometricID = false;
  bool get biometricID => _biometricID;
  set biometricID(bool value) {
    _biometricID = value;
    prefs.setBool('ff_biometricID', value);
  }

  bool _faceID = false;
  bool get faceID => _faceID;
  set faceID(bool value) {
    _faceID = value;
    prefs.setBool('ff_faceID', value);
  }

  bool _smsAuthenticator = false;
  bool get smsAuthenticator => _smsAuthenticator;
  set smsAuthenticator(bool value) {
    _smsAuthenticator = value;
    prefs.setBool('ff_smsAuthenticator', value);
  }

  bool _googleAuthenticator = false;
  bool get googleAuthenticator => _googleAuthenticator;
  set googleAuthenticator(bool value) {
    _googleAuthenticator = value;
  }

  bool _deviceManagement = false;
  bool get deviceManagement => _deviceManagement;
  set deviceManagement(bool value) {
    _deviceManagement = value;
    prefs.setBool('ff_deviceManagement', value);
  }

  bool _courseActivityAlerts = false;
  bool get courseActivityAlerts => _courseActivityAlerts;
  set courseActivityAlerts(bool value) {
    _courseActivityAlerts = value;
    prefs.setBool('ff_courseActivityAlerts', value);
  }

  bool _feedbackReviews = false;
  bool get feedbackReviews => _feedbackReviews;
  set feedbackReviews(bool value) {
    _feedbackReviews = value;
    prefs.setBool('ff_feedbackReviews', value);
  }

  bool _systemAnnouncements = false;
  bool get systemAnnouncements => _systemAnnouncements;
  set systemAnnouncements(bool value) {
    _systemAnnouncements = value;
    prefs.setBool('ff_systemAnnouncements', value);
  }

  bool _earningsUpdates = false;
  bool get earningsUpdates => _earningsUpdates;
  set earningsUpdates(bool value) {
    _earningsUpdates = value;
    prefs.setBool('ff_earningsUpdates', value);
  }

  bool _certificateRequests = false;
  bool get certificateRequests => _certificateRequests;
  set certificateRequests(bool value) {
    _certificateRequests = value;
    prefs.setBool('ff_certificateRequests', value);
  }

  bool _darkMode = false;
  bool get darkMode => _darkMode;
  set darkMode(bool value) {
    _darkMode = value;
    prefs.setBool('ff_darkMode', value);
  }

  int _navBar = 0;
  int get navBar => _navBar;
  set navBar(int value) {
    _navBar = value;
  }

  double _start = 0.0;
  double get start => _start;
  set start(double value) {
    _start = value;
  }

  double _end = 0.0;
  double get end => _end;
  set end(double value) {
    _end = value;
  }

  List<String> _topics = [
    'Design Thinking',
    'User Research',
    'Typography in UI/UX',
    'Usability Testing',
    'Color Theory in UI Design',
    'Design Systems & Components',
    'Psychology in UX Design',
    'Microinteractions & Animations',
    'Mobile UX Design',
    'Accessibility in Design',
    'Wireframing & Prototyping'
  ];
  List<String> get topics => _topics;
  set topics(List<String> value) {
    _topics = value;
  }

  void addToTopics(String value) {
    topics.add(value);
  }

  void removeFromTopics(String value) {
    topics.remove(value);
  }

  void removeAtIndexFromTopics(int index) {
    topics.removeAt(index);
  }

  void updateTopicsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    topics[index] = updateFn(_topics[index]);
  }

  void insertAtIndexInTopics(int index, String value) {
    topics.insert(index, value);
  }

  List<DocumentReference> _selectedNotifications = [];
  List<DocumentReference> get selectedNotifications => _selectedNotifications;
  set selectedNotifications(List<DocumentReference> value) {
    _selectedNotifications = value;
  }

  void addToSelectedNotifications(DocumentReference value) {
    selectedNotifications.add(value);
  }

  void removeFromSelectedNotifications(DocumentReference value) {
    selectedNotifications.remove(value);
  }

  void removeAtIndexFromSelectedNotifications(int index) {
    selectedNotifications.removeAt(index);
  }

  void updateSelectedNotificationsAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    selectedNotifications[index] = updateFn(_selectedNotifications[index]);
  }

  void insertAtIndexInSelectedNotifications(
      int index, DocumentReference value) {
    selectedNotifications.insert(index, value);
  }

  bool _allNotifications = false;
  bool get allNotifications => _allNotifications;
  set allNotifications(bool value) {
    _allNotifications = value;
    prefs.setBool('ff_allNotifications', value);
  }

  bool _reminder = false;
  bool get reminder => _reminder;
  set reminder(bool value) {
    _reminder = value;
    prefs.setBool('ff_reminder', value);
  }

  String _reminderHours = '';
  String get reminderHours => _reminderHours;
  set reminderHours(String value) {
    _reminderHours = value;
    prefs.setString('ff_reminderHours', value);
  }

  String _reminderMinut = '';
  String get reminderMinut => _reminderMinut;
  set reminderMinut(String value) {
    _reminderMinut = value;
    prefs.setString('ff_reminderMinut', value);
  }

  List<DocumentReference> _wishList = [];
  List<DocumentReference> get wishList => _wishList;
  set wishList(List<DocumentReference> value) {
    _wishList = value;
    prefs.setStringList('ff_wishList', value.map((x) => x.path).toList());
  }

  void addToWishList(DocumentReference value) {
    wishList.add(value);
    prefs.setStringList('ff_wishList', _wishList.map((x) => x.path).toList());
  }

  void removeFromWishList(DocumentReference value) {
    wishList.remove(value);
    prefs.setStringList('ff_wishList', _wishList.map((x) => x.path).toList());
  }

  void removeAtIndexFromWishList(int index) {
    wishList.removeAt(index);
    prefs.setStringList('ff_wishList', _wishList.map((x) => x.path).toList());
  }

  void updateWishListAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    wishList[index] = updateFn(_wishList[index]);
    prefs.setStringList('ff_wishList', _wishList.map((x) => x.path).toList());
  }

  void insertAtIndexInWishList(int index, DocumentReference value) {
    wishList.insert(index, value);
    prefs.setStringList('ff_wishList', _wishList.map((x) => x.path).toList());
  }

  String _instructorSpecialty = 'UI/UX Design';
  String get instructorSpecialty => _instructorSpecialty;
  set instructorSpecialty(String value) {
    _instructorSpecialty = value;
  }

  NewCoursesStruct _addNewCourse = NewCoursesStruct.fromSerializableMap(jsonDecode(
      '{\"cover_photo\":\"https://firebasestorage.googleapis.com/v0/b/skill-base-bf0a2.firebasestorage.app/o/courses%2Fcourses18.png?alt=media&token=4e71a943-fa59-4a30-9110-f8ed10460a46\",\"course_name\":\"UI Design Essentials: From Basics to Pro\",\"description\":\"Master the fundamentals of UI design and learn how to create visually appealing, user-friendly interfaces. This course covers key principles, tools, and best practices to help you design intuitive and engaging digital experiences.\",\"preview\":\"users/lyDvcqUKmfWuVqhH2vtPgNRh3EN2\",\"category\":\"UI/UX Design\",\"tags\":\"[\\\"Figma\\\",\\\"UXDesign\\\",\\\"ForStudents\\\",\\\"English\\\"]\",\"course_audience\":\"[\\\"Beginners\\\",\\\"Designers\\\"]\",\"language\":\"{\\\"language\\\":\\\"English\\\",\\\"flag\\\":\\\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fgreat_britain.png?alt=media&token=4065decd-2928-4f87-ba81-6dabdd17dde1\\\",\\\"lang_code\\\":\\\"en\\\"}\",\"price\":\"69.99\"}'));
  NewCoursesStruct get addNewCourse => _addNewCourse;
  set addNewCourse(NewCoursesStruct value) {
    _addNewCourse = value;
  }

  void updateAddNewCourseStruct(Function(NewCoursesStruct) updateFn) {
    updateFn(_addNewCourse);
  }

  bool _walkthroughsCourses = false;
  bool get walkthroughsCourses => _walkthroughsCourses;
  set walkthroughsCourses(bool value) {
    _walkthroughsCourses = value;
    prefs.setBool('ff_walkthroughsCourses', value);
  }

  bool _walkthroughsLesson = false;
  bool get walkthroughsLesson => _walkthroughsLesson;
  set walkthroughsLesson(bool value) {
    _walkthroughsLesson = value;
    prefs.setBool('ff_walkthroughsLesson', value);
  }

  OrderStruct _order = OrderStruct();
  OrderStruct get order => _order;
  set order(OrderStruct value) {
    _order = value;
    prefs.setString('ff_order', value.serialize());
  }

  void updateOrderStruct(Function(OrderStruct) updateFn) {
    updateFn(_order);
    prefs.setString('ff_order', _order.serialize());
  }

  List<ReminderStruct> _reminders = [];
  List<ReminderStruct> get reminders => _reminders;
  set reminders(List<ReminderStruct> value) {
    _reminders = value;
    prefs.setStringList(
        'ff_reminders', value.map((x) => x.serialize()).toList());
  }

  void addToReminders(ReminderStruct value) {
    reminders.add(value);
    prefs.setStringList(
        'ff_reminders', _reminders.map((x) => x.serialize()).toList());
  }

  void removeFromReminders(ReminderStruct value) {
    reminders.remove(value);
    prefs.setStringList(
        'ff_reminders', _reminders.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromReminders(int index) {
    reminders.removeAt(index);
    prefs.setStringList(
        'ff_reminders', _reminders.map((x) => x.serialize()).toList());
  }

  void updateRemindersAtIndex(
    int index,
    ReminderStruct Function(ReminderStruct) updateFn,
  ) {
    reminders[index] = updateFn(_reminders[index]);
    prefs.setStringList(
        'ff_reminders', _reminders.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInReminders(int index, ReminderStruct value) {
    reminders.insert(index, value);
    prefs.setStringList(
        'ff_reminders', _reminders.map((x) => x.serialize()).toList());
  }

  FilterStruct _filter = FilterStruct.fromSerializableMap(jsonDecode(
      '{\"rating\":\"0.0\",\"start\":\"0.0\",\"end\":\"500.0\",\"durationFrom\":\"0\",\"durationTo\":\"6000\"}'));
  FilterStruct get filter => _filter;
  set filter(FilterStruct value) {
    _filter = value;
  }

  void updateFilterStruct(Function(FilterStruct) updateFn) {
    updateFn(_filter);
  }

  List<CountryStruct> _countries = [
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"USA\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Fus.png?alt=media&token=b45d2f29-2014-4470-93dd-6f9ffdb91508\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"China\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Fcn.png?alt=media&token=3cef9880-f891-4b42-8758-e4e1406c4aa3\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Russia\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Fru.png?alt=media&token=d4677d6c-b2f0-4723-994a-1b3d2ff4f282\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"UAE\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Fae.png?alt=media&token=58587b1d-3c35-44a6-afe6-fdc41ccb3b2e\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Japan\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Fjp.png?alt=media&token=e0f16ae4-1b74-41ea-bfd0-81c30ed7be14\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Canada\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Fca.png?alt=media&token=07cd56fd-7013-449f-8679-79520a5e1e9f\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Turkey\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Ftr.png?alt=media&token=ccf688e4-d639-408a-b8ae-f18687303105\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Qatar\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Fqa.png?alt=media&token=7113ca9b-3894-43ff-a79e-f983eef008f1\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Argentina\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Far.png?alt=media&token=d8a10b31-d596-4ef6-add7-edeb495a9b99\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"South Korea\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Fkr.png?alt=media&token=9b95b6f8-f97e-4a36-ba87-bf3d2844e972\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Saudi Arabia\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/servio-d9f94.firebasestorage.app/o/flags%2Fsa.png?alt=media&token=83bf3ae9-8479-44c9-9dff-6ab61f7109f5\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Portugal\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fportugal.png?alt=media&token=b0334855-d95f-4b79-943f-d2e27ae3edba\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"England\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/skill-base-bf0a2.firebasestorage.app/o/england.png?alt=media&token=e8fc29e1-7d77-47a6-901e-fb4394937986\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"France\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Ffrance.png?alt=media&token=bd059836-7859-43a7-9600-0a0b7855ae80\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Germany\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fgermany.png?alt=media&token=4708d606-97dd-4146-8f99-e73fa6c73ed9\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Italia\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fitaly.png?alt=media&token=684ff3e6-b796-40ba-9e42-0fd5f9cc35b6\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Spain\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fspain.png?alt=media&token=18099b94-886f-4fc3-9694-52ad67ecd515\"}')),
    CountryStruct.fromSerializableMap(jsonDecode(
        '{\"country\":\"Tanzania\",\"flag\":\"https://seekflag.com/wp-content/uploads/2021/12/Tanzania-01-1.svg\"}'))
  ];
  List<CountryStruct> get countries => _countries;
  set countries(List<CountryStruct> value) {
    _countries = value;
  }

  void addToCountries(CountryStruct value) {
    countries.add(value);
  }

  void removeFromCountries(CountryStruct value) {
    countries.remove(value);
  }

  void removeAtIndexFromCountries(int index) {
    countries.removeAt(index);
  }

  void updateCountriesAtIndex(
    int index,
    CountryStruct Function(CountryStruct) updateFn,
  ) {
    countries[index] = updateFn(_countries[index]);
  }

  void insertAtIndexInCountries(int index, CountryStruct value) {
    countries.insert(index, value);
  }

  CountryStruct _country = CountryStruct.fromSerializableMap(jsonDecode(
      '{\"country\":\"England\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/skill-base-bf0a2.firebasestorage.app/o/england.png?alt=media&token=e8fc29e1-7d77-47a6-901e-fb4394937986\"}'));
  CountryStruct get country => _country;
  set country(CountryStruct value) {
    _country = value;
  }

  void updateCountryStruct(Function(CountryStruct) updateFn) {
    updateFn(_country);
  }

  bool _hasOption = false;
  bool get hasOption => _hasOption;
  set hasOption(bool value) {
    _hasOption = value;
    prefs.setBool('ff_hasOption', value);
  }

  bool _isCompleteOnboarding = false;
  bool get isCompleteOnboarding => _isCompleteOnboarding;
  set isCompleteOnboarding(bool value) {
    _isCompleteOnboarding = value;
    prefs.setBool('ff_isCompleteOnboarding', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
