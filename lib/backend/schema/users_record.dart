import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "interests" field.
  List<String>? _interests;
  List<String> get interests => _interests ?? const [];
  bool hasInterests() => _interests != null;

  // "experience" field.
  String? _experience;
  String get experience => _experience ?? '';
  bool hasExperience() => _experience != null;

  // "use_for" field.
  String? _useFor;
  String get useFor => _useFor ?? '';
  bool hasUseFor() => _useFor != null;

  // "about_user" field.
  String? _aboutUser;
  String get aboutUser => _aboutUser ?? '';
  bool hasAboutUser() => _aboutUser != null;

  // "specialty" field.
  String? _specialty;
  String get specialty => _specialty ?? '';
  bool hasSpecialty() => _specialty != null;

  // "date_of_birth" field.
  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _dateOfBirth;
  bool hasDateOfBirth() => _dateOfBirth != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  bool hasCountry() => _country != null;

  // "education" field.
  String? _education;
  String get education => _education ?? '';
  bool hasEducation() => _education != null;

  // "support" field.
  DocumentReference? _support;
  DocumentReference? get support => _support;
  bool hasSupport() => _support != null;

  // "default_payment" field.
  DocumentReference? _defaultPayment;
  DocumentReference? get defaultPayment => _defaultPayment;
  bool hasDefaultPayment() => _defaultPayment != null;

  // "subscriptions" field.
  List<DocumentReference>? _subscriptions;
  List<DocumentReference> get subscriptions => _subscriptions ?? const [];
  bool hasSubscriptions() => _subscriptions != null;

  // "custom_categories" field.
  List<String>? _customCategories;
  List<String> get customCategories => _customCategories ?? const [];
  bool hasCustomCategories() => _customCategories != null;

  // "custom_tags" field.
  List<String>? _customTags;
  List<String> get customTags => _customTags ?? const [];
  bool hasCustomTags() => _customTags != null;

  // "instructor" field.
  bool? _instructor;
  bool get instructor => _instructor ?? false;
  bool hasInstructor() => _instructor != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "purchased_courses" field.
  List<DocumentReference>? _purchasedCourses;
  List<DocumentReference> get purchasedCourses => _purchasedCourses ?? const [];
  bool hasPurchasedCourses() => _purchasedCourses != null;

  // "continue_watching" field.
  List<ContinueWatchingStruct>? _continueWatching;
  List<ContinueWatchingStruct> get continueWatching =>
      _continueWatching ?? const [];
  bool hasContinueWatching() => _continueWatching != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _interests = getDataList(snapshotData['interests']);
    _experience = snapshotData['experience'] as String?;
    _useFor = snapshotData['use_for'] as String?;
    _aboutUser = snapshotData['about_user'] as String?;
    _specialty = snapshotData['specialty'] as String?;
    _dateOfBirth = snapshotData['date_of_birth'] as DateTime?;
    _country = snapshotData['country'] as String?;
    _education = snapshotData['education'] as String?;
    _support = snapshotData['support'] as DocumentReference?;
    _defaultPayment = snapshotData['default_payment'] as DocumentReference?;
    _subscriptions = getDataList(snapshotData['subscriptions']);
    _customCategories = getDataList(snapshotData['custom_categories']);
    _customTags = getDataList(snapshotData['custom_tags']);
    _instructor = snapshotData['instructor'] as bool?;
    _role = snapshotData['role'] as String?;
    _purchasedCourses = getDataList(snapshotData['purchased_courses']);
    _continueWatching = getStructList(
      snapshotData['continue_watching'],
      ContinueWatchingStruct.fromMap,
    );
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? experience,
  String? useFor,
  String? aboutUser,
  String? specialty,
  DateTime? dateOfBirth,
  String? country,
  String? education,
  DocumentReference? support,
  DocumentReference? defaultPayment,
  bool? instructor,
  String? role,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'experience': experience,
      'use_for': useFor,
      'about_user': aboutUser,
      'specialty': specialty,
      'date_of_birth': dateOfBirth,
      'country': country,
      'education': education,
      'support': support,
      'default_payment': defaultPayment,
      'instructor': instructor,
      'role': role,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        listEquality.equals(e1?.interests, e2?.interests) &&
        e1?.experience == e2?.experience &&
        e1?.useFor == e2?.useFor &&
        e1?.aboutUser == e2?.aboutUser &&
        e1?.specialty == e2?.specialty &&
        e1?.dateOfBirth == e2?.dateOfBirth &&
        e1?.country == e2?.country &&
        e1?.education == e2?.education &&
        e1?.support == e2?.support &&
        e1?.defaultPayment == e2?.defaultPayment &&
        listEquality.equals(e1?.subscriptions, e2?.subscriptions) &&
        listEquality.equals(e1?.customCategories, e2?.customCategories) &&
        listEquality.equals(e1?.customTags, e2?.customTags) &&
        e1?.instructor == e2?.instructor &&
        e1?.role == e2?.role &&
        listEquality.equals(e1?.purchasedCourses, e2?.purchasedCourses) &&
        listEquality.equals(e1?.continueWatching, e2?.continueWatching);
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.interests,
        e?.experience,
        e?.useFor,
        e?.aboutUser,
        e?.specialty,
        e?.dateOfBirth,
        e?.country,
        e?.education,
        e?.support,
        e?.defaultPayment,
        e?.subscriptions,
        e?.customCategories,
        e?.customTags,
        e?.instructor,
        e?.role,
        e?.purchasedCourses,
        e?.continueWatching
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
