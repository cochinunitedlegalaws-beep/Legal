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


/** This is an auto generated class representing the Approvals type in your schema. */
class Approvals extends amplify_core.Model {
  static const classType = const _ApprovalsModelType();
  final String id;
  final String? _status;
  final String? _approved_at;
  final String? _rejected_at;
  final String? _reject_reason;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ApprovalsModelIdentifier get modelIdentifier {
      return ApprovalsModelIdentifier(
        id: id
      );
  }
  
  String? get status {
    return _status;
  }
  
  String? get approved_at {
    return _approved_at;
  }
  
  String? get rejected_at {
    return _rejected_at;
  }
  
  String? get reject_reason {
    return _reject_reason;
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
  
  const Approvals._internal({required this.id, status, approved_at, rejected_at, reject_reason, data, createdAt, updatedAt}): _status = status, _approved_at = approved_at, _rejected_at = rejected_at, _reject_reason = reject_reason, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Approvals({String? id, String? status, String? approved_at, String? rejected_at, String? reject_reason, String? data}) {
    return Approvals._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      status: status,
      approved_at: approved_at,
      rejected_at: rejected_at,
      reject_reason: reject_reason,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Approvals &&
      id == other.id &&
      _status == other._status &&
      _approved_at == other._approved_at &&
      _rejected_at == other._rejected_at &&
      _reject_reason == other._reject_reason &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Approvals {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("approved_at=" + "$_approved_at" + ", ");
    buffer.write("rejected_at=" + "$_rejected_at" + ", ");
    buffer.write("reject_reason=" + "$_reject_reason" + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Approvals copyWith({String? status, String? approved_at, String? rejected_at, String? reject_reason, String? data}) {
    return Approvals._internal(
      id: id,
      status: status ?? this.status,
      approved_at: approved_at ?? this.approved_at,
      rejected_at: rejected_at ?? this.rejected_at,
      reject_reason: reject_reason ?? this.reject_reason,
      data: data ?? this.data);
  }
  
  Approvals copyWithModelFieldValues({
    ModelFieldValue<String?>? status,
    ModelFieldValue<String?>? approved_at,
    ModelFieldValue<String?>? rejected_at,
    ModelFieldValue<String?>? reject_reason,
    ModelFieldValue<String?>? data
  }) {
    return Approvals._internal(
      id: id,
      status: status == null ? this.status : status.value,
      approved_at: approved_at == null ? this.approved_at : approved_at.value,
      rejected_at: rejected_at == null ? this.rejected_at : rejected_at.value,
      reject_reason: reject_reason == null ? this.reject_reason : reject_reason.value,
      data: data == null ? this.data : data.value
    );
  }
  
  Approvals.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _status = json['status'],
      _approved_at = json['approved_at'],
      _rejected_at = json['rejected_at'],
      _reject_reason = json['reject_reason'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'status': _status, 'approved_at': _approved_at, 'rejected_at': _rejected_at, 'reject_reason': _reject_reason, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'status': _status,
    'approved_at': _approved_at,
    'rejected_at': _rejected_at,
    'reject_reason': _reject_reason,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ApprovalsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ApprovalsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final APPROVED_AT = amplify_core.QueryField(fieldName: "approved_at");
  static final REJECTED_AT = amplify_core.QueryField(fieldName: "rejected_at");
  static final REJECT_REASON = amplify_core.QueryField(fieldName: "reject_reason");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Approvals";
    modelSchemaDefinition.pluralName = "Approvals";
    
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
      key: Approvals.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Approvals.APPROVED_AT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Approvals.REJECTED_AT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Approvals.REJECT_REASON,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Approvals.DATA,
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

class _ApprovalsModelType extends amplify_core.ModelType<Approvals> {
  const _ApprovalsModelType();
  
  @override
  Approvals fromJson(Map<String, dynamic> jsonData) {
    return Approvals.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Approvals';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Approvals] in your schema.
 */
class ApprovalsModelIdentifier implements amplify_core.ModelIdentifier<Approvals> {
  final String id;

  /** Create an instance of ApprovalsModelIdentifier using [id] the primary key. */
  const ApprovalsModelIdentifier({
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
  String toString() => 'ApprovalsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ApprovalsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}