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


/** This is an auto generated class representing the Deals type in your schema. */
class Deals extends amplify_core.Model {
  static const classType = const _DealsModelType();
  final String id;
  final String? _name;
  final int? _client_id;
  final String? _stage;
  final double? _amount;
  final String? _description;
  final bool? _is_won;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  DealsModelIdentifier get modelIdentifier {
      return DealsModelIdentifier(
        id: id
      );
  }
  
  String? get name {
    return _name;
  }
  
  int? get client_id {
    return _client_id;
  }
  
  String? get stage {
    return _stage;
  }
  
  double? get amount {
    return _amount;
  }
  
  String? get description {
    return _description;
  }
  
  bool? get is_won {
    return _is_won;
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
  
  const Deals._internal({required this.id, name, client_id, stage, amount, description, is_won, data, createdAt, updatedAt}): _name = name, _client_id = client_id, _stage = stage, _amount = amount, _description = description, _is_won = is_won, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Deals({String? id, String? name, int? client_id, String? stage, double? amount, String? description, bool? is_won, String? data}) {
    return Deals._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      client_id: client_id,
      stage: stage,
      amount: amount,
      description: description,
      is_won: is_won,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Deals &&
      id == other.id &&
      _name == other._name &&
      _client_id == other._client_id &&
      _stage == other._stage &&
      _amount == other._amount &&
      _description == other._description &&
      _is_won == other._is_won &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Deals {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("client_id=" + (_client_id != null ? _client_id!.toString() : "null") + ", ");
    buffer.write("stage=" + "$_stage" + ", ");
    buffer.write("amount=" + (_amount != null ? _amount!.toString() : "null") + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("is_won=" + (_is_won != null ? _is_won!.toString() : "null") + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Deals copyWith({String? name, int? client_id, String? stage, double? amount, String? description, bool? is_won, String? data}) {
    return Deals._internal(
      id: id,
      name: name ?? this.name,
      client_id: client_id ?? this.client_id,
      stage: stage ?? this.stage,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      is_won: is_won ?? this.is_won,
      data: data ?? this.data);
  }
  
  Deals copyWithModelFieldValues({
    ModelFieldValue<String?>? name,
    ModelFieldValue<int?>? client_id,
    ModelFieldValue<String?>? stage,
    ModelFieldValue<double?>? amount,
    ModelFieldValue<String?>? description,
    ModelFieldValue<bool?>? is_won,
    ModelFieldValue<String?>? data
  }) {
    return Deals._internal(
      id: id,
      name: name == null ? this.name : name.value,
      client_id: client_id == null ? this.client_id : client_id.value,
      stage: stage == null ? this.stage : stage.value,
      amount: amount == null ? this.amount : amount.value,
      description: description == null ? this.description : description.value,
      is_won: is_won == null ? this.is_won : is_won.value,
      data: data == null ? this.data : data.value
    );
  }
  
  Deals.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _client_id = (json['client_id'] as num?)?.toInt(),
      _stage = json['stage'],
      _amount = (json['amount'] as num?)?.toDouble(),
      _description = json['description'],
      _is_won = json['is_won'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'client_id': _client_id, 'stage': _stage, 'amount': _amount, 'description': _description, 'is_won': _is_won, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'client_id': _client_id,
    'stage': _stage,
    'amount': _amount,
    'description': _description,
    'is_won': _is_won,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<DealsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<DealsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final CLIENT_ID = amplify_core.QueryField(fieldName: "client_id");
  static final STAGE = amplify_core.QueryField(fieldName: "stage");
  static final AMOUNT = amplify_core.QueryField(fieldName: "amount");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final IS_WON = amplify_core.QueryField(fieldName: "is_won");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Deals";
    modelSchemaDefinition.pluralName = "Deals";
    
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
      key: Deals.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Deals.CLIENT_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Deals.STAGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Deals.AMOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Deals.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Deals.IS_WON,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Deals.DATA,
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

class _DealsModelType extends amplify_core.ModelType<Deals> {
  const _DealsModelType();
  
  @override
  Deals fromJson(Map<String, dynamic> jsonData) {
    return Deals.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Deals';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Deals] in your schema.
 */
class DealsModelIdentifier implements amplify_core.ModelIdentifier<Deals> {
  final String id;

  /** Create an instance of DealsModelIdentifier using [id] the primary key. */
  const DealsModelIdentifier({
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
  String toString() => 'DealsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is DealsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}