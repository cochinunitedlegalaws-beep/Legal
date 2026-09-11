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


/** This is an auto generated class representing the Messages type in your schema. */
class Messages extends amplify_core.Model {
  static const classType = const _MessagesModelType();
  final String id;
  final int? _sender_id;
  final int? _receiver_id;
  final String? _content;
  final String? _sent_at;
  final bool? _is_read;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MessagesModelIdentifier get modelIdentifier {
      return MessagesModelIdentifier(
        id: id
      );
  }
  
  int? get sender_id {
    return _sender_id;
  }
  
  int? get receiver_id {
    return _receiver_id;
  }
  
  String? get content {
    return _content;
  }
  
  String? get sent_at {
    return _sent_at;
  }
  
  bool? get is_read {
    return _is_read;
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
  
  const Messages._internal({required this.id, sender_id, receiver_id, content, sent_at, is_read, data, createdAt, updatedAt}): _sender_id = sender_id, _receiver_id = receiver_id, _content = content, _sent_at = sent_at, _is_read = is_read, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Messages({String? id, int? sender_id, int? receiver_id, String? content, String? sent_at, bool? is_read, String? data}) {
    return Messages._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      sent_at: sent_at,
      is_read: is_read,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Messages &&
      id == other.id &&
      _sender_id == other._sender_id &&
      _receiver_id == other._receiver_id &&
      _content == other._content &&
      _sent_at == other._sent_at &&
      _is_read == other._is_read &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Messages {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sender_id=" + (_sender_id != null ? _sender_id!.toString() : "null") + ", ");
    buffer.write("receiver_id=" + (_receiver_id != null ? _receiver_id!.toString() : "null") + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("sent_at=" + "$_sent_at" + ", ");
    buffer.write("is_read=" + (_is_read != null ? _is_read!.toString() : "null") + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Messages copyWith({int? sender_id, int? receiver_id, String? content, String? sent_at, bool? is_read, String? data}) {
    return Messages._internal(
      id: id,
      sender_id: sender_id ?? this.sender_id,
      receiver_id: receiver_id ?? this.receiver_id,
      content: content ?? this.content,
      sent_at: sent_at ?? this.sent_at,
      is_read: is_read ?? this.is_read,
      data: data ?? this.data);
  }
  
  Messages copyWithModelFieldValues({
    ModelFieldValue<int?>? sender_id,
    ModelFieldValue<int?>? receiver_id,
    ModelFieldValue<String?>? content,
    ModelFieldValue<String?>? sent_at,
    ModelFieldValue<bool?>? is_read,
    ModelFieldValue<String?>? data
  }) {
    return Messages._internal(
      id: id,
      sender_id: sender_id == null ? this.sender_id : sender_id.value,
      receiver_id: receiver_id == null ? this.receiver_id : receiver_id.value,
      content: content == null ? this.content : content.value,
      sent_at: sent_at == null ? this.sent_at : sent_at.value,
      is_read: is_read == null ? this.is_read : is_read.value,
      data: data == null ? this.data : data.value
    );
  }
  
  Messages.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sender_id = (json['sender_id'] as num?)?.toInt(),
      _receiver_id = (json['receiver_id'] as num?)?.toInt(),
      _content = json['content'],
      _sent_at = json['sent_at'],
      _is_read = json['is_read'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sender_id': _sender_id, 'receiver_id': _receiver_id, 'content': _content, 'sent_at': _sent_at, 'is_read': _is_read, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'sender_id': _sender_id,
    'receiver_id': _receiver_id,
    'content': _content,
    'sent_at': _sent_at,
    'is_read': _is_read,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MessagesModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MessagesModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SENDER_ID = amplify_core.QueryField(fieldName: "sender_id");
  static final RECEIVER_ID = amplify_core.QueryField(fieldName: "receiver_id");
  static final CONTENT = amplify_core.QueryField(fieldName: "content");
  static final SENT_AT = amplify_core.QueryField(fieldName: "sent_at");
  static final IS_READ = amplify_core.QueryField(fieldName: "is_read");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Messages";
    modelSchemaDefinition.pluralName = "Messages";
    
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
      key: Messages.SENDER_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Messages.RECEIVER_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Messages.CONTENT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Messages.SENT_AT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Messages.IS_READ,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Messages.DATA,
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

class _MessagesModelType extends amplify_core.ModelType<Messages> {
  const _MessagesModelType();
  
  @override
  Messages fromJson(Map<String, dynamic> jsonData) {
    return Messages.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Messages';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Messages] in your schema.
 */
class MessagesModelIdentifier implements amplify_core.ModelIdentifier<Messages> {
  final String id;

  /** Create an instance of MessagesModelIdentifier using [id] the primary key. */
  const MessagesModelIdentifier({
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
  String toString() => 'MessagesModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MessagesModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}