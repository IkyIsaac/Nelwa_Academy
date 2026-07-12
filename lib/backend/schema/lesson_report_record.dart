import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LessonReportRecord extends FirestoreRecord {
  LessonReportRecord._(
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

  // "lesson_ref" field.
  DocumentReference? _lessonRef;
  DocumentReference? get lessonRef => _lessonRef;
  bool hasLessonRef() => _lessonRef != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _message = snapshotData['message'] as String?;
    _reportType = snapshotData['report_type'] as String?;
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _lessonRef = snapshotData['lesson_ref'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('lesson_report')
          : FirebaseFirestore.instance.collectionGroup('lesson_report');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('lesson_report').doc(id);

  static Stream<LessonReportRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LessonReportRecord.fromSnapshot(s));

  static Future<LessonReportRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LessonReportRecord.fromSnapshot(s));

  static LessonReportRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LessonReportRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LessonReportRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LessonReportRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LessonReportRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LessonReportRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLessonReportRecordData({
  String? message,
  String? reportType,
  DocumentReference? userRef,
  DocumentReference? lessonRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'message': message,
      'report_type': reportType,
      'user_ref': userRef,
      'lesson_ref': lessonRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class LessonReportRecordDocumentEquality
    implements Equality<LessonReportRecord> {
  const LessonReportRecordDocumentEquality();

  @override
  bool equals(LessonReportRecord? e1, LessonReportRecord? e2) {
    return e1?.message == e2?.message &&
        e1?.reportType == e2?.reportType &&
        e1?.userRef == e2?.userRef &&
        e1?.lessonRef == e2?.lessonRef;
  }

  @override
  int hash(LessonReportRecord? e) => const ListEquality()
      .hash([e?.message, e?.reportType, e?.userRef, e?.lessonRef]);

  @override
  bool isValidKey(Object? o) => o is LessonReportRecord;
}
