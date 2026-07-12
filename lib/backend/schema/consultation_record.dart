import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// for consulatation
class ConsultationRecord extends FirestoreRecord {
  ConsultationRecord._(
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

  // "edited_time" field.
  DateTime? _editedTime;
  DateTime? get editedTime => _editedTime;
  bool hasEditedTime() => _editedTime != null;

  // "user_name" field.
  String? _userName;
  String get userName => _userName ?? '';
  bool hasUserName() => _userName != null;

  // "selected_department" field.
  String? _selectedDepartment;
  String get selectedDepartment => _selectedDepartment ?? '';
  bool hasSelectedDepartment() => _selectedDepartment != null;

  // "reason_for_visit" field.
  String? _reasonForVisit;
  String get reasonForVisit => _reasonForVisit ?? '';
  bool hasReasonForVisit() => _reasonForVisit != null;

  // "appointment_time" field.
  DateTime? _appointmentTime;
  DateTime? get appointmentTime => _appointmentTime;
  bool hasAppointmentTime() => _appointmentTime != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _editedTime = snapshotData['edited_time'] as DateTime?;
    _userName = snapshotData['user_name'] as String?;
    _selectedDepartment = snapshotData['selected_department'] as String?;
    _reasonForVisit = snapshotData['reason_for_visit'] as String?;
    _appointmentTime = snapshotData['appointment_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('consultation');

  static Stream<ConsultationRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ConsultationRecord.fromSnapshot(s));

  static Future<ConsultationRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ConsultationRecord.fromSnapshot(s));

  static ConsultationRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ConsultationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ConsultationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ConsultationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ConsultationRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ConsultationRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createConsultationRecordData({
  String? email,
  String? displayName,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  DateTime? editedTime,
  String? userName,
  String? selectedDepartment,
  String? reasonForVisit,
  DateTime? appointmentTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'edited_time': editedTime,
      'user_name': userName,
      'selected_department': selectedDepartment,
      'reason_for_visit': reasonForVisit,
      'appointment_time': appointmentTime,
    }.withoutNulls,
  );

  return firestoreData;
}

class ConsultationRecordDocumentEquality
    implements Equality<ConsultationRecord> {
  const ConsultationRecordDocumentEquality();

  @override
  bool equals(ConsultationRecord? e1, ConsultationRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.editedTime == e2?.editedTime &&
        e1?.userName == e2?.userName &&
        e1?.selectedDepartment == e2?.selectedDepartment &&
        e1?.reasonForVisit == e2?.reasonForVisit &&
        e1?.appointmentTime == e2?.appointmentTime;
  }

  @override
  int hash(ConsultationRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.editedTime,
        e?.userName,
        e?.selectedDepartment,
        e?.reasonForVisit,
        e?.appointmentTime
      ]);

  @override
  bool isValidKey(Object? o) => o is ConsultationRecord;
}
