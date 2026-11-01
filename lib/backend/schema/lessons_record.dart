import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import 'package:flutter/widgets.dart';

import '/flutter_flow/flutter_flow_util.dart';

class LessonsRecord extends FirestoreRecord {
  LessonsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "video_url" field.
  String? _videoUrl;
  String get videoUrl => _videoUrl ?? '';
  bool hasVideoUrl() => _videoUrl != null;

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  bool hasDuration() => _duration != null;

  // "order" field.
  int? _order;
  int get order => _order ?? 0;
  bool hasOrder() => _order != null;

  // "is_free" field.
  bool? _isFree;
  bool get isFree => _isFree ?? false;
  bool hasIsFree() => _isFree != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  DocumentReference get parentReference => reference.parent.parent!;

  // "title_sw" field.
  String? _titleSw;
  String get titleSw => _titleSw ?? '';
  bool hasTitleSw() => _titleSw != null;

  // "description_sw" field.
  String? _descriptionSw;
  String get descriptionSw => _descriptionSw ?? '';
  bool hasDescriptionSw() => _descriptionSw != null;

  // Title/description in the app's current language, falling back to the
  // English field when no Swahili version has been entered yet.
  String localizedTitle(BuildContext context) =>
      FFLocalizations.of(context).languageCode == 'sw' && titleSw.isNotEmpty
          ? titleSw
          : title;
  String localizedDescription(BuildContext context) =>
      FFLocalizations.of(context).languageCode == 'sw' &&
              descriptionSw.isNotEmpty
          ? descriptionSw
          : description;

  void _initializeFields() {
    _titleSw = snapshotData['title_sw'] as String?;
    _descriptionSw = snapshotData['description_sw'] as String?;
    _title = snapshotData['title'] as String?;
    _videoUrl = snapshotData['video_url'] as String?;
    _duration = castToType<int>(snapshotData['duration']);
    _order = castToType<int>(snapshotData['order']);
    _isFree = snapshotData['is_free'] as bool?;
    _image = snapshotData['image'] as String?;
    _description = snapshotData['description'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('lessons')
          : FirebaseFirestore.instance.collectionGroup('lessons');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('lessons').doc(id);

  static Stream<LessonsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LessonsRecord.fromSnapshot(s));

  static Future<LessonsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LessonsRecord.fromSnapshot(s));

  static LessonsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LessonsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LessonsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LessonsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LessonsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LessonsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLessonsRecordData({
  String? title,
  String? videoUrl,
  int? duration,
  int? order,
  bool? isFree,
  String? image,
  String? description,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'video_url': videoUrl,
      'duration': duration,
      'order': order,
      'is_free': isFree,
      'image': image,
      'description': description,
    }.withoutNulls,
  );

  return firestoreData;
}

class LessonsRecordDocumentEquality implements Equality<LessonsRecord> {
  const LessonsRecordDocumentEquality();

  @override
  bool equals(LessonsRecord? e1, LessonsRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.videoUrl == e2?.videoUrl &&
        e1?.duration == e2?.duration &&
        e1?.order == e2?.order &&
        e1?.isFree == e2?.isFree &&
        e1?.image == e2?.image &&
        e1?.description == e2?.description;
  }

  @override
  int hash(LessonsRecord? e) => const ListEquality().hash([
        e?.title,
        e?.videoUrl,
        e?.duration,
        e?.order,
        e?.isFree,
        e?.image,
        e?.description
      ]);

  @override
  bool isValidKey(Object? o) => o is LessonsRecord;
}
