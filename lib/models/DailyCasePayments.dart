/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the DailyCasePayments type in your schema. */
class DailyCasePayments extends amplify_core.Model {
  static const classType = const _DailyCasePaymentsModelType();
  final String id;
  final int? _case_id;
  final String? _amount;
  final String? _payment_date;
  final String? _payment_mode;
  final int? _received_by;
  final String? _remarks;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  DailyCasePaymentsModelIdentifier get modelIdentifier {
      return DailyCasePaymentsModelIdentifier(
        id: id
      );
  }
  
  int? get case_id {
    return _case_id;
  }
  
  String? get amount {
    return _amount;
  }
  
  String? get payment_date {
    return _payment_date;
  }
  
  String? get payment_mode {
    return _payment_mode;
  }
  
  int? get received_by {
    return _received_by;
  }
  
  String? get remarks {
    return _remarks;
  }
  
  String? get data {
    return _data;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const DailyCasePayments._internal({required this.id, case_id, amount, payment_date, payment_mode, received_by, remarks, data, createdAt, updatedAt}): _case_id = case_id, _amount = amount, _payment_date = payment_date, _payment_mode = payment_mode, _received_by = received_by, _remarks = remarks, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory DailyCasePayments({String? id, int? case_id, String? amount, String? payment_date, String? payment_mode, int? received_by, String? remarks, String? data}) {
    return DailyCasePayments._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      case_id: case_id,
      amount: amount,
      payment_date: payment_date,
      payment_mode: payment_mode,
      received_by: received_by,
      remarks: remarks,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyCasePayments &&
      id == other.id &&
      _case_id == other._case_id &&
      _amount == other._amount &&
      _payment_date == other._payment_date &&
      _payment_mode == other._payment_mode &&
      _received_by == other._received_by &&
      _remarks == other._remarks &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("DailyCasePayments {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("case_id=" + (_case_id != null ? _case_id!.toString() : "null") + ", ");
    buffer.write("amount=" + "$_amount" + ", ");
    buffer.write("payment_date=" + "$_payment_date" + ", ");
    buffer.write("payment_mode=" + "$_payment_mode" + ", ");
    buffer.write("received_by=" + (_received_by != null ? _received_by!.toString() : "null") + ", ");
    buffer.write("remarks=" + "$_remarks" + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  DailyCasePayments copyWith({int? case_id, String? amount, String? payment_date, String? payment_mode, int? received_by, String? remarks, String? data}) {
    return DailyCasePayments._internal(
      id: id,
      case_id: case_id ?? this.case_id,
      amount: amount ?? this.amount,
      payment_date: payment_date ?? this.payment_date,
      payment_mode: payment_mode ?? this.payment_mode,
      received_by: received_by ?? this.received_by,
      remarks: remarks ?? this.remarks,
      data: data ?? this.data);
  }
  
  DailyCasePayments copyWithModelFieldValues({
    ModelFieldValue<int?>? case_id,
    ModelFieldValue<String?>? amount,
    ModelFieldValue<String?>? payment_date,
    ModelFieldValue<String?>? payment_mode,
    ModelFieldValue<int?>? received_by,
    ModelFieldValue<String?>? remarks,
    ModelFieldValue<String?>? data
  }) {
    return DailyCasePayments._internal(
      id: id,
      case_id: case_id == null ? this.case_id : case_id.value,
      amount: amount == null ? this.amount : amount.value,
      payment_date: payment_date == null ? this.payment_date : payment_date.value,
      payment_mode: payment_mode == null ? this.payment_mode : payment_mode.value,
      received_by: received_by == null ? this.received_by : received_by.value,
      remarks: remarks == null ? this.remarks : remarks.value,
      data: data == null ? this.data : data.value
    );
  }
  
  DailyCasePayments.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _case_id = (json['case_id'] as num?)?.toInt(),
      _amount = json['amount'],
      _payment_date = json['payment_date'],
      _payment_mode = json['payment_mode'],
      _received_by = (json['received_by'] as num?)?.toInt(),
      _remarks = json['remarks'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'case_id': _case_id, 'amount': _amount, 'payment_date': _payment_date, 'payment_mode': _payment_mode, 'received_by': _received_by, 'remarks': _remarks, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'case_id': _case_id,
    'amount': _amount,
    'payment_date': _payment_date,
    'payment_mode': _payment_mode,
    'received_by': _received_by,
    'remarks': _remarks,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<DailyCasePaymentsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<DailyCasePaymentsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CASE_ID = amplify_core.QueryField(fieldName: "case_id");
  static final AMOUNT = amplify_core.QueryField(fieldName: "amount");
  static final PAYMENT_DATE = amplify_core.QueryField(fieldName: "payment_date");
  static final PAYMENT_MODE = amplify_core.QueryField(fieldName: "payment_mode");
  static final RECEIVED_BY = amplify_core.QueryField(fieldName: "received_by");
  static final REMARKS = amplify_core.QueryField(fieldName: "remarks");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "DailyCasePayments";
    modelSchemaDefinition.pluralName = "DailyCasePayments";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        provider: amplify_core.AuthRuleProvider.IAM,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DailyCasePayments.CASE_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DailyCasePayments.AMOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DailyCasePayments.PAYMENT_DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DailyCasePayments.PAYMENT_MODE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DailyCasePayments.RECEIVED_BY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DailyCasePayments.REMARKS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DailyCasePayments.DATA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _DailyCasePaymentsModelType extends amplify_core.ModelType<DailyCasePayments> {
  const _DailyCasePaymentsModelType();
  
  @override
  DailyCasePayments fromJson(Map<String, dynamic> jsonData) {
    return DailyCasePayments.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'DailyCasePayments';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [DailyCasePayments] in your schema.
 */
class DailyCasePaymentsModelIdentifier implements amplify_core.ModelIdentifier<DailyCasePayments> {
  final String id;

  /** Create an instance of DailyCasePaymentsModelIdentifier using [id] the primary key. */
  const DailyCasePaymentsModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'DailyCasePaymentsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is DailyCasePaymentsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}