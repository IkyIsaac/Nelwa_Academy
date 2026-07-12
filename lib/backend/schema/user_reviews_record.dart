import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserReviewsRecord extends FirestoreRecord {
  UserReviewsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  bool hasComment() => _comment != null;

  // "course_title" field.
  String? _courseTitle;
  String get courseTitle => _courseTitle ?? '';
  bool hasCourseTitle() => _courseTitle != null;

  // "course_image" field.
  String? _courseImage;
  String get courseImage => _courseImage ?? '';
  bool hasCourseImage() => _courseImage != null;

  // "course_instructor" field.
  String? _courseInstructor;
  String get courseInstructor => _courseInstructor ?? '';
  bool hasCourseInstructor() => _courseInstructor != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  bool hasRating() => _rating != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _comment = snapshotData['comment'] as String?;
    _courseTitle = snapshotData['course_title'] as String?;
    _courseImage = snapshotData['course_image'] as String?;
    _courseInstructor = snapshotData['course_instructor'] as String?;
    _rating = castToType<double>(snapshotData['rating']);
    _createdAt = snapshotData['created_at'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('user_reviews')
          : FirebaseFirestore.instance.collectionGroup('user_reviews');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('user_reviews').doc(id);

  static Stream<UserReviewsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserReviewsRecord.fromSnapshot(s));

  static Future<UserReviewsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserReviewsRecord.fromSnapshot(s));

  static UserReviewsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserReviewsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserReviewsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserReviewsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserReviewsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserReviewsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserReviewsRecordData({
  String? comment,
  String? courseTitle,
  String? courseImage,
  String? courseInstructor,
  double? rating,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'comment': comment,
      'course_title': courseTitle,
      'course_image': courseImage,
      'course_instructor': courseInstructor,
      'rating': rating,
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserReviewsRecordDocumentEquality implements Equality<UserReviewsRecord> {
  const UserReviewsRecordDocumentEquality();

  @override
  bool equals(UserReviewsRecord? e1, UserReviewsRecord? e2) {
    return e1?.comment == e2?.comment &&
        e1?.courseTitle == e2?.courseTitle &&
        e1?.courseImage == e2?.courseImage &&
        e1?.courseInstructor == e2?.courseInstructor &&
        e1?.rating == e2?.rating &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(UserReviewsRecord? e) => const ListEquality().hash([
        e?.comment,
        e?.courseTitle,
        e?.courseImage,
        e?.courseInstructor,
        e?.rating,
        e?.createdAt
      ]);

  @override
  bool isValidKey(Object? o) => o is UserReviewsRecord;
}
