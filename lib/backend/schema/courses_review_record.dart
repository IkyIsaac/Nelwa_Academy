import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CoursesReviewRecord extends FirestoreRecord {
  CoursesReviewRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_name" field.
  String? _userName;
  String get userName => _userName ?? '';
  bool hasUserName() => _userName != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  bool hasRating() => _rating != null;

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  bool hasComment() => _comment != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "liked" field.
  List<DocumentReference>? _liked;
  List<DocumentReference> get liked => _liked ?? const [];
  bool hasLiked() => _liked != null;

  // "disliked" field.
  List<DocumentReference>? _disliked;
  List<DocumentReference> get disliked => _disliked ?? const [];
  bool hasDisliked() => _disliked != null;

  // "user_image" field.
  String? _userImage;
  String get userImage => _userImage ?? '';
  bool hasUserImage() => _userImage != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _userName = snapshotData['user_name'] as String?;
    _rating = castToType<double>(snapshotData['rating']);
    _comment = snapshotData['comment'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _liked = getDataList(snapshotData['liked']);
    _disliked = getDataList(snapshotData['disliked']);
    _userImage = snapshotData['user_image'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('courses_review')
          : FirebaseFirestore.instance.collectionGroup('courses_review');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('courses_review').doc(id);

  static Stream<CoursesReviewRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CoursesReviewRecord.fromSnapshot(s));

  static Future<CoursesReviewRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CoursesReviewRecord.fromSnapshot(s));

  static CoursesReviewRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CoursesReviewRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CoursesReviewRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CoursesReviewRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CoursesReviewRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CoursesReviewRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCoursesReviewRecordData({
  String? userName,
  double? rating,
  String? comment,
  DateTime? createdAt,
  String? userImage,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_name': userName,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
      'user_image': userImage,
    }.withoutNulls,
  );

  return firestoreData;
}

class CoursesReviewRecordDocumentEquality
    implements Equality<CoursesReviewRecord> {
  const CoursesReviewRecordDocumentEquality();

  @override
  bool equals(CoursesReviewRecord? e1, CoursesReviewRecord? e2) {
    const listEquality = ListEquality();
    return e1?.userName == e2?.userName &&
        e1?.rating == e2?.rating &&
        e1?.comment == e2?.comment &&
        e1?.createdAt == e2?.createdAt &&
        listEquality.equals(e1?.liked, e2?.liked) &&
        listEquality.equals(e1?.disliked, e2?.disliked) &&
        e1?.userImage == e2?.userImage;
  }

  @override
  int hash(CoursesReviewRecord? e) => const ListEquality().hash([
        e?.userName,
        e?.rating,
        e?.comment,
        e?.createdAt,
        e?.liked,
        e?.disliked,
        e?.userImage
      ]);

  @override
  bool isValidKey(Object? o) => o is CoursesReviewRecord;
}
