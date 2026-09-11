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


/** This is an auto generated class representing the ChamberDocuments type in your schema. */
class ChamberDocuments extends amplify_core.Model {
  static const classType = const _ChamberDocumentsModelType();
  final String id;
  final String? _title;
  final String? _file_path;
  final String? _category;
  final int? _uploaded_by;
  final int? _version;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ChamberDocumentsModelIdentifier get modelIdentifier {
      return ChamberDocumentsModelIdentifier(
        id: id
      );
  }
  
  String? get title {
    return _title;
  }
  
  String? get file_path {
    return _file_path;
  }
  
  String? get category {
    return _category;
  }
  
  int? get uploaded_by {
    return _uploaded_by;
  }
  
  int? get version {
    return _version;
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
  
  const ChamberDocuments._internal({required this.id, title, file_path, category, uploaded_by, version, data, createdAt, updatedAt}): _title = title, _file_path = file_path, _category = category, _uploaded_by = uploaded_by, _version = version, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ChamberDocuments({String? id, String? title, String? file_path, String? category, int? uploaded_by, int? version, String? data}) {
    return ChamberDocuments._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      file_path: file_path,
      category: category,
      uploaded_by: uploaded_by,
      version: version,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChamberDocuments &&
      id == other.id &&
      _title == other._title &&
      _file_path == other._file_path &&
      _category == other._category &&
      _uploaded_by == other._uploaded_by &&
      _version == other._version &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChamberDocuments {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("file_path=" + "$_file_path" + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("uploaded_by=" + (_uploaded_by != null ? _uploaded_by!.toString() : "null") + ", ");
    buffer.write("version=" + (_version != null ? _version!.toString() : "null") + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChamberDocuments copyWith({String? title, String? file_path, String? category, int? uploaded_by, int? version, String? data}) {
    return ChamberDocuments._internal(
      id: id,
      title: title ?? this.title,
      file_path: file_path ?? this.file_path,
      category: category ?? this.category,
      uploaded_by: uploaded_by ?? this.uploaded_by,
      version: version ?? this.version,
      data: data ?? this.data);
  }
  
  ChamberDocuments copyWithModelFieldValues({
    ModelFieldValue<String?>? title,
    ModelFieldValue<String?>? file_path,
    ModelFieldValue<String?>? category,
    ModelFieldValue<int?>? uploaded_by,
    ModelFieldValue<int?>? version,
    ModelFieldValue<String?>? data
  }) {
    return ChamberDocuments._internal(
      id: id,
      title: title == null ? this.title : title.value,
      file_path: file_path == null ? this.file_path : file_path.value,
      category: category == null ? this.category : category.value,
      uploaded_by: uploaded_by == null ? this.uploaded_by : uploaded_by.value,
      version: version == null ? this.version : version.value,
      data: data == null ? this.data : data.value
    );
  }
  
  ChamberDocuments.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _file_path = json['file_path'],
      _category = json['category'],
      _uploaded_by = (json['uploaded_by'] as num?)?.toInt(),
      _version = (json['version'] as num?)?.toInt(),
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'file_path': _file_path, 'category': _category, 'uploaded_by': _uploaded_by, 'version': _version, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'file_path': _file_path,
    'category': _category,
    'uploaded_by': _uploaded_by,
    'version': _version,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ChamberDocumentsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ChamberDocumentsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final FILE_PATH = amplify_core.QueryField(fieldName: "file_path");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final UPLOADED_BY = amplify_core.QueryField(fieldName: "uploaded_by");
  static final VERSION = amplify_core.QueryField(fieldName: "version");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChamberDocuments";
    modelSchemaDefinition.pluralName = "ChamberDocuments";
    
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
      key: ChamberDocuments.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChamberDocuments.FILE_PATH,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChamberDocuments.CATEGORY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChamberDocuments.UPLOADED_BY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChamberDocuments.VERSION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChamberDocuments.DATA,
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

class _ChamberDocumentsModelType extends amplify_core.ModelType<ChamberDocuments> {
  const _ChamberDocumentsModelType();
  
  @override
  ChamberDocuments fromJson(Map<String, dynamic> jsonData) {
    return ChamberDocuments.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ChamberDocuments';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ChamberDocuments] in your schema.
 */
class ChamberDocumentsModelIdentifier implements amplify_core.ModelIdentifier<ChamberDocuments> {
  final String id;

  /** Create an instance of ChamberDocumentsModelIdentifier using [id] the primary key. */
  const ChamberDocumentsModelIdentifier({
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
  String toString() => 'ChamberDocumentsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ChamberDocumentsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}