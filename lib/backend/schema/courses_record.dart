import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CoursesRecord extends FirestoreRecord {
  CoursesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "level" field.
  String? _level;
  String get level => _level ?? '';
  bool hasLevel() => _level != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "discount" field.
  double? _discount;
  double get discount => _discount ?? 0.0;
  bool hasDiscount() => _discount != null;

  // "instructor_ref" field.
  DocumentReference? _instructorRef;
  DocumentReference? get instructorRef => _instructorRef;
  bool hasInstructorRef() => _instructorRef != null;

  // "instructor_name" field.
  String? _instructorName;
  String get instructorName => _instructorName ?? '';
  bool hasInstructorName() => _instructorName != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  bool hasRating() => _rating != null;

  // "reviews_count" field.
  int? _reviewsCount;
  int get reviewsCount => _reviewsCount ?? 0;
  bool hasReviewsCount() => _reviewsCount != null;

  // "video_preview" field.
  String? _videoPreview;
  String get videoPreview => _videoPreview ?? '';
  bool hasVideoPreview() => _videoPreview != null;

  // "total_lessons" field.
  int? _totalLessons;
  int get totalLessons => _totalLessons ?? 0;
  bool hasTotalLessons() => _totalLessons != null;

  // "total_duration" field.
  int? _totalDuration;
  int get totalDuration => _totalDuration ?? 0;
  bool hasTotalDuration() => _totalDuration != null;

  // "is_published" field.
  bool? _isPublished;
  bool get isPublished => _isPublished ?? false;
  bool hasIsPublished() => _isPublished != null;

  // "published_date" field.
  DateTime? _publishedDate;
  DateTime? get publishedDate => _publishedDate;
  bool hasPublishedDate() => _publishedDate != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "group" field.
  String? _group;
  String get group => _group ?? '';
  bool hasGroup() => _group != null;

  // "tags" field.
  List<String>? _tags;
  List<String> get tags => _tags ?? const [];
  bool hasTags() => _tags != null;

  // "audience" field.
  List<String>? _audience;
  List<String> get audience => _audience ?? const [];
  bool hasAudience() => _audience != null;

  // "language" field.
  LanguageStruct? _language;
  LanguageStruct get language => _language ?? LanguageStruct();
  bool hasLanguage() => _language != null;

  // "preview_views" field.
  List<DocumentReference>? _previewViews;
  List<DocumentReference> get previewViews => _previewViews ?? const [];
  bool hasPreviewViews() => _previewViews != null;

  // "courses_id" field.
  DocumentReference? _coursesId;
  DocumentReference? get coursesId => _coursesId;
  bool hasCoursesId() => _coursesId != null;

  // "downloaders" field.
  List<DocumentReference>? _downloaders;
  List<DocumentReference> get downloaders => _downloaders ?? const [];
  bool hasDownloaders() => _downloaders != null;

  // "year_price" field.
  double? _yearPrice;
  double get yearPrice => _yearPrice ?? 0.0;
  bool hasYearPrice() => _yearPrice != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _description = snapshotData['description'] as String?;
    _category = snapshotData['category'] as String?;
    _level = snapshotData['level'] as String?;
    _price = castToType<double>(snapshotData['price']);
    _discount = castToType<double>(snapshotData['discount']);
    _instructorRef = snapshotData['instructor_ref'] as DocumentReference?;
    _instructorName = snapshotData['instructor_name'] as String?;
    _rating = castToType<double>(snapshotData['rating']);
    _reviewsCount = castToType<int>(snapshotData['reviews_count']);
    _videoPreview = snapshotData['video_preview'] as String?;
    _totalLessons = castToType<int>(snapshotData['total_lessons']);
    _totalDuration = castToType<int>(snapshotData['total_duration']);
    _isPublished = snapshotData['is_published'] as bool?;
    _publishedDate = snapshotData['published_date'] as DateTime?;
    _image = snapshotData['image'] as String?;
    _group = snapshotData['group'] as String?;
    _tags = getDataList(snapshotData['tags']);
    _audience = getDataList(snapshotData['audience']);
    _language = snapshotData['language'] is LanguageStruct
        ? snapshotData['language']
        : LanguageStruct.maybeFromMap(snapshotData['language']);
    _previewViews = getDataList(snapshotData['preview_views']);
    _coursesId = snapshotData['courses_id'] as DocumentReference?;
    _downloaders = getDataList(snapshotData['downloaders']);
    _yearPrice = castToType<double>(snapshotData['year_price']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('courses');

  static Stream<CoursesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CoursesRecord.fromSnapshot(s));

  static Future<CoursesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CoursesRecord.fromSnapshot(s));

  static CoursesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CoursesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CoursesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CoursesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CoursesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CoursesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCoursesRecordData({
  String? title,
  String? description,
  String? category,
  String? level,
  double? price,
  double? discount,
  DocumentReference? instructorRef,
  String? instructorName,
  double? rating,
  int? reviewsCount,
  String? videoPreview,
  int? totalLessons,
  int? totalDuration,
  bool? isPublished,
  DateTime? publishedDate,
  String? image,
  String? group,
  LanguageStruct? language,
  DocumentReference? coursesId,
  double? yearPrice,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'description': description,
      'category': category,
      'level': level,
      'price': price,
      'discount': discount,
      'instructor_ref': instructorRef,
      'instructor_name': instructorName,
      'rating': rating,
      'reviews_count': reviewsCount,
      'video_preview': videoPreview,
      'total_lessons': totalLessons,
      'total_duration': totalDuration,
      'is_published': isPublished,
      'published_date': publishedDate,
      'image': image,
      'group': group,
      'language': LanguageStruct().toMap(),
      'courses_id': coursesId,
      'year_price': yearPrice,
    }.withoutNulls,
  );

  // Handle nested data for "language" field.
  addLanguageStructData(firestoreData, language, 'language');

  return firestoreData;
}

class CoursesRecordDocumentEquality implements Equality<CoursesRecord> {
  const CoursesRecordDocumentEquality();

  @override
  bool equals(CoursesRecord? e1, CoursesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        e1?.category == e2?.category &&
        e1?.level == e2?.level &&
        e1?.price == e2?.price &&
        e1?.discount == e2?.discount &&
        e1?.instructorRef == e2?.instructorRef &&
        e1?.instructorName == e2?.instructorName &&
        e1?.rating == e2?.rating &&
        e1?.reviewsCount == e2?.reviewsCount &&
        e1?.videoPreview == e2?.videoPreview &&
        e1?.totalLessons == e2?.totalLessons &&
        e1?.totalDuration == e2?.totalDuration &&
        e1?.isPublished == e2?.isPublished &&
        e1?.publishedDate == e2?.publishedDate &&
        e1?.image == e2?.image &&
        e1?.group == e2?.group &&
        listEquality.equals(e1?.tags, e2?.tags) &&
        listEquality.equals(e1?.audience, e2?.audience) &&
        e1?.language == e2?.language &&
        listEquality.equals(e1?.previewViews, e2?.previewViews) &&
        e1?.coursesId == e2?.coursesId &&
        listEquality.equals(e1?.downloaders, e2?.downloaders) &&
        e1?.yearPrice == e2?.yearPrice;
  }

  @override
  int hash(CoursesRecord? e) => const ListEquality().hash([
        e?.title,
        e?.description,
        e?.category,
        e?.level,
        e?.price,
        e?.discount,
        e?.instructorRef,
        e?.instructorName,
        e?.rating,
        e?.reviewsCount,
        e?.videoPreview,
        e?.totalLessons,
        e?.totalDuration,
        e?.isPublished,
        e?.publishedDate,
        e?.image,
        e?.group,
        e?.tags,
        e?.audience,
        e?.language,
        e?.previewViews,
        e?.coursesId,
        e?.downloaders,
        e?.yearPrice
      ]);

  @override
  bool isValidKey(Object? o) => o is CoursesRecord;
}
