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


/** This is an auto generated class representing the VaultFiles type in your schema. */
class VaultFiles extends amplify_core.Model {
  static const classType = const _VaultFilesModelType();
  final String id;
  final String? _file_name;
  final String? _storage_path;
  final String? _uploaded_by;
  final bool? _is_encrypted;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  VaultFilesModelIdentifier get modelIdentifier {
      return VaultFilesModelIdentifier(
        id: id
      );
  }
  
  String? get file_name {
    return _file_name;
  }
  
  String? get storage_path {
    return _storage_path;
  }
  
  String? get uploaded_by {
    return _uploaded_by;
  }
  
  bool? get is_encrypted {
    return _is_encrypted;
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
  
  const VaultFiles._internal({required this.id, file_name, storage_path, uploaded_by, is_encrypted, data, createdAt, updatedAt}): _file_name = file_name, _storage_path = storage_path, _uploaded_by = uploaded_by, _is_encrypted = is_encrypted, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory VaultFiles({String? id, String? file_name, String? storage_path, String? uploaded_by, bool? is_encrypted, String? data}) {
    return VaultFiles._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      file_name: file_name,
      storage_path: storage_path,
      uploaded_by: uploaded_by,
      is_encrypted: is_encrypted,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VaultFiles &&
      id == other.id &&
      _file_name == other._file_name &&
      _storage_path == other._storage_path &&
      _uploaded_by == other._uploaded_by &&
      _is_encrypted == other._is_encrypted &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("VaultFiles {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("file_name=" + "$_file_name" + ", ");
    buffer.write("storage_path=" + "$_storage_path" + ", ");
    buffer.write("uploaded_by=" + "$_uploaded_by" + ", ");
    buffer.write("is_encrypted=" + (_is_encrypted != null ? _is_encrypted!.toString() : "null") + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  VaultFiles copyWith({String? file_name, String? storage_path, String? uploaded_by, bool? is_encrypted, String? data}) {
    return VaultFiles._internal(
      id: id,
      file_name: file_name ?? this.file_name,
      storage_path: storage_path ?? this.storage_path,
      uploaded_by: uploaded_by ?? this.uploaded_by,
      is_encrypted: is_encrypted ?? this.is_encrypted,
      data: data ?? this.data);
  }
  
  VaultFiles copyWithModelFieldValues({
    ModelFieldValue<String?>? file_name,
    ModelFieldValue<String?>? storage_path,
    ModelFieldValue<String?>? uploaded_by,
    ModelFieldValue<bool?>? is_encrypted,
    ModelFieldValue<String?>? data
  }) {
    return VaultFiles._internal(
      id: id,
      file_name: file_name == null ? this.file_name : file_name.value,
      storage_path: storage_path == null ? this.storage_path : storage_path.value,
      uploaded_by: uploaded_by == null ? this.uploaded_by : uploaded_by.value,
      is_encrypted: is_encrypted == null ? this.is_encrypted : is_encrypted.value,
      data: data == null ? this.data : data.value
    );
  }
  
  VaultFiles.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _file_name = json['file_name'],
      _storage_path = json['storage_path'],
      _uploaded_by = json['uploaded_by'],
      _is_encrypted = json['is_encrypted'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'file_name': _file_name, 'storage_path': _storage_path, 'uploaded_by': _uploaded_by, 'is_encrypted': _is_encrypted, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'file_name': _file_name,
    'storage_path': _storage_path,
    'uploaded_by': _uploaded_by,
    'is_encrypted': _is_encrypted,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<VaultFilesModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<VaultFilesModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final FILE_NAME = amplify_core.QueryField(fieldName: "file_name");
  static final STORAGE_PATH = amplify_core.QueryField(fieldName: "storage_path");
  static final UPLOADED_BY = amplify_core.QueryField(fieldName: "uploaded_by");
  static final IS_ENCRYPTED = amplify_core.QueryField(fieldName: "is_encrypted");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "VaultFiles";
    modelSchemaDefinition.pluralName = "VaultFiles";
    
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
      key: VaultFiles.FILE_NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: VaultFiles.STORAGE_PATH,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: VaultFiles.UPLOADED_BY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: VaultFiles.IS_ENCRYPTED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: VaultFiles.DATA,
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

class _VaultFilesModelType extends amplify_core.ModelType<VaultFiles> {
  const _VaultFilesModelType();
  
  @override
  VaultFiles fromJson(Map<String, dynamic> jsonData) {
    return VaultFiles.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'VaultFiles';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [VaultFiles] in your schema.
 */
class VaultFilesModelIdentifier implements amplify_core.ModelIdentifier<VaultFiles> {
  final String id;

  /** Create an instance of VaultFilesModelIdentifier using [id] the primary key. */
  const VaultFilesModelIdentifier({
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
  String toString() => 'VaultFilesModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is VaultFilesModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}