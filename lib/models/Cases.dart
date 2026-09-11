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


/** This is an auto generated class representing the Cases type in your schema. */
class Cases extends amplify_core.Model {
  static const classType = const _CasesModelType();
  final String id;
  final int? _client_id;
  final String? _title;
  final String? _case_number;
  final String? _status;
  final String? _court_details;
  final String? _next_hearing_date;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  CasesModelIdentifier get modelIdentifier {
      return CasesModelIdentifier(
        id: id
      );
  }
  
  int? get client_id {
    return _client_id;
  }
  
  String? get title {
    return _title;
  }
  
  String? get case_number {
    return _case_number;
  }
  
  String? get status {
    return _status;
  }
  
  String? get court_details {
    return _court_details;
  }
  
  String? get next_hearing_date {
    return _next_hearing_date;
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
  
  const Cases._internal({required this.id, client_id, title, case_number, status, court_details, next_hearing_date, data, createdAt, updatedAt}): _client_id = client_id, _title = title, _case_number = case_number, _status = status, _court_details = court_details, _next_hearing_date = next_hearing_date, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Cases({String? id, int? client_id, String? title, String? case_number, String? status, String? court_details, String? next_hearing_date, String? data}) {
    return Cases._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      client_id: client_id,
      title: title,
      case_number: case_number,
      status: status,
      court_details: court_details,
      next_hearing_date: next_hearing_date,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Cases &&
      id == other.id &&
      _client_id == other._client_id &&
      _title == other._title &&
      _case_number == other._case_number &&
      _status == other._status &&
      _court_details == other._court_details &&
      _next_hearing_date == other._next_hearing_date &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Cases {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("client_id=" + (_client_id != null ? _client_id!.toString() : "null") + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("case_number=" + "$_case_number" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("court_details=" + "$_court_details" + ", ");
    buffer.write("next_hearing_date=" + "$_next_hearing_date" + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Cases copyWith({int? client_id, String? title, String? case_number, String? status, String? court_details, String? next_hearing_date, String? data}) {
    return Cases._internal(
      id: id,
      client_id: client_id ?? this.client_id,
      title: title ?? this.title,
      case_number: case_number ?? this.case_number,
      status: status ?? this.status,
      court_details: court_details ?? this.court_details,
      next_hearing_date: next_hearing_date ?? this.next_hearing_date,
      data: data ?? this.data);
  }
  
  Cases copyWithModelFieldValues({
    ModelFieldValue<int?>? client_id,
    ModelFieldValue<String?>? title,
    ModelFieldValue<String?>? case_number,
    ModelFieldValue<String?>? status,
    ModelFieldValue<String?>? court_details,
    ModelFieldValue<String?>? next_hearing_date,
    ModelFieldValue<String?>? data
  }) {
    return Cases._internal(
      id: id,
      client_id: client_id == null ? this.client_id : client_id.value,
      title: title == null ? this.title : title.value,
      case_number: case_number == null ? this.case_number : case_number.value,
      status: status == null ? this.status : status.value,
      court_details: court_details == null ? this.court_details : court_details.value,
      next_hearing_date: next_hearing_date == null ? this.next_hearing_date : next_hearing_date.value,
      data: data == null ? this.data : data.value
    );
  }
  
  Cases.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _client_id = (json['client_id'] as num?)?.toInt(),
      _title = json['title'],
      _case_number = json['case_number'],
      _status = json['status'],
      _court_details = json['court_details'],
      _next_hearing_date = json['next_hearing_date'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'client_id': _client_id, 'title': _title, 'case_number': _case_number, 'status': _status, 'court_details': _court_details, 'next_hearing_date': _next_hearing_date, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'client_id': _client_id,
    'title': _title,
    'case_number': _case_number,
    'status': _status,
    'court_details': _court_details,
    'next_hearing_date': _next_hearing_date,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<CasesModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<CasesModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CLIENT_ID = amplify_core.QueryField(fieldName: "client_id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final CASE_NUMBER = amplify_core.QueryField(fieldName: "case_number");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final COURT_DETAILS = amplify_core.QueryField(fieldName: "court_details");
  static final NEXT_HEARING_DATE = amplify_core.QueryField(fieldName: "next_hearing_date");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Cases";
    modelSchemaDefinition.pluralName = "Cases";
    
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
      key: Cases.CLIENT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Cases.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Cases.CASE_NUMBER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Cases.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Cases.COURT_DETAILS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Cases.NEXT_HEARING_DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Cases.DATA,
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

class _CasesModelType extends amplify_core.ModelType<Cases> {
  const _CasesModelType();
  
  @override
  Cases fromJson(Map<String, dynamic> jsonData) {
    return Cases.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Cases';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Cases] in your schema.
 */
class CasesModelIdentifier implements amplify_core.ModelIdentifier<Cases> {
  final String id;

  /** Create an instance of CasesModelIdentifier using [id] the primary key. */
  const CasesModelIdentifier({
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
  String toString() => 'CasesModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is CasesModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}