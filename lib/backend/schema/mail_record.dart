import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Mirrors the `mail` email outbox written by firebase/functions/email/outbox.js.
/// Read-only from the client (admin only, per firestore.rules); only the
/// Cloud Functions' Admin SDK writes here.
class MailRecord extends FirestoreRecord {
  MailRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "template" field, e.g. welcome, purchase_receipt.
  String? _template;
  String get template => _template ?? '';

  // "to" field: recipient address.
  String? _to;
  String get to => _to ?? '';

  // "language" field: en or sw.
  String? _language;
  String get language => _language ?? '';

  // "userId" field.
  String? _userId;
  String get userId => _userId ?? '';

  // "status" field: queued, retrying, sent, failed, skipped.
  String? _status;
  String get status => _status ?? '';

  // "subject" field, set once rendered.
  String? _subject;
  String get subject => _subject ?? '';

  // "error" field, set on a failed or skipped send.
  String? _error;
  String get error => _error ?? '';

  // "resendId" field: Resend's id for the sent email.
  String? _resendId;
  String get resendId => _resendId ?? '';

  // "attempts" field: failed send attempts.
  int? _attempts;
  int get attempts => _attempts ?? 0;

  // "data" field: template variables, left as a raw map.
  Map<String, dynamic>? _data;
  Map<String, dynamic> get data => _data ?? const {};

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "sentAt" field.
  DateTime? _sentAt;
  DateTime? get sentAt => _sentAt;
  bool hasSentAt() => _sentAt != null;

  void _initializeFields() {
    _template = snapshotData['template'] as String?;
    _to = snapshotData['to'] as String?;
    _language = snapshotData['language'] as String?;
    _userId = snapshotData['userId'] as String?;
    _status = snapshotData['status'] as String?;
    _subject = snapshotData['subject'] as String?;
    _error = snapshotData['error'] as String?;
    _resendId = snapshotData['resendId'] as String?;
    _attempts = castToType<int>(snapshotData['attempts']);
    final rawData = snapshotData['data'];
    _data = rawData is Map<String, dynamic> ? rawData : null;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _sentAt = snapshotData['sentAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('mail');

  static Stream<MailRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MailRecord.fromSnapshot(s));

  static Future<MailRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MailRecord.fromSnapshot(s));

  static MailRecord fromSnapshot(DocumentSnapshot snapshot) => MailRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MailRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MailRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MailRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MailRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

class MailRecordDocumentEquality implements Equality<MailRecord> {
  const MailRecordDocumentEquality();

  @override
  bool equals(MailRecord? e1, MailRecord? e2) =>
      e1?.reference.path == e2?.reference.path &&
      e1?.status == e2?.status &&
      e1?.subject == e2?.subject &&
      e1?.error == e2?.error;

  @override
  int hash(MailRecord? e) => const ListEquality()
      .hash([e?.reference.path, e?.status, e?.subject, e?.error]);

  @override
  bool isValidKey(Object? o) => o is MailRecord;
}
