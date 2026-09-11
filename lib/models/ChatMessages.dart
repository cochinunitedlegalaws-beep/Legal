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


/** This is an auto generated class representing the ChatMessages type in your schema. */
class ChatMessages extends amplify_core.Model {
  static const classType = const _ChatMessagesModelType();
  final String id;
  final String? _sender;
  final String? _receiver;
  final String? _message;
  final String? _timestamp;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ChatMessagesModelIdentifier get modelIdentifier {
      return ChatMessagesModelIdentifier(
        id: id
      );
  }
  
  String? get sender {
    return _sender;
  }
  
  String? get receiver {
    return _receiver;
  }
  
  String? get message {
    return _message;
  }
  
  String? get timestamp {
    return _timestamp;
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
  
  const ChatMessages._internal({required this.id, sender, receiver, message, timestamp, data, createdAt, updatedAt}): _sender = sender, _receiver = receiver, _message = message, _timestamp = timestamp, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ChatMessages({String? id, String? sender, String? receiver, String? message, String? timestamp, String? data}) {
    return ChatMessages._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      sender: sender,
      receiver: receiver,
      message: message,
      timestamp: timestamp,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessages &&
      id == other.id &&
      _sender == other._sender &&
      _receiver == other._receiver &&
      _message == other._message &&
      _timestamp == other._timestamp &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChatMessages {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sender=" + "$_sender" + ", ");
    buffer.write("receiver=" + "$_receiver" + ", ");
    buffer.write("message=" + "$_message" + ", ");
    buffer.write("timestamp=" + "$_timestamp" + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChatMessages copyWith({String? sender, String? receiver, String? message, String? timestamp, String? data}) {
    return ChatMessages._internal(
      id: id,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data);
  }
  
  ChatMessages copyWithModelFieldValues({
    ModelFieldValue<String?>? sender,
    ModelFieldValue<String?>? receiver,
    ModelFieldValue<String?>? message,
    ModelFieldValue<String?>? timestamp,
    ModelFieldValue<String?>? data
  }) {
    return ChatMessages._internal(
      id: id,
      sender: sender == null ? this.sender : sender.value,
      receiver: receiver == null ? this.receiver : receiver.value,
      message: message == null ? this.message : message.value,
      timestamp: timestamp == null ? this.timestamp : timestamp.value,
      data: data == null ? this.data : data.value
    );
  }
  
  ChatMessages.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sender = json['sender'],
      _receiver = json['receiver'],
      _message = json['message'],
      _timestamp = json['timestamp'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sender': _sender, 'receiver': _receiver, 'message': _message, 'timestamp': _timestamp, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'sender': _sender,
    'receiver': _receiver,
    'message': _message,
    'timestamp': _timestamp,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ChatMessagesModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ChatMessagesModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SENDER = amplify_core.QueryField(fieldName: "sender");
  static final RECEIVER = amplify_core.QueryField(fieldName: "receiver");
  static final MESSAGE = amplify_core.QueryField(fieldName: "message");
  static final TIMESTAMP = amplify_core.QueryField(fieldName: "timestamp");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatMessages";
    modelSchemaDefinition.pluralName = "ChatMessages";
    
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
      key: ChatMessages.SENDER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessages.RECEIVER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessages.MESSAGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessages.TIMESTAMP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessages.DATA,
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

class _ChatMessagesModelType extends amplify_core.ModelType<ChatMessages> {
  const _ChatMessagesModelType();
  
  @override
  ChatMessages fromJson(Map<String, dynamic> jsonData) {
    return ChatMessages.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ChatMessages';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ChatMessages] in your schema.
 */
class ChatMessagesModelIdentifier implements amplify_core.ModelIdentifier<ChatMessages> {
  final String id;

  /** Create an instance of ChatMessagesModelIdentifier using [id] the primary key. */
  const ChatMessagesModelIdentifier({
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
  String toString() => 'ChatMessagesModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ChatMessagesModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}