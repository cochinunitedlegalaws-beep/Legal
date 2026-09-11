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


/** This is an auto generated class representing the ClientDocuments type in your schema. */
class ClientDocuments extends amplify_core.Model {
  static const classType = const _ClientDocumentsModelType();
  final String id;
  final int? _client_id;
  final String? _title;
  final String? _file_path;
  final int? _uploaded_by;
  final bool? _is_signed;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ClientDocumentsModelIdentifier get modelIdentifier {
      return ClientDocumentsModelIdentifier(
        id: id
      );
  }
  
  int? get client_id {
    return _client_id;
  }
  
  String? get title {
    return _title;
  }
  
  String? get file_path {
    return _file_path;
  }
  
  int? get uploaded_by {
    return _uploaded_by;
  }
  
  bool? get is_signed {
    return _is_signed;
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
  
  const ClientDocuments._internal({required this.id, client_id, title, file_path, uploaded_by, is_signed, data, createdAt, updatedAt}): _client_id = client_id, _title = title, _file_path = file_path, _uploaded_by = uploaded_by, _is_signed = is_signed, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ClientDocuments({String? id, int? client_id, String? title, String? file_path, int? uploaded_by, bool? is_signed, String? data}) {
    return ClientDocuments._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      client_id: client_id,
      title: title,
      file_path: file_path,
      uploaded_by: uploaded_by,
      is_signed: is_signed,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientDocuments &&
      id == other.id &&
      _client_id == other._client_id &&
      _title == other._title &&
      _file_path == other._file_path &&
      _uploaded_by == other._uploaded_by &&
      _is_signed == other._is_signed &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ClientDocuments {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("client_id=" + (_client_id != null ? _client_id!.toString() : "null") + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("file_path=" + "$_file_path" + ", ");
    buffer.write("uploaded_by=" + (_uploaded_by != null ? _uploaded_by!.toString() : "null") + ", ");
    buffer.write("is_signed=" + (_is_signed != null ? _is_signed!.toString() : "null") + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ClientDocuments copyWith({int? client_id, String? title, String? file_path, int? uploaded_by, bool? is_signed, String? data}) {
    return ClientDocuments._internal(
      id: id,
      client_id: client_id ?? this.client_id,
      title: title ?? this.title,
      file_path: file_path ?? this.file_path,
      uploaded_by: uploaded_by ?? this.uploaded_by,
      is_signed: is_signed ?? this.is_signed,
      data: data ?? this.data);
  }
  
  ClientDocuments copyWithModelFieldValues({
    ModelFieldValue<int?>? client_id,
    ModelFieldValue<String?>? title,
    ModelFieldValue<String?>? file_path,
    ModelFieldValue<int?>? uploaded_by,
    ModelFieldValue<bool?>? is_signed,
    ModelFieldValue<String?>? data
  }) {
    return ClientDocuments._internal(
      id: id,
      client_id: client_id == null ? this.client_id : client_id.value,
      title: title == null ? this.title : title.value,
      file_path: file_path == null ? this.file_path : file_path.value,
      uploaded_by: uploaded_by == null ? this.uploaded_by : uploaded_by.value,
      is_signed: is_signed == null ? this.is_signed : is_signed.value,
      data: data == null ? this.data : data.value
    );
  }
  
  ClientDocuments.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _client_id = (json['client_id'] as num?)?.toInt(),
      _title = json['title'],
      _file_path = json['file_path'],
      _uploaded_by = (json['uploaded_by'] as num?)?.toInt(),
      _is_signed = json['is_signed'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'client_id': _client_id, 'title': _title, 'file_path': _file_path, 'uploaded_by': _uploaded_by, 'is_signed': _is_signed, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'client_id': _client_id,
    'title': _title,
    'file_path': _file_path,
    'uploaded_by': _uploaded_by,
    'is_signed': _is_signed,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ClientDocumentsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ClientDocumentsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CLIENT_ID = amplify_core.QueryField(fieldName: "client_id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final FILE_PATH = amplify_core.QueryField(fieldName: "file_path");
  static final UPLOADED_BY = amplify_core.QueryField(fieldName: "uploaded_by");
  static final IS_SIGNED = amplify_core.QueryField(fieldName: "is_signed");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ClientDocuments";
    modelSchemaDefinition.pluralName = "ClientDocuments";
    
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
      key: ClientDocuments.CLIENT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ClientDocuments.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ClientDocuments.FILE_PATH,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ClientDocuments.UPLOADED_BY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ClientDocuments.IS_SIGNED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ClientDocuments.DATA,
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

class _ClientDocumentsModelType extends amplify_core.ModelType<ClientDocuments> {
  const _ClientDocumentsModelType();
  
  @override
  ClientDocuments fromJson(Map<String, dynamic> jsonData) {
    return ClientDocuments.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ClientDocuments';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ClientDocuments] in your schema.
 */
class ClientDocumentsModelIdentifier implements amplify_core.ModelIdentifier<ClientDocuments> {
  final String id;

  /** Create an instance of ClientDocumentsModelIdentifier using [id] the primary key. */
  const ClientDocumentsModelIdentifier({
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
  String toString() => 'ClientDocumentsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ClientDocumentsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}