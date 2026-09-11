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


/** This is an auto generated class representing the DocumentAuditLogs type in your schema. */
class DocumentAuditLogs extends amplify_core.Model {
  static const classType = const _DocumentAuditLogsModelType();
  final String id;
  final int? _document_id;
  final String? _action;
  final int? _user_id;
  final String? _details;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  DocumentAuditLogsModelIdentifier get modelIdentifier {
      return DocumentAuditLogsModelIdentifier(
        id: id
      );
  }
  
  int? get document_id {
    return _document_id;
  }
  
  String? get action {
    return _action;
  }
  
  int? get user_id {
    return _user_id;
  }
  
  String? get details {
    return _details;
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
  
  const DocumentAuditLogs._internal({required this.id, document_id, action, user_id, details, data, createdAt, updatedAt}): _document_id = document_id, _action = action, _user_id = user_id, _details = details, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory DocumentAuditLogs({String? id, int? document_id, String? action, int? user_id, String? details, String? data}) {
    return DocumentAuditLogs._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      document_id: document_id,
      action: action,
      user_id: user_id,
      details: details,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentAuditLogs &&
      id == other.id &&
      _document_id == other._document_id &&
      _action == other._action &&
      _user_id == other._user_id &&
      _details == other._details &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("DocumentAuditLogs {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("document_id=" + (_document_id != null ? _document_id!.toString() : "null") + ", ");
    buffer.write("action=" + "$_action" + ", ");
    buffer.write("user_id=" + (_user_id != null ? _user_id!.toString() : "null") + ", ");
    buffer.write("details=" + "$_details" + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  DocumentAuditLogs copyWith({int? document_id, String? action, int? user_id, String? details, String? data}) {
    return DocumentAuditLogs._internal(
      id: id,
      document_id: document_id ?? this.document_id,
      action: action ?? this.action,
      user_id: user_id ?? this.user_id,
      details: details ?? this.details,
      data: data ?? this.data);
  }
  
  DocumentAuditLogs copyWithModelFieldValues({
    ModelFieldValue<int?>? document_id,
    ModelFieldValue<String?>? action,
    ModelFieldValue<int?>? user_id,
    ModelFieldValue<String?>? details,
    ModelFieldValue<String?>? data
  }) {
    return DocumentAuditLogs._internal(
      id: id,
      document_id: document_id == null ? this.document_id : document_id.value,
      action: action == null ? this.action : action.value,
      user_id: user_id == null ? this.user_id : user_id.value,
      details: details == null ? this.details : details.value,
      data: data == null ? this.data : data.value
    );
  }
  
  DocumentAuditLogs.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _document_id = (json['document_id'] as num?)?.toInt(),
      _action = json['action'],
      _user_id = (json['user_id'] as num?)?.toInt(),
      _details = json['details'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'document_id': _document_id, 'action': _action, 'user_id': _user_id, 'details': _details, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'document_id': _document_id,
    'action': _action,
    'user_id': _user_id,
    'details': _details,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<DocumentAuditLogsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<DocumentAuditLogsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final DOCUMENT_ID = amplify_core.QueryField(fieldName: "document_id");
  static final ACTION = amplify_core.QueryField(fieldName: "action");
  static final USER_ID = amplify_core.QueryField(fieldName: "user_id");
  static final DETAILS = amplify_core.QueryField(fieldName: "details");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "DocumentAuditLogs";
    modelSchemaDefinition.pluralName = "DocumentAuditLogs";
    
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
      key: DocumentAuditLogs.DOCUMENT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DocumentAuditLogs.ACTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DocumentAuditLogs.USER_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DocumentAuditLogs.DETAILS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DocumentAuditLogs.DATA,
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

class _DocumentAuditLogsModelType extends amplify_core.ModelType<DocumentAuditLogs> {
  const _DocumentAuditLogsModelType();
  
  @override
  DocumentAuditLogs fromJson(Map<String, dynamic> jsonData) {
    return DocumentAuditLogs.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'DocumentAuditLogs';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [DocumentAuditLogs] in your schema.
 */
class DocumentAuditLogsModelIdentifier implements amplify_core.ModelIdentifier<DocumentAuditLogs> {
  final String id;

  /** Create an instance of DocumentAuditLogsModelIdentifier using [id] the primary key. */
  const DocumentAuditLogsModelIdentifier({
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
  String toString() => 'DocumentAuditLogsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is DocumentAuditLogsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}