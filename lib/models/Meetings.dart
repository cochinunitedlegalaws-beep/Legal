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


/** This is an auto generated class representing the Meetings type in your schema. */
class Meetings extends amplify_core.Model {
  static const classType = const _MeetingsModelType();
  final String id;
  final String? _title;
  final String? _meeting_date;
  final String? _location;
  final String? _attendees;
  final String? _data;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MeetingsModelIdentifier get modelIdentifier {
      return MeetingsModelIdentifier(
        id: id
      );
  }
  
  String? get title {
    return _title;
  }
  
  String? get meeting_date {
    return _meeting_date;
  }
  
  String? get location {
    return _location;
  }
  
  String? get attendees {
    return _attendees;
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
  
  const Meetings._internal({required this.id, title, meeting_date, location, attendees, data, createdAt, updatedAt}): _title = title, _meeting_date = meeting_date, _location = location, _attendees = attendees, _data = data, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Meetings({String? id, String? title, String? meeting_date, String? location, String? attendees, String? data}) {
    return Meetings._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      meeting_date: meeting_date,
      location: location,
      attendees: attendees,
      data: data);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Meetings &&
      id == other.id &&
      _title == other._title &&
      _meeting_date == other._meeting_date &&
      _location == other._location &&
      _attendees == other._attendees &&
      _data == other._data;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Meetings {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("meeting_date=" + "$_meeting_date" + ", ");
    buffer.write("location=" + "$_location" + ", ");
    buffer.write("attendees=" + "$_attendees" + ", ");
    buffer.write("data=" + "$_data" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Meetings copyWith({String? title, String? meeting_date, String? location, String? attendees, String? data}) {
    return Meetings._internal(
      id: id,
      title: title ?? this.title,
      meeting_date: meeting_date ?? this.meeting_date,
      location: location ?? this.location,
      attendees: attendees ?? this.attendees,
      data: data ?? this.data);
  }
  
  Meetings copyWithModelFieldValues({
    ModelFieldValue<String?>? title,
    ModelFieldValue<String?>? meeting_date,
    ModelFieldValue<String?>? location,
    ModelFieldValue<String?>? attendees,
    ModelFieldValue<String?>? data
  }) {
    return Meetings._internal(
      id: id,
      title: title == null ? this.title : title.value,
      meeting_date: meeting_date == null ? this.meeting_date : meeting_date.value,
      location: location == null ? this.location : location.value,
      attendees: attendees == null ? this.attendees : attendees.value,
      data: data == null ? this.data : data.value
    );
  }
  
  Meetings.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _meeting_date = json['meeting_date'],
      _location = json['location'],
      _attendees = json['attendees'],
      _data = json['data'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'meeting_date': _meeting_date, 'location': _location, 'attendees': _attendees, 'data': _data, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'meeting_date': _meeting_date,
    'location': _location,
    'attendees': _attendees,
    'data': _data,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MeetingsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MeetingsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final MEETING_DATE = amplify_core.QueryField(fieldName: "meeting_date");
  static final LOCATION = amplify_core.QueryField(fieldName: "location");
  static final ATTENDEES = amplify_core.QueryField(fieldName: "attendees");
  static final DATA = amplify_core.QueryField(fieldName: "data");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Meetings";
    modelSchemaDefinition.pluralName = "Meetings";
    
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
      key: Meetings.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Meetings.MEETING_DATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Meetings.LOCATION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Meetings.ATTENDEES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Meetings.DATA,
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

class _MeetingsModelType extends amplify_core.ModelType<Meetings> {
  const _MeetingsModelType();
  
  @override
  Meetings fromJson(Map<String, dynamic> jsonData) {
    return Meetings.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Meetings';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Meetings] in your schema.
 */
class MeetingsModelIdentifier implements amplify_core.ModelIdentifier<Meetings> {
  final String id;

  /** Create an instance of MeetingsModelIdentifier using [id] the primary key. */
  const MeetingsModelIdentifier({
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
  String toString() => 'MeetingsModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MeetingsModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}