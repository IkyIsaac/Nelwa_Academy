// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SalesReportsStruct extends FFFirebaseStruct {
  SalesReportsStruct({
    DocumentReference? userRef,
    double? amount,
    String? currency,
    Status? status,
    String? transactionType,
    DateTime? date,
    DocumentReference? paymentMethod,
    DocumentReference? courseRef,
    String? courseName,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _userRef = userRef,
        _amount = amount,
        _currency = currency,
        _status = status,
        _transactionType = transactionType,
        _date = date,
        _paymentMethod = paymentMethod,
        _courseRef = courseRef,
        _courseName = courseName,
        super(firestoreUtilData);

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  set userRef(DocumentReference? val) => _userRef = val;

  bool hasUserRef() => _userRef != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  set amount(double? val) => _amount = val;

  void incrementAmount(double amount) => amount = amount + amount;

  bool hasAmount() => _amount != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  set currency(String? val) => _currency = val;

  bool hasCurrency() => _currency != null;

  // "status" field.
  Status? _status;
  Status? get status => _status;
  set status(Status? val) => _status = val;

  bool hasStatus() => _status != null;

  // "transaction_type" field.
  String? _transactionType;
  String get transactionType => _transactionType ?? '';
  set transactionType(String? val) => _transactionType = val;

  bool hasTransactionType() => _transactionType != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  set date(DateTime? val) => _date = val;

  bool hasDate() => _date != null;

  // "payment_method" field.
  DocumentReference? _paymentMethod;
  DocumentReference? get paymentMethod => _paymentMethod;
  set paymentMethod(DocumentReference? val) => _paymentMethod = val;

  bool hasPaymentMethod() => _paymentMethod != null;

  // "courseRef" field.
  DocumentReference? _courseRef;
  DocumentReference? get courseRef => _courseRef;
  set courseRef(DocumentReference? val) => _courseRef = val;

  bool hasCourseRef() => _courseRef != null;

  // "course_name" field.
  String? _courseName;
  String get courseName => _courseName ?? '';
  set courseName(String? val) => _courseName = val;

  bool hasCourseName() => _courseName != null;

  static SalesReportsStruct fromMap(Map<String, dynamic> data) =>
      SalesReportsStruct(
        userRef: data['user_ref'] as DocumentReference?,
        amount: castToType<double>(data['amount']),
        currency: data['currency'] as String?,
        status: data['status'] is Status
            ? data['status']
            : deserializeEnum<Status>(data['status']),
        transactionType: data['transaction_type'] as String?,
        date: data['date'] as DateTime?,
        paymentMethod: data['payment_method'] as DocumentReference?,
        courseRef: data['courseRef'] as DocumentReference?,
        courseName: data['course_name'] as String?,
      );

  static SalesReportsStruct? maybeFromMap(dynamic data) => data is Map
      ? SalesReportsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'user_ref': _userRef,
        'amount': _amount,
        'currency': _currency,
        'status': _status?.serialize(),
        'transaction_type': _transactionType,
        'date': _date,
        'payment_method': _paymentMethod,
        'courseRef': _courseRef,
        'course_name': _courseName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'user_ref': serializeParam(
          _userRef,
          ParamType.DocumentReference,
        ),
        'amount': serializeParam(
          _amount,
          ParamType.double,
        ),
        'currency': serializeParam(
          _currency,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.Enum,
        ),
        'transaction_type': serializeParam(
          _transactionType,
          ParamType.String,
        ),
        'date': serializeParam(
          _date,
          ParamType.DateTime,
        ),
        'payment_method': serializeParam(
          _paymentMethod,
          ParamType.DocumentReference,
        ),
        'courseRef': serializeParam(
          _courseRef,
          ParamType.DocumentReference,
        ),
        'course_name': serializeParam(
          _courseName,
          ParamType.String,
        ),
      }.withoutNulls;

  static SalesReportsStruct fromSerializableMap(Map<String, dynamic> data) =>
      SalesReportsStruct(
        userRef: deserializeParam(
          data['user_ref'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
        amount: deserializeParam(
          data['amount'],
          ParamType.double,
          false,
        ),
        currency: deserializeParam(
          data['currency'],
          ParamType.String,
          false,
        ),
        status: deserializeParam<Status>(
          data['status'],
          ParamType.Enum,
          false,
        ),
        transactionType: deserializeParam(
          data['transaction_type'],
          ParamType.String,
          false,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.DateTime,
          false,
        ),
        paymentMethod: deserializeParam(
          data['payment_method'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users', 'payment_method'],
        ),
        courseRef: deserializeParam(
          data['courseRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['courses'],
        ),
        courseName: deserializeParam(
          data['course_name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SalesReportsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SalesReportsStruct &&
        userRef == other.userRef &&
        amount == other.amount &&
        currency == other.currency &&
        status == other.status &&
        transactionType == other.transactionType &&
        date == other.date &&
        paymentMethod == other.paymentMethod &&
        courseRef == other.courseRef &&
        courseName == other.courseName;
  }

  @override
  int get hashCode => const ListEquality().hash([
        userRef,
        amount,
        currency,
        status,
        transactionType,
        date,
        paymentMethod,
        courseRef,
        courseName
      ]);
}

SalesReportsStruct createSalesReportsStruct({
  DocumentReference? userRef,
  double? amount,
  String? currency,
  Status? status,
  String? transactionType,
  DateTime? date,
  DocumentReference? paymentMethod,
  DocumentReference? courseRef,
  String? courseName,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SalesReportsStruct(
      userRef: userRef,
      amount: amount,
      currency: currency,
      status: status,
      transactionType: transactionType,
      date: date,
      paymentMethod: paymentMethod,
      courseRef: courseRef,
      courseName: courseName,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SalesReportsStruct? updateSalesReportsStruct(
  SalesReportsStruct? salesReports, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    salesReports
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSalesReportsStructData(
  Map<String, dynamic> firestoreData,
  SalesReportsStruct? salesReports,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (salesReports == null) {
    return;
  }
  if (salesReports.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && salesReports.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final salesReportsData =
      getSalesReportsFirestoreData(salesReports, forFieldValue);
  final nestedData =
      salesReportsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = salesReports.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSalesReportsFirestoreData(
  SalesReportsStruct? salesReports, [
  bool forFieldValue = false,
]) {
  if (salesReports == null) {
    return {};
  }
  final firestoreData = mapToFirestore(salesReports.toMap());

  // Add any Firestore field values
  mapToFirestore(salesReports.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSalesReportsListFirestoreData(
  List<SalesReportsStruct>? salesReportss,
) =>
    salesReportss?.map((e) => getSalesReportsFirestoreData(e, true)).toList() ??
    [];
