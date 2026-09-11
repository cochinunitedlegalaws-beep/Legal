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

import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'ActivityLogs.dart';
import 'Approvals.dart';
import 'Billings.dart';
import 'Cases.dart';
import 'ChamberDocuments.dart';
import 'ChatMessages.dart';
import 'Checklists.dart';
import 'ClientDocuments.dart';
import 'Clients.dart';
import 'CommunicationLogs.dart';
import 'DailyCasePayments.dart';
import 'Deals.dart';
import 'DocumentAuditLogs.dart';
import 'DocumentTemplates.dart';
import 'Expenses.dart';
import 'InwardPosts.dart';
import 'Leads.dart';
import 'Meetings.dart';
import 'Messages.dart';
import 'ServiceItems.dart';
import 'StaffAttendance.dart';
import 'Tasks.dart';
import 'Users.dart';
import 'VaultFiles.dart';
import 'ClientLicenses.dart';
import 'LicenseBilling.dart';
import 'LicenseTypes.dart';
import 'DealActivities.dart';
import 'DealAssignees.dart';
import 'DealHandoverHistory.dart';
import 'DealStageHistory.dart';
import 'CompanyBills.dart';
import 'DscRecords.dart';

export 'ActivityLogs.dart';
export 'Approvals.dart';
export 'Billings.dart';
export 'Cases.dart';
export 'ChamberDocuments.dart';
export 'ChatMessages.dart';
export 'Checklists.dart';
export 'ClientDocuments.dart';
export 'Clients.dart';
export 'CommunicationLogs.dart';
export 'DailyCasePayments.dart';
export 'Deals.dart';
export 'DocumentAuditLogs.dart';
export 'DocumentTemplates.dart';
export 'Expenses.dart';
export 'InwardPosts.dart';
export 'Leads.dart';
export 'Meetings.dart';
export 'Messages.dart';
export 'ServiceItems.dart';
export 'StaffAttendance.dart';
export 'Tasks.dart';
export 'Users.dart';
export 'VaultFiles.dart';
export 'ClientLicenses.dart';
export 'LicenseBilling.dart';
export 'LicenseTypes.dart';
export 'DealActivities.dart';
export 'DealAssignees.dart';
export 'DealHandoverHistory.dart';
export 'DealStageHistory.dart';
export 'CompanyBills.dart';
export 'DscRecords.dart';

class ModelProvider implements amplify_core.ModelProviderInterface {
  @override
  String version = "d4aacc86155b109ea79f69e639da7d4b";
  @override
  List<amplify_core.ModelSchema> modelSchemas = [ActivityLogs.schema, Approvals.schema, Billings.schema, Cases.schema, ChamberDocuments.schema, ChatMessages.schema, Checklists.schema, ClientDocuments.schema, Clients.schema, CommunicationLogs.schema, DailyCasePayments.schema, Deals.schema, DocumentAuditLogs.schema, DocumentTemplates.schema, Expenses.schema, InwardPosts.schema, Leads.schema, Meetings.schema, Messages.schema, ServiceItems.schema, StaffAttendance.schema, Tasks.schema, Users.schema, VaultFiles.schema, ClientLicenses.schema, LicenseBilling.schema, LicenseTypes.schema, DealActivities.schema, DealAssignees.schema, DealHandoverHistory.schema, DealStageHistory.schema, CompanyBills.schema, DscRecords.schema];
  @override
  List<amplify_core.ModelSchema> customTypeSchemas = [];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  amplify_core.ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "ActivityLogs":
        return ActivityLogs.classType;
      case "Approvals":
        return Approvals.classType;
      case "Billings":
        return Billings.classType;
      case "Cases":
        return Cases.classType;
      case "ChamberDocuments":
        return ChamberDocuments.classType;
      case "ChatMessages":
        return ChatMessages.classType;
      case "Checklists":
        return Checklists.classType;
      case "ClientDocuments":
        return ClientDocuments.classType;
      case "Clients":
        return Clients.classType;
      case "CommunicationLogs":
        return CommunicationLogs.classType;
      case "DailyCasePayments":
        return DailyCasePayments.classType;
      case "Deals":
        return Deals.classType;
      case "DocumentAuditLogs":
        return DocumentAuditLogs.classType;
      case "DocumentTemplates":
        return DocumentTemplates.classType;
      case "Expenses":
        return Expenses.classType;
      case "InwardPosts":
        return InwardPosts.classType;
      case "Leads":
        return Leads.classType;
      case "Meetings":
        return Meetings.classType;
      case "Messages":
        return Messages.classType;
      case "ServiceItems":
        return ServiceItems.classType;
      case "StaffAttendance":
        return StaffAttendance.classType;
      case "Tasks":
        return Tasks.classType;
      case "Users":
        return Users.classType;
      case "VaultFiles":
        return VaultFiles.classType;
      case "ClientLicenses":
        return ClientLicenses.classType;
      case "LicenseBilling":
        return LicenseBilling.classType;
      case "LicenseTypes":
        return LicenseTypes.classType;
      case "DealActivities":
        return DealActivities.classType;
      case "DealAssignees":
        return DealAssignees.classType;
      case "DealHandoverHistory":
        return DealHandoverHistory.classType;
      case "DealStageHistory":
        return DealStageHistory.classType;
      case "CompanyBills":
        return CompanyBills.classType;
      case "DscRecords":
        return DscRecords.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}


class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}
