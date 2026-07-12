import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CoursesReportRecord extends FirestoreRecord {
  CoursesReportRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  bool hasMessage() => _message != null;

  // "report_type" field.
  String? _reportType;
  String get reportType => _reportType ?? '';
  bool hasReportType() => _reportType != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "courses_ref" field.
  DocumentReference? _coursesRef;
  DocumentReference? get coursesRef => _coursesRef;
  bool hasCoursesRef() => _coursesRef != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _message = snapshotData['message'] as String?;
    _reportType = snapshotData['report_type'] as String?;
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _coursesRef = snapshotData['courses_ref'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('courses_report')
          : FirebaseFirestore.instance.collectionGroup('courses_report');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('courses_report').doc(id);

  static Stream<CoursesReportRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CoursesReportRecord.fromSnapshot(s));

  static Future<CoursesReportRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CoursesReportRecord.fromSnapshot(s));

  static CoursesReportRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CoursesReportRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CoursesReportRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CoursesReportRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CoursesReportRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CoursesReportRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCoursesReportRecordData({
  String? message,
  String? reportType,
  DocumentReference? userRef,
  DocumentReference? coursesRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'message': message,
      'report_type': reportType,
      'user_ref': userRef,
      'courses_ref': coursesRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class CoursesReportRecordDocumentEquality
    implements Equality<CoursesReportRecord> {
  const CoursesReportRecordDocumentEquality();

  @override
  bool equals(CoursesReportRecord? e1, CoursesReportRecord? e2) {
    return e1?.message == e2?.message &&
        e1?.reportType == e2?.reportType &&
        e1?.userRef == e2?.userRef &&
        e1?.coursesRef == e2?.coursesRef;
  }

  @override
  int hash(CoursesReportRecord? e) => const ListEquality()
      .hash([e?.message, e?.reportType, e?.userRef, e?.coursesRef]);

  @override
  bool isValidKey(Object? o) => o is CoursesReportRecord;
}
