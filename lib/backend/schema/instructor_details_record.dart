import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InstructorDetailsRecord extends FirestoreRecord {
  InstructorDetailsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "expertise" field.
  List<String>? _expertise;
  List<String> get expertise => _expertise ?? const [];
  bool hasExpertise() => _expertise != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  bool hasRating() => _rating != null;

  // "students" field.
  List<DocumentReference>? _students;
  List<DocumentReference> get students => _students ?? const [];
  bool hasStudents() => _students != null;

  // "followers" field.
  List<DocumentReference>? _followers;
  List<DocumentReference> get followers => _followers ?? const [];
  bool hasFollowers() => _followers != null;

  // "courses" field.
  List<DocumentReference>? _courses;
  List<DocumentReference> get courses => _courses ?? const [];
  bool hasCourses() => _courses != null;

  // "specialty" field.
  String? _specialty;
  String get specialty => _specialty ?? '';
  bool hasSpecialty() => _specialty != null;

  // "about_instructor" field.
  String? _aboutInstructor;
  String get aboutInstructor => _aboutInstructor ?? '';
  bool hasAboutInstructor() => _aboutInstructor != null;

  // "education" field.
  String? _education;
  String get education => _education ?? '';
  bool hasEducation() => _education != null;

  // "categories" field.
  List<CategoriesStruct>? _categories;
  List<CategoriesStruct> get categories => _categories ?? const [];
  bool hasCategories() => _categories != null;

  // "lessons" field.
  int? _lessons;
  int get lessons => _lessons ?? 0;
  bool hasLessons() => _lessons != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _expertise = getDataList(snapshotData['expertise']);
    _rating = castToType<double>(snapshotData['rating']);
    _students = getDataList(snapshotData['students']);
    _followers = getDataList(snapshotData['followers']);
    _courses = getDataList(snapshotData['courses']);
    _specialty = snapshotData['specialty'] as String?;
    _aboutInstructor = snapshotData['about_instructor'] as String?;
    _education = snapshotData['education'] as String?;
    _categories = getStructList(
      snapshotData['categories'],
      CategoriesStruct.fromMap,
    );
    _lessons = castToType<int>(snapshotData['lessons']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('instructor_details')
          : FirebaseFirestore.instance.collectionGroup('instructor_details');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('instructor_details').doc(id);

  static Stream<InstructorDetailsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => InstructorDetailsRecord.fromSnapshot(s));

  static Future<InstructorDetailsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => InstructorDetailsRecord.fromSnapshot(s));

  static InstructorDetailsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InstructorDetailsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static InstructorDetailsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      InstructorDetailsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'InstructorDetailsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is InstructorDetailsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createInstructorDetailsRecordData({
  double? rating,
  String? specialty,
  String? aboutInstructor,
  String? education,
  int? lessons,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'rating': rating,
      'specialty': specialty,
      'about_instructor': aboutInstructor,
      'education': education,
      'lessons': lessons,
    }.withoutNulls,
  );

  return firestoreData;
}

class InstructorDetailsRecordDocumentEquality
    implements Equality<InstructorDetailsRecord> {
  const InstructorDetailsRecordDocumentEquality();

  @override
  bool equals(InstructorDetailsRecord? e1, InstructorDetailsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.expertise, e2?.expertise) &&
        e1?.rating == e2?.rating &&
        listEquality.equals(e1?.students, e2?.students) &&
        listEquality.equals(e1?.followers, e2?.followers) &&
        listEquality.equals(e1?.courses, e2?.courses) &&
        e1?.specialty == e2?.specialty &&
        e1?.aboutInstructor == e2?.aboutInstructor &&
        e1?.education == e2?.education &&
        listEquality.equals(e1?.categories, e2?.categories) &&
        e1?.lessons == e2?.lessons;
  }

  @override
  int hash(InstructorDetailsRecord? e) => const ListEquality().hash([
        e?.expertise,
        e?.rating,
        e?.students,
        e?.followers,
        e?.courses,
        e?.specialty,
        e?.aboutInstructor,
        e?.education,
        e?.categories,
        e?.lessons
      ]);

  @override
  bool isValidKey(Object? o) => o is InstructorDetailsRecord;
}
