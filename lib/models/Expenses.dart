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


/** This is an auto generated class representing the Expenses type in your schema. */
class Expenses extends amplify_core.Model {
  static const classType = const _ExpensesModelType();
  final String id;
  final String? _title;
  final String? _amount;
  final String? _category;
  final String? _date;
  final String? _description;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ExpensesModelIdentifier get modelIdentifier {
      return ExpensesModelIdentifier(
        id: id
      );
  }
  
  String? get title {
    return _title;
  }
  
  String? get amount {
    return _amount;
  }
  
  String? get category {
    return _category;
  }
  
  String? get date {
    return _date;
  }
  
  String? get description {
    return _description;
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
  
  const Expenses._internal({required this.id, title, amount, category, date, description, data, createdAt, updatedAt}): _title = title, _amount = amount, _category = category, _date = date, _description = description, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Expenses({String? id, String? title, String? amount, String? category, String? date, String? description, String? data}) {
    return Expenses._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      amount: amount,
      category: category,
      date: date,
      description: description,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Expenses &&
      id == other.id &&
      _title == other._title &&
      _amount == other._amount &&
      _category == other._category &&
      _date == other._date &&
      _description == other._description &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Expenses {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("amount=" + "$_amount" + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Expenses copyWith({String? title, String? amount, String? category, String? date, String? description, String? data}) {
    return Expenses._internal(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      data: data ?? this.data);
  }
  
  Expenses copyWithModelFieldValues({
    ModelFieldValue<String?>? title,
    ModelFieldValue<String?>? amount,
    ModelFieldValue<String?>? category,
    ModelFieldValue<String?>? date,
    ModelFieldValue<String?>? description,
    ModelFieldValue<String?>? data
  }) {
    return Expenses._internal(
      id: id,
      title: title == null ? this.title : title.value,
      amount: amount == null ? this.amount : amount.value,
      category: category == null ? this.category : category.value,
      date: date == null ? this.date : date.value,
      description: description == null ? this.description : description.value,
      data: data == null ? this.data : data.value
    );
  }
  
  Expenses.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _amount = json['amount'],
      _category = json['category'],
      _date = json['date'],
      _description = json['description'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'amount': _amount, 'category': _category, 'date': _date, 'description': _description, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'amount': _amount,
    'category': _category,
    'date': _date,
    'description': _description,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ExpensesModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ExpensesModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final AMOUNT = amplify_core.QueryField(fieldName: "amount");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Expenses";
    modelSchemaDefinition.pluralName = "Expenses";
    
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
      key: Expenses.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Expenses.AMOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Expenses.CATEGORY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Expenses.DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Expenses.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Expenses.DATA,
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

class _ExpensesModelType extends amplify_core.ModelType<Expenses> {
  const _ExpensesModelType();
  
  @override
  Expenses fromJson(Map<String, dynamic> jsonData) {
    return Expenses.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Expenses';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Expenses] in your schema.
 */
class ExpensesModelIdentifier implements amplify_core.ModelIdentifier<Expenses> {
  final String id;

  /** Create an instance of ExpensesModelIdentifier using [id] the primary key. */
  const ExpensesModelIdentifier({
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
  String toString() => 'ExpensesModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ExpensesModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}