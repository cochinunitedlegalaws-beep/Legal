/* tslint:disable */
/* eslint-disable */
//  This file was automatically generated and should not be edited.

export type ActivityLogs = {
  __typename: "ActivityLogs",
  action?: string | null,
  createdAt: string,
  created_at?: string | null,
  data?: string | null,
  details?: string | null,
  id: string,
  target_id?: string | null,
  target_type?: string | null,
  updatedAt: string,
  user_id?: number | null,
};

export type Approvals = {
  __typename: "Approvals",
  approved_at?: string | null,
  createdAt: string,
  data?: string | null,
  id: string,
  reject_reason?: string | null,
  rejected_at?: string | null,
  status?: string | null,
  updatedAt: string,
};

export type Billings = {
  __typename: "Billings",
  amount?: string | null,
  authorities?: string | null,
  category?: string | null,
  client_name?: string | null,
  createdAt: string,
  data?: string | null,
  date?: string | null,
  id: string,
  invoice_no?: string | null,
  payment_received?: boolean | null,
  status?: string | null,
  type?: string | null,
  updatedAt: string,
};

export type Cases = {
  __typename: "Cases",
  case_number?: string | null,
  client_id?: number | null,
  court_details?: string | null,
  createdAt: string,
  data?: string | null,
  id: string,
  next_hearing_date?: string | null,
  status?: string | null,
  title?: string | null,
  updatedAt: string,
};

export type ChamberDocuments = {
  __typename: "ChamberDocuments",
  category?: string | null,
  createdAt: string,
  data?: string | null,
  file_path?: string | null,
  id: string,
  title?: string | null,
  updatedAt: string,
  uploaded_by?: number | null,
  version?: number | null,
};

export type ChatMessages = {
  __typename: "ChatMessages",
  createdAt: string,
  data?: string | null,
  id: string,
  message?: string | null,
  receiver?: string | null,
  sender?: string | null,
  timestamp?: string | null,
  updatedAt: string,
};

export type Checklists = {
  __typename: "Checklists",
  assigned_to?: string | null,
  createdAt: string,
  data?: string | null,
  description?: string | null,
  id: string,
  status?: string | null,
  title?: string | null,
  updatedAt: string,
};

export type ClientDocuments = {
  __typename: "ClientDocuments",
  client_id?: number | null,
  createdAt: string,
  data?: string | null,
  file_path?: string | null,
  id: string,
  is_signed?: boolean | null,
  title?: string | null,
  updatedAt: string,
  uploaded_by?: number | null,
};

export type Clients = {
  __typename: "Clients",
  address?: string | null,
  balance_due?: string | null,
  createdAt: string,
  data?: string | null,
  email?: string | null,
  id: string,
  name?: string | null,
  phone?: string | null,
  type_of_work?: string | null,
  updatedAt: string,
};

export type CommunicationLogs = {
  __typename: "CommunicationLogs",
  client_id?: string | null,
  createdAt: string,
  data?: string | null,
  date?: string | null,
  id: string,
  medium?: string | null,
  notes?: string | null,
  updatedAt: string,
};

export type DailyCasePayments = {
  __typename: "DailyCasePayments",
  amount?: string | null,
  case_id?: number | null,
  createdAt: string,
  data?: string | null,
  id: string,
  payment_date?: string | null,
  payment_mode?: string | null,
  received_by?: number | null,
  remarks?: string | null,
  updatedAt: string,
};

export type Deals = {
  __typename: "Deals",
  amount?: number | null,
  client_id?: number | null,
  createdAt: string,
  data?: string | null,
  description?: string | null,
  id: string,
  is_won?: boolean | null,
  name?: string | null,
  stage?: string | null,
  updatedAt: string,
};

export type DocumentAuditLogs = {
  __typename: "DocumentAuditLogs",
  action?: string | null,
  createdAt: string,
  data?: string | null,
  details?: string | null,
  document_id?: number | null,
  id: string,
  updatedAt: string,
  user_id?: number | null,
};

export type DocumentTemplates = {
  __typename: "DocumentTemplates",
  createdAt: string,
  data?: string | null,
  description?: string | null,
  file_path?: string | null,
  id: string,
  name?: string | null,
  updatedAt: string,
};

export type Expenses = {
  __typename: "Expenses",
  amount?: string | null,
  category?: string | null,
  createdAt: string,
  data?: string | null,
  date?: string | null,
  description?: string | null,
  id: string,
  title?: string | null,
  updatedAt: string,
};

export type InwardPosts = {
  __typename: "InwardPosts",
  assigned_to?: number | null,
  createdAt: string,
  data?: string | null,
  id: string,
  received_date?: string | null,
  sender?: string | null,
  status?: string | null,
  subject?: string | null,
  updatedAt: string,
};

export type Leads = {
  __typename: "Leads",
  createdAt: string,
  data?: string | null,
  email?: string | null,
  id: string,
  name?: string | null,
  phone?: string | null,
  source?: string | null,
  status?: string | null,
  updatedAt: string,
};

export type Meetings = {
  __typename: "Meetings",
  attendees?: string | null,
  createdAt: string,
  data?: string | null,
  id: string,
  location?: string | null,
  meeting_date?: string | null,
  title?: string | null,
  updatedAt: string,
};

export type Messages = {
  __typename: "Messages",
  content?: string | null,
  createdAt: string,
  data?: string | null,
  id: string,
  is_read?: boolean | null,
  receiver_id?: number | null,
  sender_id?: number | null,
  sent_at?: string | null,
  updatedAt: string,
};

export type ServiceItems = {
  __typename: "ServiceItems",
  category?: string | null,
  createdAt: string,
  data?: string | null,
  id: string,
  name?: string | null,
  price?: string | null,
  updatedAt: string,
};

export type StaffAttendance = {
  __typename: "StaffAttendance",
  attendance_date?: string | null,
  check_in_time?: string | null,
  check_out_time?: string | null,
  createdAt: string,
  data?: string | null,
  id: string,
  updatedAt: string,
  user_id?: number | null,
};

export type Tasks = {
  __typename: "Tasks",
  assigned_to?: number | null,
  createdAt: string,
  data?: string | null,
  description?: string | null,
  due_date?: string | null,
  id: string,
  status?: string | null,
  title?: string | null,
  updatedAt: string,
};

export type Users = {
  __typename: "Users",
  createdAt: string,
  data?: string | null,
  email?: string | null,
  id: string,
  name?: string | null,
  password?: string | null,
  role?: string | null,
  updatedAt: string,
  username?: string | null,
};

export type VaultFiles = {
  __typename: "VaultFiles",
  createdAt: string,
  data?: string | null,
  file_name?: string | null,
  id: string,
  is_encrypted?: boolean | null,
  storage_path?: string | null,
  updatedAt: string,
  uploaded_by?: string | null,
};

export type ModelActivityLogsFilterInput = {
  action?: ModelStringInput | null,
  and?: Array< ModelActivityLogsFilterInput | null > | null,
  createdAt?: ModelStringInput | null,
  created_at?: ModelStringInput | null,
  data?: ModelStringInput | null,
  details?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelActivityLogsFilterInput | null,
  or?: Array< ModelActivityLogsFilterInput | null > | null,
  target_id?: ModelStringInput | null,
  target_type?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  user_id?: ModelIntInput | null,
};

export type ModelStringInput = {
  attributeExists?: boolean | null,
  attributeType?: ModelAttributeTypes | null,
  beginsWith?: string | null,
  between?: Array< string | null > | null,
  contains?: string | null,
  eq?: string | null,
  ge?: string | null,
  gt?: string | null,
  le?: string | null,
  lt?: string | null,
  ne?: string | null,
  notContains?: string | null,
  size?: ModelSizeInput | null,
};

export enum ModelAttributeTypes {
  _null = "_null",
  binary = "binary",
  binarySet = "binarySet",
  bool = "bool",
  list = "list",
  map = "map",
  number = "number",
  numberSet = "numberSet",
  string = "string",
  stringSet = "stringSet",
}


export type ModelSizeInput = {
  between?: Array< number | null > | null,
  eq?: number | null,
  ge?: number | null,
  gt?: number | null,
  le?: number | null,
  lt?: number | null,
  ne?: number | null,
};

export type ModelIDInput = {
  attributeExists?: boolean | null,
  attributeType?: ModelAttributeTypes | null,
  beginsWith?: string | null,
  between?: Array< string | null > | null,
  contains?: string | null,
  eq?: string | null,
  ge?: string | null,
  gt?: string | null,
  le?: string | null,
  lt?: string | null,
  ne?: string | null,
  notContains?: string | null,
  size?: ModelSizeInput | null,
};

export type ModelIntInput = {
  attributeExists?: boolean | null,
  attributeType?: ModelAttributeTypes | null,
  between?: Array< number | null > | null,
  eq?: number | null,
  ge?: number | null,
  gt?: number | null,
  le?: number | null,
  lt?: number | null,
  ne?: number | null,
};

export type ModelActivityLogsConnection = {
  __typename: "ModelActivityLogsConnection",
  items:  Array<ActivityLogs | null >,
  nextToken?: string | null,
};

export type ModelApprovalsFilterInput = {
  and?: Array< ModelApprovalsFilterInput | null > | null,
  approved_at?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelApprovalsFilterInput | null,
  or?: Array< ModelApprovalsFilterInput | null > | null,
  reject_reason?: ModelStringInput | null,
  rejected_at?: ModelStringInput | null,
  status?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelApprovalsConnection = {
  __typename: "ModelApprovalsConnection",
  items:  Array<Approvals | null >,
  nextToken?: string | null,
};

export type ModelBillingsFilterInput = {
  amount?: ModelStringInput | null,
  and?: Array< ModelBillingsFilterInput | null > | null,
  authorities?: ModelStringInput | null,
  category?: ModelStringInput | null,
  client_name?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  date?: ModelStringInput | null,
  id?: ModelIDInput | null,
  invoice_no?: ModelStringInput | null,
  not?: ModelBillingsFilterInput | null,
  or?: Array< ModelBillingsFilterInput | null > | null,
  payment_received?: ModelBooleanInput | null,
  status?: ModelStringInput | null,
  type?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelBooleanInput = {
  attributeExists?: boolean | null,
  attributeType?: ModelAttributeTypes | null,
  eq?: boolean | null,
  ne?: boolean | null,
};

export type ModelBillingsConnection = {
  __typename: "ModelBillingsConnection",
  items:  Array<Billings | null >,
  nextToken?: string | null,
};

export type ModelCasesFilterInput = {
  and?: Array< ModelCasesFilterInput | null > | null,
  case_number?: ModelStringInput | null,
  client_id?: ModelIntInput | null,
  court_details?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  id?: ModelIDInput | null,
  next_hearing_date?: ModelStringInput | null,
  not?: ModelCasesFilterInput | null,
  or?: Array< ModelCasesFilterInput | null > | null,
  status?: ModelStringInput | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelCasesConnection = {
  __typename: "ModelCasesConnection",
  items:  Array<Cases | null >,
  nextToken?: string | null,
};

export type ModelChamberDocumentsFilterInput = {
  and?: Array< ModelChamberDocumentsFilterInput | null > | null,
  category?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  file_path?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelChamberDocumentsFilterInput | null,
  or?: Array< ModelChamberDocumentsFilterInput | null > | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  uploaded_by?: ModelIntInput | null,
  version?: ModelIntInput | null,
};

export type ModelChamberDocumentsConnection = {
  __typename: "ModelChamberDocumentsConnection",
  items:  Array<ChamberDocuments | null >,
  nextToken?: string | null,
};

export type ModelChatMessagesFilterInput = {
  and?: Array< ModelChatMessagesFilterInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  id?: ModelIDInput | null,
  message?: ModelStringInput | null,
  not?: ModelChatMessagesFilterInput | null,
  or?: Array< ModelChatMessagesFilterInput | null > | null,
  receiver?: ModelStringInput | null,
  sender?: ModelStringInput | null,
  timestamp?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelChatMessagesConnection = {
  __typename: "ModelChatMessagesConnection",
  items:  Array<ChatMessages | null >,
  nextToken?: string | null,
};

export type ModelChecklistsFilterInput = {
  and?: Array< ModelChecklistsFilterInput | null > | null,
  assigned_to?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  description?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelChecklistsFilterInput | null,
  or?: Array< ModelChecklistsFilterInput | null > | null,
  status?: ModelStringInput | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelChecklistsConnection = {
  __typename: "ModelChecklistsConnection",
  items:  Array<Checklists | null >,
  nextToken?: string | null,
};

export type ModelClientDocumentsFilterInput = {
  and?: Array< ModelClientDocumentsFilterInput | null > | null,
  client_id?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  file_path?: ModelStringInput | null,
  id?: ModelIDInput | null,
  is_signed?: ModelBooleanInput | null,
  not?: ModelClientDocumentsFilterInput | null,
  or?: Array< ModelClientDocumentsFilterInput | null > | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  uploaded_by?: ModelIntInput | null,
};

export type ModelClientDocumentsConnection = {
  __typename: "ModelClientDocumentsConnection",
  items:  Array<ClientDocuments | null >,
  nextToken?: string | null,
};

export type ModelClientsFilterInput = {
  address?: ModelStringInput | null,
  and?: Array< ModelClientsFilterInput | null > | null,
  balance_due?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  email?: ModelStringInput | null,
  id?: ModelIDInput | null,
  name?: ModelStringInput | null,
  not?: ModelClientsFilterInput | null,
  or?: Array< ModelClientsFilterInput | null > | null,
  phone?: ModelStringInput | null,
  type_of_work?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelClientsConnection = {
  __typename: "ModelClientsConnection",
  items:  Array<Clients | null >,
  nextToken?: string | null,
};

export type ModelCommunicationLogsFilterInput = {
  and?: Array< ModelCommunicationLogsFilterInput | null > | null,
  client_id?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  date?: ModelStringInput | null,
  id?: ModelIDInput | null,
  medium?: ModelStringInput | null,
  not?: ModelCommunicationLogsFilterInput | null,
  notes?: ModelStringInput | null,
  or?: Array< ModelCommunicationLogsFilterInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelCommunicationLogsConnection = {
  __typename: "ModelCommunicationLogsConnection",
  items:  Array<CommunicationLogs | null >,
  nextToken?: string | null,
};

export type ModelDailyCasePaymentsFilterInput = {
  amount?: ModelStringInput | null,
  and?: Array< ModelDailyCasePaymentsFilterInput | null > | null,
  case_id?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelDailyCasePaymentsFilterInput | null,
  or?: Array< ModelDailyCasePaymentsFilterInput | null > | null,
  payment_date?: ModelStringInput | null,
  payment_mode?: ModelStringInput | null,
  received_by?: ModelIntInput | null,
  remarks?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelDailyCasePaymentsConnection = {
  __typename: "ModelDailyCasePaymentsConnection",
  items:  Array<DailyCasePayments | null >,
  nextToken?: string | null,
};

export type ModelDealsFilterInput = {
  amount?: ModelFloatInput | null,
  and?: Array< ModelDealsFilterInput | null > | null,
  client_id?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  description?: ModelStringInput | null,
  id?: ModelIDInput | null,
  is_won?: ModelBooleanInput | null,
  name?: ModelStringInput | null,
  not?: ModelDealsFilterInput | null,
  or?: Array< ModelDealsFilterInput | null > | null,
  stage?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelFloatInput = {
  attributeExists?: boolean | null,
  attributeType?: ModelAttributeTypes | null,
  between?: Array< number | null > | null,
  eq?: number | null,
  ge?: number | null,
  gt?: number | null,
  le?: number | null,
  lt?: number | null,
  ne?: number | null,
};

export type ModelDealsConnection = {
  __typename: "ModelDealsConnection",
  items:  Array<Deals | null >,
  nextToken?: string | null,
};

export type ModelDocumentAuditLogsFilterInput = {
  action?: ModelStringInput | null,
  and?: Array< ModelDocumentAuditLogsFilterInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  details?: ModelStringInput | null,
  document_id?: ModelIntInput | null,
  id?: ModelIDInput | null,
  not?: ModelDocumentAuditLogsFilterInput | null,
  or?: Array< ModelDocumentAuditLogsFilterInput | null > | null,
  updatedAt?: ModelStringInput | null,
  user_id?: ModelIntInput | null,
};

export type ModelDocumentAuditLogsConnection = {
  __typename: "ModelDocumentAuditLogsConnection",
  items:  Array<DocumentAuditLogs | null >,
  nextToken?: string | null,
};

export type ModelDocumentTemplatesFilterInput = {
  and?: Array< ModelDocumentTemplatesFilterInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  description?: ModelStringInput | null,
  file_path?: ModelStringInput | null,
  id?: ModelIDInput | null,
  name?: ModelStringInput | null,
  not?: ModelDocumentTemplatesFilterInput | null,
  or?: Array< ModelDocumentTemplatesFilterInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelDocumentTemplatesConnection = {
  __typename: "ModelDocumentTemplatesConnection",
  items:  Array<DocumentTemplates | null >,
  nextToken?: string | null,
};

export type ModelExpensesFilterInput = {
  amount?: ModelStringInput | null,
  and?: Array< ModelExpensesFilterInput | null > | null,
  category?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  date?: ModelStringInput | null,
  description?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelExpensesFilterInput | null,
  or?: Array< ModelExpensesFilterInput | null > | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelExpensesConnection = {
  __typename: "ModelExpensesConnection",
  items:  Array<Expenses | null >,
  nextToken?: string | null,
};

export type ModelInwardPostsFilterInput = {
  and?: Array< ModelInwardPostsFilterInput | null > | null,
  assigned_to?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelInwardPostsFilterInput | null,
  or?: Array< ModelInwardPostsFilterInput | null > | null,
  received_date?: ModelStringInput | null,
  sender?: ModelStringInput | null,
  status?: ModelStringInput | null,
  subject?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelInwardPostsConnection = {
  __typename: "ModelInwardPostsConnection",
  items:  Array<InwardPosts | null >,
  nextToken?: string | null,
};

export type ModelLeadsFilterInput = {
  and?: Array< ModelLeadsFilterInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  email?: ModelStringInput | null,
  id?: ModelIDInput | null,
  name?: ModelStringInput | null,
  not?: ModelLeadsFilterInput | null,
  or?: Array< ModelLeadsFilterInput | null > | null,
  phone?: ModelStringInput | null,
  source?: ModelStringInput | null,
  status?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelLeadsConnection = {
  __typename: "ModelLeadsConnection",
  items:  Array<Leads | null >,
  nextToken?: string | null,
};

export type ModelMeetingsFilterInput = {
  and?: Array< ModelMeetingsFilterInput | null > | null,
  attendees?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  id?: ModelIDInput | null,
  location?: ModelStringInput | null,
  meeting_date?: ModelStringInput | null,
  not?: ModelMeetingsFilterInput | null,
  or?: Array< ModelMeetingsFilterInput | null > | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelMeetingsConnection = {
  __typename: "ModelMeetingsConnection",
  items:  Array<Meetings | null >,
  nextToken?: string | null,
};

export type ModelMessagesFilterInput = {
  and?: Array< ModelMessagesFilterInput | null > | null,
  content?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  id?: ModelIDInput | null,
  is_read?: ModelBooleanInput | null,
  not?: ModelMessagesFilterInput | null,
  or?: Array< ModelMessagesFilterInput | null > | null,
  receiver_id?: ModelIntInput | null,
  sender_id?: ModelIntInput | null,
  sent_at?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelMessagesConnection = {
  __typename: "ModelMessagesConnection",
  items:  Array<Messages | null >,
  nextToken?: string | null,
};

export type ModelServiceItemsFilterInput = {
  and?: Array< ModelServiceItemsFilterInput | null > | null,
  category?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  id?: ModelIDInput | null,
  name?: ModelStringInput | null,
  not?: ModelServiceItemsFilterInput | null,
  or?: Array< ModelServiceItemsFilterInput | null > | null,
  price?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelServiceItemsConnection = {
  __typename: "ModelServiceItemsConnection",
  items:  Array<ServiceItems | null >,
  nextToken?: string | null,
};

export type ModelStaffAttendanceFilterInput = {
  and?: Array< ModelStaffAttendanceFilterInput | null > | null,
  attendance_date?: ModelStringInput | null,
  check_in_time?: ModelStringInput | null,
  check_out_time?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelStaffAttendanceFilterInput | null,
  or?: Array< ModelStaffAttendanceFilterInput | null > | null,
  updatedAt?: ModelStringInput | null,
  user_id?: ModelIntInput | null,
};

export type ModelStaffAttendanceConnection = {
  __typename: "ModelStaffAttendanceConnection",
  items:  Array<StaffAttendance | null >,
  nextToken?: string | null,
};

export type ModelTasksFilterInput = {
  and?: Array< ModelTasksFilterInput | null > | null,
  assigned_to?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  description?: ModelStringInput | null,
  due_date?: ModelStringInput | null,
  id?: ModelIDInput | null,
  not?: ModelTasksFilterInput | null,
  or?: Array< ModelTasksFilterInput | null > | null,
  status?: ModelStringInput | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type ModelTasksConnection = {
  __typename: "ModelTasksConnection",
  items:  Array<Tasks | null >,
  nextToken?: string | null,
};

export type ModelUsersFilterInput = {
  and?: Array< ModelUsersFilterInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  email?: ModelStringInput | null,
  id?: ModelIDInput | null,
  name?: ModelStringInput | null,
  not?: ModelUsersFilterInput | null,
  or?: Array< ModelUsersFilterInput | null > | null,
  password?: ModelStringInput | null,
  role?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  username?: ModelStringInput | null,
};

export type ModelUsersConnection = {
  __typename: "ModelUsersConnection",
  items:  Array<Users | null >,
  nextToken?: string | null,
};

export type ModelVaultFilesFilterInput = {
  and?: Array< ModelVaultFilesFilterInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  file_name?: ModelStringInput | null,
  id?: ModelIDInput | null,
  is_encrypted?: ModelBooleanInput | null,
  not?: ModelVaultFilesFilterInput | null,
  or?: Array< ModelVaultFilesFilterInput | null > | null,
  storage_path?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  uploaded_by?: ModelStringInput | null,
};

export type ModelVaultFilesConnection = {
  __typename: "ModelVaultFilesConnection",
  items:  Array<VaultFiles | null >,
  nextToken?: string | null,
};

export type ModelActivityLogsConditionInput = {
  action?: ModelStringInput | null,
  and?: Array< ModelActivityLogsConditionInput | null > | null,
  createdAt?: ModelStringInput | null,
  created_at?: ModelStringInput | null,
  data?: ModelStringInput | null,
  details?: ModelStringInput | null,
  not?: ModelActivityLogsConditionInput | null,
  or?: Array< ModelActivityLogsConditionInput | null > | null,
  target_id?: ModelStringInput | null,
  target_type?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  user_id?: ModelIntInput | null,
};

export type CreateActivityLogsInput = {
  action?: string | null,
  created_at?: string | null,
  data?: string | null,
  details?: string | null,
  id?: string | null,
  target_id?: string | null,
  target_type?: string | null,
  user_id?: number | null,
};

export type ModelApprovalsConditionInput = {
  and?: Array< ModelApprovalsConditionInput | null > | null,
  approved_at?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  not?: ModelApprovalsConditionInput | null,
  or?: Array< ModelApprovalsConditionInput | null > | null,
  reject_reason?: ModelStringInput | null,
  rejected_at?: ModelStringInput | null,
  status?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateApprovalsInput = {
  approved_at?: string | null,
  data?: string | null,
  id?: string | null,
  reject_reason?: string | null,
  rejected_at?: string | null,
  status?: string | null,
};

export type ModelBillingsConditionInput = {
  amount?: ModelStringInput | null,
  and?: Array< ModelBillingsConditionInput | null > | null,
  authorities?: ModelStringInput | null,
  category?: ModelStringInput | null,
  client_name?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  date?: ModelStringInput | null,
  invoice_no?: ModelStringInput | null,
  not?: ModelBillingsConditionInput | null,
  or?: Array< ModelBillingsConditionInput | null > | null,
  payment_received?: ModelBooleanInput | null,
  status?: ModelStringInput | null,
  type?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateBillingsInput = {
  amount?: string | null,
  authorities?: string | null,
  category?: string | null,
  client_name?: string | null,
  data?: string | null,
  date?: string | null,
  id?: string | null,
  invoice_no?: string | null,
  payment_received?: boolean | null,
  status?: string | null,
  type?: string | null,
};

export type ModelCasesConditionInput = {
  and?: Array< ModelCasesConditionInput | null > | null,
  case_number?: ModelStringInput | null,
  client_id?: ModelIntInput | null,
  court_details?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  next_hearing_date?: ModelStringInput | null,
  not?: ModelCasesConditionInput | null,
  or?: Array< ModelCasesConditionInput | null > | null,
  status?: ModelStringInput | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateCasesInput = {
  case_number?: string | null,
  client_id?: number | null,
  court_details?: string | null,
  data?: string | null,
  id?: string | null,
  next_hearing_date?: string | null,
  status?: string | null,
  title?: string | null,
};

export type ModelChamberDocumentsConditionInput = {
  and?: Array< ModelChamberDocumentsConditionInput | null > | null,
  category?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  file_path?: ModelStringInput | null,
  not?: ModelChamberDocumentsConditionInput | null,
  or?: Array< ModelChamberDocumentsConditionInput | null > | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  uploaded_by?: ModelIntInput | null,
  version?: ModelIntInput | null,
};

export type CreateChamberDocumentsInput = {
  category?: string | null,
  data?: string | null,
  file_path?: string | null,
  id?: string | null,
  title?: string | null,
  uploaded_by?: number | null,
  version?: number | null,
};

export type ModelChatMessagesConditionInput = {
  and?: Array< ModelChatMessagesConditionInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  message?: ModelStringInput | null,
  not?: ModelChatMessagesConditionInput | null,
  or?: Array< ModelChatMessagesConditionInput | null > | null,
  receiver?: ModelStringInput | null,
  sender?: ModelStringInput | null,
  timestamp?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateChatMessagesInput = {
  data?: string | null,
  id?: string | null,
  message?: string | null,
  receiver?: string | null,
  sender?: string | null,
  timestamp?: string | null,
};

export type ModelChecklistsConditionInput = {
  and?: Array< ModelChecklistsConditionInput | null > | null,
  assigned_to?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  description?: ModelStringInput | null,
  not?: ModelChecklistsConditionInput | null,
  or?: Array< ModelChecklistsConditionInput | null > | null,
  status?: ModelStringInput | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateChecklistsInput = {
  assigned_to?: string | null,
  data?: string | null,
  description?: string | null,
  id?: string | null,
  status?: string | null,
  title?: string | null,
};

export type ModelClientDocumentsConditionInput = {
  and?: Array< ModelClientDocumentsConditionInput | null > | null,
  client_id?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  file_path?: ModelStringInput | null,
  is_signed?: ModelBooleanInput | null,
  not?: ModelClientDocumentsConditionInput | null,
  or?: Array< ModelClientDocumentsConditionInput | null > | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  uploaded_by?: ModelIntInput | null,
};

export type CreateClientDocumentsInput = {
  client_id?: number | null,
  data?: string | null,
  file_path?: string | null,
  id?: string | null,
  is_signed?: boolean | null,
  title?: string | null,
  uploaded_by?: number | null,
};

export type ModelClientsConditionInput = {
  address?: ModelStringInput | null,
  and?: Array< ModelClientsConditionInput | null > | null,
  balance_due?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  email?: ModelStringInput | null,
  name?: ModelStringInput | null,
  not?: ModelClientsConditionInput | null,
  or?: Array< ModelClientsConditionInput | null > | null,
  phone?: ModelStringInput | null,
  type_of_work?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateClientsInput = {
  address?: string | null,
  balance_due?: string | null,
  data?: string | null,
  email?: string | null,
  id?: string | null,
  name?: string | null,
  phone?: string | null,
  type_of_work?: string | null,
};

export type ModelCommunicationLogsConditionInput = {
  and?: Array< ModelCommunicationLogsConditionInput | null > | null,
  client_id?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  date?: ModelStringInput | null,
  medium?: ModelStringInput | null,
  not?: ModelCommunicationLogsConditionInput | null,
  notes?: ModelStringInput | null,
  or?: Array< ModelCommunicationLogsConditionInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateCommunicationLogsInput = {
  client_id?: string | null,
  data?: string | null,
  date?: string | null,
  id?: string | null,
  medium?: string | null,
  notes?: string | null,
};

export type ModelDailyCasePaymentsConditionInput = {
  amount?: ModelStringInput | null,
  and?: Array< ModelDailyCasePaymentsConditionInput | null > | null,
  case_id?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  not?: ModelDailyCasePaymentsConditionInput | null,
  or?: Array< ModelDailyCasePaymentsConditionInput | null > | null,
  payment_date?: ModelStringInput | null,
  payment_mode?: ModelStringInput | null,
  received_by?: ModelIntInput | null,
  remarks?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateDailyCasePaymentsInput = {
  amount?: string | null,
  case_id?: number | null,
  data?: string | null,
  id?: string | null,
  payment_date?: string | null,
  payment_mode?: string | null,
  received_by?: number | null,
  remarks?: string | null,
};

export type ModelDealsConditionInput = {
  amount?: ModelFloatInput | null,
  and?: Array< ModelDealsConditionInput | null > | null,
  client_id?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  description?: ModelStringInput | null,
  is_won?: ModelBooleanInput | null,
  name?: ModelStringInput | null,
  not?: ModelDealsConditionInput | null,
  or?: Array< ModelDealsConditionInput | null > | null,
  stage?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateDealsInput = {
  amount?: number | null,
  client_id?: number | null,
  data?: string | null,
  description?: string | null,
  id?: string | null,
  is_won?: boolean | null,
  name?: string | null,
  stage?: string | null,
};

export type ModelDocumentAuditLogsConditionInput = {
  action?: ModelStringInput | null,
  and?: Array< ModelDocumentAuditLogsConditionInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  details?: ModelStringInput | null,
  document_id?: ModelIntInput | null,
  not?: ModelDocumentAuditLogsConditionInput | null,
  or?: Array< ModelDocumentAuditLogsConditionInput | null > | null,
  updatedAt?: ModelStringInput | null,
  user_id?: ModelIntInput | null,
};

export type CreateDocumentAuditLogsInput = {
  action?: string | null,
  data?: string | null,
  details?: string | null,
  document_id?: number | null,
  id?: string | null,
  user_id?: number | null,
};

export type ModelDocumentTemplatesConditionInput = {
  and?: Array< ModelDocumentTemplatesConditionInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  description?: ModelStringInput | null,
  file_path?: ModelStringInput | null,
  name?: ModelStringInput | null,
  not?: ModelDocumentTemplatesConditionInput | null,
  or?: Array< ModelDocumentTemplatesConditionInput | null > | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateDocumentTemplatesInput = {
  data?: string | null,
  description?: string | null,
  file_path?: string | null,
  id?: string | null,
  name?: string | null,
};

export type ModelExpensesConditionInput = {
  amount?: ModelStringInput | null,
  and?: Array< ModelExpensesConditionInput | null > | null,
  category?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  date?: ModelStringInput | null,
  description?: ModelStringInput | null,
  not?: ModelExpensesConditionInput | null,
  or?: Array< ModelExpensesConditionInput | null > | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateExpensesInput = {
  amount?: string | null,
  category?: string | null,
  data?: string | null,
  date?: string | null,
  description?: string | null,
  id?: string | null,
  title?: string | null,
};

export type ModelInwardPostsConditionInput = {
  and?: Array< ModelInwardPostsConditionInput | null > | null,
  assigned_to?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  not?: ModelInwardPostsConditionInput | null,
  or?: Array< ModelInwardPostsConditionInput | null > | null,
  received_date?: ModelStringInput | null,
  sender?: ModelStringInput | null,
  status?: ModelStringInput | null,
  subject?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateInwardPostsInput = {
  assigned_to?: number | null,
  data?: string | null,
  id?: string | null,
  received_date?: string | null,
  sender?: string | null,
  status?: string | null,
  subject?: string | null,
};

export type ModelLeadsConditionInput = {
  and?: Array< ModelLeadsConditionInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  email?: ModelStringInput | null,
  name?: ModelStringInput | null,
  not?: ModelLeadsConditionInput | null,
  or?: Array< ModelLeadsConditionInput | null > | null,
  phone?: ModelStringInput | null,
  source?: ModelStringInput | null,
  status?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateLeadsInput = {
  data?: string | null,
  email?: string | null,
  id?: string | null,
  name?: string | null,
  phone?: string | null,
  source?: string | null,
  status?: string | null,
};

export type ModelMeetingsConditionInput = {
  and?: Array< ModelMeetingsConditionInput | null > | null,
  attendees?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  location?: ModelStringInput | null,
  meeting_date?: ModelStringInput | null,
  not?: ModelMeetingsConditionInput | null,
  or?: Array< ModelMeetingsConditionInput | null > | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateMeetingsInput = {
  attendees?: string | null,
  data?: string | null,
  id?: string | null,
  location?: string | null,
  meeting_date?: string | null,
  title?: string | null,
};

export type ModelMessagesConditionInput = {
  and?: Array< ModelMessagesConditionInput | null > | null,
  content?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  is_read?: ModelBooleanInput | null,
  not?: ModelMessagesConditionInput | null,
  or?: Array< ModelMessagesConditionInput | null > | null,
  receiver_id?: ModelIntInput | null,
  sender_id?: ModelIntInput | null,
  sent_at?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateMessagesInput = {
  content?: string | null,
  data?: string | null,
  id?: string | null,
  is_read?: boolean | null,
  receiver_id?: number | null,
  sender_id?: number | null,
  sent_at?: string | null,
};

export type ModelServiceItemsConditionInput = {
  and?: Array< ModelServiceItemsConditionInput | null > | null,
  category?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  name?: ModelStringInput | null,
  not?: ModelServiceItemsConditionInput | null,
  or?: Array< ModelServiceItemsConditionInput | null > | null,
  price?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateServiceItemsInput = {
  category?: string | null,
  data?: string | null,
  id?: string | null,
  name?: string | null,
  price?: string | null,
};

export type ModelStaffAttendanceConditionInput = {
  and?: Array< ModelStaffAttendanceConditionInput | null > | null,
  attendance_date?: ModelStringInput | null,
  check_in_time?: ModelStringInput | null,
  check_out_time?: ModelStringInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  not?: ModelStaffAttendanceConditionInput | null,
  or?: Array< ModelStaffAttendanceConditionInput | null > | null,
  updatedAt?: ModelStringInput | null,
  user_id?: ModelIntInput | null,
};

export type CreateStaffAttendanceInput = {
  attendance_date?: string | null,
  check_in_time?: string | null,
  check_out_time?: string | null,
  data?: string | null,
  id?: string | null,
  user_id?: number | null,
};

export type ModelTasksConditionInput = {
  and?: Array< ModelTasksConditionInput | null > | null,
  assigned_to?: ModelIntInput | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  description?: ModelStringInput | null,
  due_date?: ModelStringInput | null,
  not?: ModelTasksConditionInput | null,
  or?: Array< ModelTasksConditionInput | null > | null,
  status?: ModelStringInput | null,
  title?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
};

export type CreateTasksInput = {
  assigned_to?: number | null,
  data?: string | null,
  description?: string | null,
  due_date?: string | null,
  id?: string | null,
  status?: string | null,
  title?: string | null,
};

export type ModelUsersConditionInput = {
  and?: Array< ModelUsersConditionInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  email?: ModelStringInput | null,
  name?: ModelStringInput | null,
  not?: ModelUsersConditionInput | null,
  or?: Array< ModelUsersConditionInput | null > | null,
  password?: ModelStringInput | null,
  role?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  username?: ModelStringInput | null,
};

export type CreateUsersInput = {
  data?: string | null,
  email?: string | null,
  id?: string | null,
  name?: string | null,
  password?: string | null,
  role?: string | null,
  username?: string | null,
};

export type ModelVaultFilesConditionInput = {
  and?: Array< ModelVaultFilesConditionInput | null > | null,
  createdAt?: ModelStringInput | null,
  data?: ModelStringInput | null,
  file_name?: ModelStringInput | null,
  is_encrypted?: ModelBooleanInput | null,
  not?: ModelVaultFilesConditionInput | null,
  or?: Array< ModelVaultFilesConditionInput | null > | null,
  storage_path?: ModelStringInput | null,
  updatedAt?: ModelStringInput | null,
  uploaded_by?: ModelStringInput | null,
};

export type CreateVaultFilesInput = {
  data?: string | null,
  file_name?: string | null,
  id?: string | null,
  is_encrypted?: boolean | null,
  storage_path?: string | null,
  uploaded_by?: string | null,
};

export type DeleteActivityLogsInput = {
  id: string,
};

export type DeleteApprovalsInput = {
  id: string,
};

export type DeleteBillingsInput = {
  id: string,
};

export type DeleteCasesInput = {
  id: string,
};

export type DeleteChamberDocumentsInput = {
  id: string,
};

export type DeleteChatMessagesInput = {
  id: string,
};

export type DeleteChecklistsInput = {
  id: string,
};

export type DeleteClientDocumentsInput = {
  id: string,
};

export type DeleteClientsInput = {
  id: string,
};

export type DeleteCommunicationLogsInput = {
  id: string,
};

export type DeleteDailyCasePaymentsInput = {
  id: string,
};

export type DeleteDealsInput = {
  id: string,
};

export type DeleteDocumentAuditLogsInput = {
  id: string,
};

export type DeleteDocumentTemplatesInput = {
  id: string,
};

export type DeleteExpensesInput = {
  id: string,
};

export type DeleteInwardPostsInput = {
  id: string,
};

export type DeleteLeadsInput = {
  id: string,
};

export type DeleteMeetingsInput = {
  id: string,
};

export type DeleteMessagesInput = {
  id: string,
};

export type DeleteServiceItemsInput = {
  id: string,
};

export type DeleteStaffAttendanceInput = {
  id: string,
};

export type DeleteTasksInput = {
  id: string,
};

export type DeleteUsersInput = {
  id: string,
};

export type DeleteVaultFilesInput = {
  id: string,
};

export type UpdateActivityLogsInput = {
  action?: string | null,
  created_at?: string | null,
  data?: string | null,
  details?: string | null,
  id: string,
  target_id?: string | null,
  target_type?: string | null,
  user_id?: number | null,
};

export type UpdateApprovalsInput = {
  approved_at?: string | null,
  data?: string | null,
  id: string,
  reject_reason?: string | null,
  rejected_at?: string | null,
  status?: string | null,
};

export type UpdateBillingsInput = {
  amount?: string | null,
  authorities?: string | null,
  category?: string | null,
  client_name?: string | null,
  data?: string | null,
  date?: string | null,
  id: string,
  invoice_no?: string | null,
  payment_received?: boolean | null,
  status?: string | null,
  type?: string | null,
};

export type UpdateCasesInput = {
  case_number?: string | null,
  client_id?: number | null,
  court_details?: string | null,
  data?: string | null,
  id: string,
  next_hearing_date?: string | null,
  status?: string | null,
  title?: string | null,
};

export type UpdateChamberDocumentsInput = {
  category?: string | null,
  data?: string | null,
  file_path?: string | null,
  id: string,
  title?: string | null,
  uploaded_by?: number | null,
  version?: number | null,
};

export type UpdateChatMessagesInput = {
  data?: string | null,
  id: string,
  message?: string | null,
  receiver?: string | null,
  sender?: string | null,
  timestamp?: string | null,
};

export type UpdateChecklistsInput = {
  assigned_to?: string | null,
  data?: string | null,
  description?: string | null,
  id: string,
  status?: string | null,
  title?: string | null,
};

export type UpdateClientDocumentsInput = {
  client_id?: number | null,
  data?: string | null,
  file_path?: string | null,
  id: string,
  is_signed?: boolean | null,
  title?: string | null,
  uploaded_by?: number | null,
};

export type UpdateClientsInput = {
  address?: string | null,
  balance_due?: string | null,
  data?: string | null,
  email?: string | null,
  id: string,
  name?: string | null,
  phone?: string | null,
  type_of_work?: string | null,
};

export type UpdateCommunicationLogsInput = {
  client_id?: string | null,
  data?: string | null,
  date?: string | null,
  id: string,
  medium?: string | null,
  notes?: string | null,
};

export type UpdateDailyCasePaymentsInput = {
  amount?: string | null,
  case_id?: number | null,
  data?: string | null,
  id: string,
  payment_date?: string | null,
  payment_mode?: string | null,
  received_by?: number | null,
  remarks?: string | null,
};

export type UpdateDealsInput = {
  amount?: number | null,
  client_id?: number | null,
  data?: string | null,
  description?: string | null,
  id: string,
  is_won?: boolean | null,
  name?: string | null,
  stage?: string | null,
};

export type UpdateDocumentAuditLogsInput = {
  action?: string | null,
  data?: string | null,
  details?: string | null,
  document_id?: number | null,
  id: string,
  user_id?: number | null,
};

export type UpdateDocumentTemplatesInput = {
  data?: string | null,
  description?: string | null,
  file_path?: string | null,
  id: string,
  name?: string | null,
};

export type UpdateExpensesInput = {
  amount?: string | null,
  category?: string | null,
  data?: string | null,
  date?: string | null,
  description?: string | null,
  id: string,
  title?: string | null,
};

export type UpdateInwardPostsInput = {
  assigned_to?: number | null,
  data?: string | null,
  id: string,
  received_date?: string | null,
  sender?: string | null,
  status?: string | null,
  subject?: string | null,
};

export type UpdateLeadsInput = {
  data?: string | null,
  email?: string | null,
  id: string,
  name?: string | null,
  phone?: string | null,
  source?: string | null,
  status?: string | null,
};

export type UpdateMeetingsInput = {
  attendees?: string | null,
  data?: string | null,
  id: string,
  location?: string | null,
  meeting_date?: string | null,
  title?: string | null,
};

export type UpdateMessagesInput = {
  content?: string | null,
  data?: string | null,
  id: string,
  is_read?: boolean | null,
  receiver_id?: number | null,
  sender_id?: number | null,
  sent_at?: string | null,
};

export type UpdateServiceItemsInput = {
  category?: string | null,
  data?: string | null,
  id: string,
  name?: string | null,
  price?: string | null,
};

export type UpdateStaffAttendanceInput = {
  attendance_date?: string | null,
  check_in_time?: string | null,
  check_out_time?: string | null,
  data?: string | null,
  id: string,
  user_id?: number | null,
};

export type UpdateTasksInput = {
  assigned_to?: number | null,
  data?: string | null,
  description?: string | null,
  due_date?: string | null,
  id: string,
  status?: string | null,
  title?: string | null,
};

export type UpdateUsersInput = {
  data?: string | null,
  email?: string | null,
  id: string,
  name?: string | null,
  password?: string | null,
  role?: string | null,
  username?: string | null,
};

export type UpdateVaultFilesInput = {
  data?: string | null,
  file_name?: string | null,
  id: string,
  is_encrypted?: boolean | null,
  storage_path?: string | null,
  uploaded_by?: string | null,
};

export type ModelSubscriptionActivityLogsFilterInput = {
  action?: ModelSubscriptionStringInput | null,
  and?: Array< ModelSubscriptionActivityLogsFilterInput | null > | null,
  createdAt?: ModelSubscriptionStringInput | null,
  created_at?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  details?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionActivityLogsFilterInput | null > | null,
  target_id?: ModelSubscriptionStringInput | null,
  target_type?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
  user_id?: ModelSubscriptionIntInput | null,
};

export type ModelSubscriptionStringInput = {
  beginsWith?: string | null,
  between?: Array< string | null > | null,
  contains?: string | null,
  eq?: string | null,
  ge?: string | null,
  gt?: string | null,
  in?: Array< string | null > | null,
  le?: string | null,
  lt?: string | null,
  ne?: string | null,
  notContains?: string | null,
  notIn?: Array< string | null > | null,
};

export type ModelSubscriptionIDInput = {
  beginsWith?: string | null,
  between?: Array< string | null > | null,
  contains?: string | null,
  eq?: string | null,
  ge?: string | null,
  gt?: string | null,
  in?: Array< string | null > | null,
  le?: string | null,
  lt?: string | null,
  ne?: string | null,
  notContains?: string | null,
  notIn?: Array< string | null > | null,
};

export type ModelSubscriptionIntInput = {
  between?: Array< number | null > | null,
  eq?: number | null,
  ge?: number | null,
  gt?: number | null,
  in?: Array< number | null > | null,
  le?: number | null,
  lt?: number | null,
  ne?: number | null,
  notIn?: Array< number | null > | null,
};

export type ModelSubscriptionApprovalsFilterInput = {
  and?: Array< ModelSubscriptionApprovalsFilterInput | null > | null,
  approved_at?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionApprovalsFilterInput | null > | null,
  reject_reason?: ModelSubscriptionStringInput | null,
  rejected_at?: ModelSubscriptionStringInput | null,
  status?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionBillingsFilterInput = {
  amount?: ModelSubscriptionStringInput | null,
  and?: Array< ModelSubscriptionBillingsFilterInput | null > | null,
  authorities?: ModelSubscriptionStringInput | null,
  category?: ModelSubscriptionStringInput | null,
  client_name?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  date?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  invoice_no?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionBillingsFilterInput | null > | null,
  payment_received?: ModelSubscriptionBooleanInput | null,
  status?: ModelSubscriptionStringInput | null,
  type?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionBooleanInput = {
  eq?: boolean | null,
  ne?: boolean | null,
};

export type ModelSubscriptionCasesFilterInput = {
  and?: Array< ModelSubscriptionCasesFilterInput | null > | null,
  case_number?: ModelSubscriptionStringInput | null,
  client_id?: ModelSubscriptionIntInput | null,
  court_details?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  next_hearing_date?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionCasesFilterInput | null > | null,
  status?: ModelSubscriptionStringInput | null,
  title?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionChamberDocumentsFilterInput = {
  and?: Array< ModelSubscriptionChamberDocumentsFilterInput | null > | null,
  category?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  file_path?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionChamberDocumentsFilterInput | null > | null,
  title?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
  uploaded_by?: ModelSubscriptionIntInput | null,
  version?: ModelSubscriptionIntInput | null,
};

export type ModelSubscriptionChatMessagesFilterInput = {
  and?: Array< ModelSubscriptionChatMessagesFilterInput | null > | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  message?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionChatMessagesFilterInput | null > | null,
  receiver?: ModelSubscriptionStringInput | null,
  sender?: ModelSubscriptionStringInput | null,
  timestamp?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionChecklistsFilterInput = {
  and?: Array< ModelSubscriptionChecklistsFilterInput | null > | null,
  assigned_to?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  description?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionChecklistsFilterInput | null > | null,
  status?: ModelSubscriptionStringInput | null,
  title?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionClientDocumentsFilterInput = {
  and?: Array< ModelSubscriptionClientDocumentsFilterInput | null > | null,
  client_id?: ModelSubscriptionIntInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  file_path?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  is_signed?: ModelSubscriptionBooleanInput | null,
  or?: Array< ModelSubscriptionClientDocumentsFilterInput | null > | null,
  title?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
  uploaded_by?: ModelSubscriptionIntInput | null,
};

export type ModelSubscriptionClientsFilterInput = {
  address?: ModelSubscriptionStringInput | null,
  and?: Array< ModelSubscriptionClientsFilterInput | null > | null,
  balance_due?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  email?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  name?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionClientsFilterInput | null > | null,
  phone?: ModelSubscriptionStringInput | null,
  type_of_work?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionCommunicationLogsFilterInput = {
  and?: Array< ModelSubscriptionCommunicationLogsFilterInput | null > | null,
  client_id?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  date?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  medium?: ModelSubscriptionStringInput | null,
  notes?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionCommunicationLogsFilterInput | null > | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionDailyCasePaymentsFilterInput = {
  amount?: ModelSubscriptionStringInput | null,
  and?: Array< ModelSubscriptionDailyCasePaymentsFilterInput | null > | null,
  case_id?: ModelSubscriptionIntInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionDailyCasePaymentsFilterInput | null > | null,
  payment_date?: ModelSubscriptionStringInput | null,
  payment_mode?: ModelSubscriptionStringInput | null,
  received_by?: ModelSubscriptionIntInput | null,
  remarks?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionDealsFilterInput = {
  amount?: ModelSubscriptionFloatInput | null,
  and?: Array< ModelSubscriptionDealsFilterInput | null > | null,
  client_id?: ModelSubscriptionIntInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  description?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  is_won?: ModelSubscriptionBooleanInput | null,
  name?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionDealsFilterInput | null > | null,
  stage?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionFloatInput = {
  between?: Array< number | null > | null,
  eq?: number | null,
  ge?: number | null,
  gt?: number | null,
  in?: Array< number | null > | null,
  le?: number | null,
  lt?: number | null,
  ne?: number | null,
  notIn?: Array< number | null > | null,
};

export type ModelSubscriptionDocumentAuditLogsFilterInput = {
  action?: ModelSubscriptionStringInput | null,
  and?: Array< ModelSubscriptionDocumentAuditLogsFilterInput | null > | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  details?: ModelSubscriptionStringInput | null,
  document_id?: ModelSubscriptionIntInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionDocumentAuditLogsFilterInput | null > | null,
  updatedAt?: ModelSubscriptionStringInput | null,
  user_id?: ModelSubscriptionIntInput | null,
};

export type ModelSubscriptionDocumentTemplatesFilterInput = {
  and?: Array< ModelSubscriptionDocumentTemplatesFilterInput | null > | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  description?: ModelSubscriptionStringInput | null,
  file_path?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  name?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionDocumentTemplatesFilterInput | null > | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionExpensesFilterInput = {
  amount?: ModelSubscriptionStringInput | null,
  and?: Array< ModelSubscriptionExpensesFilterInput | null > | null,
  category?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  date?: ModelSubscriptionStringInput | null,
  description?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionExpensesFilterInput | null > | null,
  title?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionInwardPostsFilterInput = {
  and?: Array< ModelSubscriptionInwardPostsFilterInput | null > | null,
  assigned_to?: ModelSubscriptionIntInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionInwardPostsFilterInput | null > | null,
  received_date?: ModelSubscriptionStringInput | null,
  sender?: ModelSubscriptionStringInput | null,
  status?: ModelSubscriptionStringInput | null,
  subject?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionLeadsFilterInput = {
  and?: Array< ModelSubscriptionLeadsFilterInput | null > | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  email?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  name?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionLeadsFilterInput | null > | null,
  phone?: ModelSubscriptionStringInput | null,
  source?: ModelSubscriptionStringInput | null,
  status?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionMeetingsFilterInput = {
  and?: Array< ModelSubscriptionMeetingsFilterInput | null > | null,
  attendees?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  location?: ModelSubscriptionStringInput | null,
  meeting_date?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionMeetingsFilterInput | null > | null,
  title?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionMessagesFilterInput = {
  and?: Array< ModelSubscriptionMessagesFilterInput | null > | null,
  content?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  is_read?: ModelSubscriptionBooleanInput | null,
  or?: Array< ModelSubscriptionMessagesFilterInput | null > | null,
  receiver_id?: ModelSubscriptionIntInput | null,
  sender_id?: ModelSubscriptionIntInput | null,
  sent_at?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionServiceItemsFilterInput = {
  and?: Array< ModelSubscriptionServiceItemsFilterInput | null > | null,
  category?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  name?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionServiceItemsFilterInput | null > | null,
  price?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionStaffAttendanceFilterInput = {
  and?: Array< ModelSubscriptionStaffAttendanceFilterInput | null > | null,
  attendance_date?: ModelSubscriptionStringInput | null,
  check_in_time?: ModelSubscriptionStringInput | null,
  check_out_time?: ModelSubscriptionStringInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionStaffAttendanceFilterInput | null > | null,
  updatedAt?: ModelSubscriptionStringInput | null,
  user_id?: ModelSubscriptionIntInput | null,
};

export type ModelSubscriptionTasksFilterInput = {
  and?: Array< ModelSubscriptionTasksFilterInput | null > | null,
  assigned_to?: ModelSubscriptionIntInput | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  description?: ModelSubscriptionStringInput | null,
  due_date?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  or?: Array< ModelSubscriptionTasksFilterInput | null > | null,
  status?: ModelSubscriptionStringInput | null,
  title?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionUsersFilterInput = {
  and?: Array< ModelSubscriptionUsersFilterInput | null > | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  email?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  name?: ModelSubscriptionStringInput | null,
  or?: Array< ModelSubscriptionUsersFilterInput | null > | null,
  password?: ModelSubscriptionStringInput | null,
  role?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
  username?: ModelSubscriptionStringInput | null,
};

export type ModelSubscriptionVaultFilesFilterInput = {
  and?: Array< ModelSubscriptionVaultFilesFilterInput | null > | null,
  createdAt?: ModelSubscriptionStringInput | null,
  data?: ModelSubscriptionStringInput | null,
  file_name?: ModelSubscriptionStringInput | null,
  id?: ModelSubscriptionIDInput | null,
  is_encrypted?: ModelSubscriptionBooleanInput | null,
  or?: Array< ModelSubscriptionVaultFilesFilterInput | null > | null,
  storage_path?: ModelSubscriptionStringInput | null,
  updatedAt?: ModelSubscriptionStringInput | null,
  uploaded_by?: ModelSubscriptionStringInput | null,
};

export type GetActivityLogsQueryVariables = {
  id: string,
};

export type GetActivityLogsQuery = {
  getActivityLogs?:  {
    __typename: "ActivityLogs",
    action?: string | null,
    createdAt: string,
    created_at?: string | null,
    data?: string | null,
    details?: string | null,
    id: string,
    target_id?: string | null,
    target_type?: string | null,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type GetApprovalsQueryVariables = {
  id: string,
};

export type GetApprovalsQuery = {
  getApprovals?:  {
    __typename: "Approvals",
    approved_at?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    reject_reason?: string | null,
    rejected_at?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type GetBillingsQueryVariables = {
  id: string,
};

export type GetBillingsQuery = {
  getBillings?:  {
    __typename: "Billings",
    amount?: string | null,
    authorities?: string | null,
    category?: string | null,
    client_name?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    invoice_no?: string | null,
    payment_received?: boolean | null,
    status?: string | null,
    type?: string | null,
    updatedAt: string,
  } | null,
};

export type GetCasesQueryVariables = {
  id: string,
};

export type GetCasesQuery = {
  getCases?:  {
    __typename: "Cases",
    case_number?: string | null,
    client_id?: number | null,
    court_details?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    next_hearing_date?: string | null,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type GetChamberDocumentsQueryVariables = {
  id: string,
};

export type GetChamberDocumentsQuery = {
  getChamberDocuments?:  {
    __typename: "ChamberDocuments",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
    version?: number | null,
  } | null,
};

export type GetChatMessagesQueryVariables = {
  id: string,
};

export type GetChatMessagesQuery = {
  getChatMessages?:  {
    __typename: "ChatMessages",
    createdAt: string,
    data?: string | null,
    id: string,
    message?: string | null,
    receiver?: string | null,
    sender?: string | null,
    timestamp?: string | null,
    updatedAt: string,
  } | null,
};

export type GetChecklistsQueryVariables = {
  id: string,
};

export type GetChecklistsQuery = {
  getChecklists?:  {
    __typename: "Checklists",
    assigned_to?: string | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type GetClientDocumentsQueryVariables = {
  id: string,
};

export type GetClientDocumentsQuery = {
  getClientDocuments?:  {
    __typename: "ClientDocuments",
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    is_signed?: boolean | null,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
  } | null,
};

export type GetClientsQueryVariables = {
  id: string,
};

export type GetClientsQuery = {
  getClients?:  {
    __typename: "Clients",
    address?: string | null,
    balance_due?: string | null,
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    type_of_work?: string | null,
    updatedAt: string,
  } | null,
};

export type GetCommunicationLogsQueryVariables = {
  id: string,
};

export type GetCommunicationLogsQuery = {
  getCommunicationLogs?:  {
    __typename: "CommunicationLogs",
    client_id?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    medium?: string | null,
    notes?: string | null,
    updatedAt: string,
  } | null,
};

export type GetDailyCasePaymentsQueryVariables = {
  id: string,
};

export type GetDailyCasePaymentsQuery = {
  getDailyCasePayments?:  {
    __typename: "DailyCasePayments",
    amount?: string | null,
    case_id?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    payment_date?: string | null,
    payment_mode?: string | null,
    received_by?: number | null,
    remarks?: string | null,
    updatedAt: string,
  } | null,
};

export type GetDealsQueryVariables = {
  id: string,
};

export type GetDealsQuery = {
  getDeals?:  {
    __typename: "Deals",
    amount?: number | null,
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    is_won?: boolean | null,
    name?: string | null,
    stage?: string | null,
    updatedAt: string,
  } | null,
};

export type GetDocumentAuditLogsQueryVariables = {
  id: string,
};

export type GetDocumentAuditLogsQuery = {
  getDocumentAuditLogs?:  {
    __typename: "DocumentAuditLogs",
    action?: string | null,
    createdAt: string,
    data?: string | null,
    details?: string | null,
    document_id?: number | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type GetDocumentTemplatesQueryVariables = {
  id: string,
};

export type GetDocumentTemplatesQuery = {
  getDocumentTemplates?:  {
    __typename: "DocumentTemplates",
    createdAt: string,
    data?: string | null,
    description?: string | null,
    file_path?: string | null,
    id: string,
    name?: string | null,
    updatedAt: string,
  } | null,
};

export type GetExpensesQueryVariables = {
  id: string,
};

export type GetExpensesQuery = {
  getExpenses?:  {
    __typename: "Expenses",
    amount?: string | null,
    category?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    description?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type GetInwardPostsQueryVariables = {
  id: string,
};

export type GetInwardPostsQuery = {
  getInwardPosts?:  {
    __typename: "InwardPosts",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    received_date?: string | null,
    sender?: string | null,
    status?: string | null,
    subject?: string | null,
    updatedAt: string,
  } | null,
};

export type GetLeadsQueryVariables = {
  id: string,
};

export type GetLeadsQuery = {
  getLeads?:  {
    __typename: "Leads",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    source?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type GetMeetingsQueryVariables = {
  id: string,
};

export type GetMeetingsQuery = {
  getMeetings?:  {
    __typename: "Meetings",
    attendees?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    location?: string | null,
    meeting_date?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type GetMessagesQueryVariables = {
  id: string,
};

export type GetMessagesQuery = {
  getMessages?:  {
    __typename: "Messages",
    content?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    is_read?: boolean | null,
    receiver_id?: number | null,
    sender_id?: number | null,
    sent_at?: string | null,
    updatedAt: string,
  } | null,
};

export type GetServiceItemsQueryVariables = {
  id: string,
};

export type GetServiceItemsQuery = {
  getServiceItems?:  {
    __typename: "ServiceItems",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    name?: string | null,
    price?: string | null,
    updatedAt: string,
  } | null,
};

export type GetStaffAttendanceQueryVariables = {
  id: string,
};

export type GetStaffAttendanceQuery = {
  getStaffAttendance?:  {
    __typename: "StaffAttendance",
    attendance_date?: string | null,
    check_in_time?: string | null,
    check_out_time?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type GetTasksQueryVariables = {
  id: string,
};

export type GetTasksQuery = {
  getTasks?:  {
    __typename: "Tasks",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    due_date?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type GetUsersQueryVariables = {
  id: string,
};

export type GetUsersQuery = {
  getUsers?:  {
    __typename: "Users",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    password?: string | null,
    role?: string | null,
    updatedAt: string,
    username?: string | null,
  } | null,
};

export type GetVaultFilesQueryVariables = {
  id: string,
};

export type GetVaultFilesQuery = {
  getVaultFiles?:  {
    __typename: "VaultFiles",
    createdAt: string,
    data?: string | null,
    file_name?: string | null,
    id: string,
    is_encrypted?: boolean | null,
    storage_path?: string | null,
    updatedAt: string,
    uploaded_by?: string | null,
  } | null,
};

export type ListActivityLogsQueryVariables = {
  filter?: ModelActivityLogsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListActivityLogsQuery = {
  listActivityLogs?:  {
    __typename: "ModelActivityLogsConnection",
    items:  Array< {
      __typename: "ActivityLogs",
      action?: string | null,
      createdAt: string,
      created_at?: string | null,
      data?: string | null,
      details?: string | null,
      id: string,
      target_id?: string | null,
      target_type?: string | null,
      updatedAt: string,
      user_id?: number | null,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListApprovalsQueryVariables = {
  filter?: ModelApprovalsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListApprovalsQuery = {
  listApprovals?:  {
    __typename: "ModelApprovalsConnection",
    items:  Array< {
      __typename: "Approvals",
      approved_at?: string | null,
      createdAt: string,
      data?: string | null,
      id: string,
      reject_reason?: string | null,
      rejected_at?: string | null,
      status?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListBillingsQueryVariables = {
  filter?: ModelBillingsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListBillingsQuery = {
  listBillings?:  {
    __typename: "ModelBillingsConnection",
    items:  Array< {
      __typename: "Billings",
      amount?: string | null,
      authorities?: string | null,
      category?: string | null,
      client_name?: string | null,
      createdAt: string,
      data?: string | null,
      date?: string | null,
      id: string,
      invoice_no?: string | null,
      payment_received?: boolean | null,
      status?: string | null,
      type?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListCasesQueryVariables = {
  filter?: ModelCasesFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListCasesQuery = {
  listCases?:  {
    __typename: "ModelCasesConnection",
    items:  Array< {
      __typename: "Cases",
      case_number?: string | null,
      client_id?: number | null,
      court_details?: string | null,
      createdAt: string,
      data?: string | null,
      id: string,
      next_hearing_date?: string | null,
      status?: string | null,
      title?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListChamberDocumentsQueryVariables = {
  filter?: ModelChamberDocumentsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListChamberDocumentsQuery = {
  listChamberDocuments?:  {
    __typename: "ModelChamberDocumentsConnection",
    items:  Array< {
      __typename: "ChamberDocuments",
      category?: string | null,
      createdAt: string,
      data?: string | null,
      file_path?: string | null,
      id: string,
      title?: string | null,
      updatedAt: string,
      uploaded_by?: number | null,
      version?: number | null,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListChatMessagesQueryVariables = {
  filter?: ModelChatMessagesFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListChatMessagesQuery = {
  listChatMessages?:  {
    __typename: "ModelChatMessagesConnection",
    items:  Array< {
      __typename: "ChatMessages",
      createdAt: string,
      data?: string | null,
      id: string,
      message?: string | null,
      receiver?: string | null,
      sender?: string | null,
      timestamp?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListChecklistsQueryVariables = {
  filter?: ModelChecklistsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListChecklistsQuery = {
  listChecklists?:  {
    __typename: "ModelChecklistsConnection",
    items:  Array< {
      __typename: "Checklists",
      assigned_to?: string | null,
      createdAt: string,
      data?: string | null,
      description?: string | null,
      id: string,
      status?: string | null,
      title?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListClientDocumentsQueryVariables = {
  filter?: ModelClientDocumentsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListClientDocumentsQuery = {
  listClientDocuments?:  {
    __typename: "ModelClientDocumentsConnection",
    items:  Array< {
      __typename: "ClientDocuments",
      client_id?: number | null,
      createdAt: string,
      data?: string | null,
      file_path?: string | null,
      id: string,
      is_signed?: boolean | null,
      title?: string | null,
      updatedAt: string,
      uploaded_by?: number | null,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListClientsQueryVariables = {
  filter?: ModelClientsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListClientsQuery = {
  listClients?:  {
    __typename: "ModelClientsConnection",
    items:  Array< {
      __typename: "Clients",
      address?: string | null,
      balance_due?: string | null,
      createdAt: string,
      data?: string | null,
      email?: string | null,
      id: string,
      name?: string | null,
      phone?: string | null,
      type_of_work?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListCommunicationLogsQueryVariables = {
  filter?: ModelCommunicationLogsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListCommunicationLogsQuery = {
  listCommunicationLogs?:  {
    __typename: "ModelCommunicationLogsConnection",
    items:  Array< {
      __typename: "CommunicationLogs",
      client_id?: string | null,
      createdAt: string,
      data?: string | null,
      date?: string | null,
      id: string,
      medium?: string | null,
      notes?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListDailyCasePaymentsQueryVariables = {
  filter?: ModelDailyCasePaymentsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListDailyCasePaymentsQuery = {
  listDailyCasePayments?:  {
    __typename: "ModelDailyCasePaymentsConnection",
    items:  Array< {
      __typename: "DailyCasePayments",
      amount?: string | null,
      case_id?: number | null,
      createdAt: string,
      data?: string | null,
      id: string,
      payment_date?: string | null,
      payment_mode?: string | null,
      received_by?: number | null,
      remarks?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListDealsQueryVariables = {
  filter?: ModelDealsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListDealsQuery = {
  listDeals?:  {
    __typename: "ModelDealsConnection",
    items:  Array< {
      __typename: "Deals",
      amount?: number | null,
      client_id?: number | null,
      createdAt: string,
      data?: string | null,
      description?: string | null,
      id: string,
      is_won?: boolean | null,
      name?: string | null,
      stage?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListDocumentAuditLogsQueryVariables = {
  filter?: ModelDocumentAuditLogsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListDocumentAuditLogsQuery = {
  listDocumentAuditLogs?:  {
    __typename: "ModelDocumentAuditLogsConnection",
    items:  Array< {
      __typename: "DocumentAuditLogs",
      action?: string | null,
      createdAt: string,
      data?: string | null,
      details?: string | null,
      document_id?: number | null,
      id: string,
      updatedAt: string,
      user_id?: number | null,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListDocumentTemplatesQueryVariables = {
  filter?: ModelDocumentTemplatesFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListDocumentTemplatesQuery = {
  listDocumentTemplates?:  {
    __typename: "ModelDocumentTemplatesConnection",
    items:  Array< {
      __typename: "DocumentTemplates",
      createdAt: string,
      data?: string | null,
      description?: string | null,
      file_path?: string | null,
      id: string,
      name?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListExpensesQueryVariables = {
  filter?: ModelExpensesFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListExpensesQuery = {
  listExpenses?:  {
    __typename: "ModelExpensesConnection",
    items:  Array< {
      __typename: "Expenses",
      amount?: string | null,
      category?: string | null,
      createdAt: string,
      data?: string | null,
      date?: string | null,
      description?: string | null,
      id: string,
      title?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListInwardPostsQueryVariables = {
  filter?: ModelInwardPostsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListInwardPostsQuery = {
  listInwardPosts?:  {
    __typename: "ModelInwardPostsConnection",
    items:  Array< {
      __typename: "InwardPosts",
      assigned_to?: number | null,
      createdAt: string,
      data?: string | null,
      id: string,
      received_date?: string | null,
      sender?: string | null,
      status?: string | null,
      subject?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListLeadsQueryVariables = {
  filter?: ModelLeadsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListLeadsQuery = {
  listLeads?:  {
    __typename: "ModelLeadsConnection",
    items:  Array< {
      __typename: "Leads",
      createdAt: string,
      data?: string | null,
      email?: string | null,
      id: string,
      name?: string | null,
      phone?: string | null,
      source?: string | null,
      status?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListMeetingsQueryVariables = {
  filter?: ModelMeetingsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListMeetingsQuery = {
  listMeetings?:  {
    __typename: "ModelMeetingsConnection",
    items:  Array< {
      __typename: "Meetings",
      attendees?: string | null,
      createdAt: string,
      data?: string | null,
      id: string,
      location?: string | null,
      meeting_date?: string | null,
      title?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListMessagesQueryVariables = {
  filter?: ModelMessagesFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListMessagesQuery = {
  listMessages?:  {
    __typename: "ModelMessagesConnection",
    items:  Array< {
      __typename: "Messages",
      content?: string | null,
      createdAt: string,
      data?: string | null,
      id: string,
      is_read?: boolean | null,
      receiver_id?: number | null,
      sender_id?: number | null,
      sent_at?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListServiceItemsQueryVariables = {
  filter?: ModelServiceItemsFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListServiceItemsQuery = {
  listServiceItems?:  {
    __typename: "ModelServiceItemsConnection",
    items:  Array< {
      __typename: "ServiceItems",
      category?: string | null,
      createdAt: string,
      data?: string | null,
      id: string,
      name?: string | null,
      price?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListStaffAttendancesQueryVariables = {
  filter?: ModelStaffAttendanceFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListStaffAttendancesQuery = {
  listStaffAttendances?:  {
    __typename: "ModelStaffAttendanceConnection",
    items:  Array< {
      __typename: "StaffAttendance",
      attendance_date?: string | null,
      check_in_time?: string | null,
      check_out_time?: string | null,
      createdAt: string,
      data?: string | null,
      id: string,
      updatedAt: string,
      user_id?: number | null,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListTasksQueryVariables = {
  filter?: ModelTasksFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListTasksQuery = {
  listTasks?:  {
    __typename: "ModelTasksConnection",
    items:  Array< {
      __typename: "Tasks",
      assigned_to?: number | null,
      createdAt: string,
      data?: string | null,
      description?: string | null,
      due_date?: string | null,
      id: string,
      status?: string | null,
      title?: string | null,
      updatedAt: string,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListUsersQueryVariables = {
  filter?: ModelUsersFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListUsersQuery = {
  listUsers?:  {
    __typename: "ModelUsersConnection",
    items:  Array< {
      __typename: "Users",
      createdAt: string,
      data?: string | null,
      email?: string | null,
      id: string,
      name?: string | null,
      password?: string | null,
      role?: string | null,
      updatedAt: string,
      username?: string | null,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type ListVaultFilesQueryVariables = {
  filter?: ModelVaultFilesFilterInput | null,
  limit?: number | null,
  nextToken?: string | null,
};

export type ListVaultFilesQuery = {
  listVaultFiles?:  {
    __typename: "ModelVaultFilesConnection",
    items:  Array< {
      __typename: "VaultFiles",
      createdAt: string,
      data?: string | null,
      file_name?: string | null,
      id: string,
      is_encrypted?: boolean | null,
      storage_path?: string | null,
      updatedAt: string,
      uploaded_by?: string | null,
    } | null >,
    nextToken?: string | null,
  } | null,
};

export type CreateActivityLogsMutationVariables = {
  condition?: ModelActivityLogsConditionInput | null,
  input: CreateActivityLogsInput,
};

export type CreateActivityLogsMutation = {
  createActivityLogs?:  {
    __typename: "ActivityLogs",
    action?: string | null,
    createdAt: string,
    created_at?: string | null,
    data?: string | null,
    details?: string | null,
    id: string,
    target_id?: string | null,
    target_type?: string | null,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type CreateApprovalsMutationVariables = {
  condition?: ModelApprovalsConditionInput | null,
  input: CreateApprovalsInput,
};

export type CreateApprovalsMutation = {
  createApprovals?:  {
    __typename: "Approvals",
    approved_at?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    reject_reason?: string | null,
    rejected_at?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateBillingsMutationVariables = {
  condition?: ModelBillingsConditionInput | null,
  input: CreateBillingsInput,
};

export type CreateBillingsMutation = {
  createBillings?:  {
    __typename: "Billings",
    amount?: string | null,
    authorities?: string | null,
    category?: string | null,
    client_name?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    invoice_no?: string | null,
    payment_received?: boolean | null,
    status?: string | null,
    type?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateCasesMutationVariables = {
  condition?: ModelCasesConditionInput | null,
  input: CreateCasesInput,
};

export type CreateCasesMutation = {
  createCases?:  {
    __typename: "Cases",
    case_number?: string | null,
    client_id?: number | null,
    court_details?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    next_hearing_date?: string | null,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateChamberDocumentsMutationVariables = {
  condition?: ModelChamberDocumentsConditionInput | null,
  input: CreateChamberDocumentsInput,
};

export type CreateChamberDocumentsMutation = {
  createChamberDocuments?:  {
    __typename: "ChamberDocuments",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
    version?: number | null,
  } | null,
};

export type CreateChatMessagesMutationVariables = {
  condition?: ModelChatMessagesConditionInput | null,
  input: CreateChatMessagesInput,
};

export type CreateChatMessagesMutation = {
  createChatMessages?:  {
    __typename: "ChatMessages",
    createdAt: string,
    data?: string | null,
    id: string,
    message?: string | null,
    receiver?: string | null,
    sender?: string | null,
    timestamp?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateChecklistsMutationVariables = {
  condition?: ModelChecklistsConditionInput | null,
  input: CreateChecklistsInput,
};

export type CreateChecklistsMutation = {
  createChecklists?:  {
    __typename: "Checklists",
    assigned_to?: string | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateClientDocumentsMutationVariables = {
  condition?: ModelClientDocumentsConditionInput | null,
  input: CreateClientDocumentsInput,
};

export type CreateClientDocumentsMutation = {
  createClientDocuments?:  {
    __typename: "ClientDocuments",
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    is_signed?: boolean | null,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
  } | null,
};

export type CreateClientsMutationVariables = {
  condition?: ModelClientsConditionInput | null,
  input: CreateClientsInput,
};

export type CreateClientsMutation = {
  createClients?:  {
    __typename: "Clients",
    address?: string | null,
    balance_due?: string | null,
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    type_of_work?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateCommunicationLogsMutationVariables = {
  condition?: ModelCommunicationLogsConditionInput | null,
  input: CreateCommunicationLogsInput,
};

export type CreateCommunicationLogsMutation = {
  createCommunicationLogs?:  {
    __typename: "CommunicationLogs",
    client_id?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    medium?: string | null,
    notes?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateDailyCasePaymentsMutationVariables = {
  condition?: ModelDailyCasePaymentsConditionInput | null,
  input: CreateDailyCasePaymentsInput,
};

export type CreateDailyCasePaymentsMutation = {
  createDailyCasePayments?:  {
    __typename: "DailyCasePayments",
    amount?: string | null,
    case_id?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    payment_date?: string | null,
    payment_mode?: string | null,
    received_by?: number | null,
    remarks?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateDealsMutationVariables = {
  condition?: ModelDealsConditionInput | null,
  input: CreateDealsInput,
};

export type CreateDealsMutation = {
  createDeals?:  {
    __typename: "Deals",
    amount?: number | null,
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    is_won?: boolean | null,
    name?: string | null,
    stage?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateDocumentAuditLogsMutationVariables = {
  condition?: ModelDocumentAuditLogsConditionInput | null,
  input: CreateDocumentAuditLogsInput,
};

export type CreateDocumentAuditLogsMutation = {
  createDocumentAuditLogs?:  {
    __typename: "DocumentAuditLogs",
    action?: string | null,
    createdAt: string,
    data?: string | null,
    details?: string | null,
    document_id?: number | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type CreateDocumentTemplatesMutationVariables = {
  condition?: ModelDocumentTemplatesConditionInput | null,
  input: CreateDocumentTemplatesInput,
};

export type CreateDocumentTemplatesMutation = {
  createDocumentTemplates?:  {
    __typename: "DocumentTemplates",
    createdAt: string,
    data?: string | null,
    description?: string | null,
    file_path?: string | null,
    id: string,
    name?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateExpensesMutationVariables = {
  condition?: ModelExpensesConditionInput | null,
  input: CreateExpensesInput,
};

export type CreateExpensesMutation = {
  createExpenses?:  {
    __typename: "Expenses",
    amount?: string | null,
    category?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    description?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateInwardPostsMutationVariables = {
  condition?: ModelInwardPostsConditionInput | null,
  input: CreateInwardPostsInput,
};

export type CreateInwardPostsMutation = {
  createInwardPosts?:  {
    __typename: "InwardPosts",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    received_date?: string | null,
    sender?: string | null,
    status?: string | null,
    subject?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateLeadsMutationVariables = {
  condition?: ModelLeadsConditionInput | null,
  input: CreateLeadsInput,
};

export type CreateLeadsMutation = {
  createLeads?:  {
    __typename: "Leads",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    source?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateMeetingsMutationVariables = {
  condition?: ModelMeetingsConditionInput | null,
  input: CreateMeetingsInput,
};

export type CreateMeetingsMutation = {
  createMeetings?:  {
    __typename: "Meetings",
    attendees?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    location?: string | null,
    meeting_date?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateMessagesMutationVariables = {
  condition?: ModelMessagesConditionInput | null,
  input: CreateMessagesInput,
};

export type CreateMessagesMutation = {
  createMessages?:  {
    __typename: "Messages",
    content?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    is_read?: boolean | null,
    receiver_id?: number | null,
    sender_id?: number | null,
    sent_at?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateServiceItemsMutationVariables = {
  condition?: ModelServiceItemsConditionInput | null,
  input: CreateServiceItemsInput,
};

export type CreateServiceItemsMutation = {
  createServiceItems?:  {
    __typename: "ServiceItems",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    name?: string | null,
    price?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateStaffAttendanceMutationVariables = {
  condition?: ModelStaffAttendanceConditionInput | null,
  input: CreateStaffAttendanceInput,
};

export type CreateStaffAttendanceMutation = {
  createStaffAttendance?:  {
    __typename: "StaffAttendance",
    attendance_date?: string | null,
    check_in_time?: string | null,
    check_out_time?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type CreateTasksMutationVariables = {
  condition?: ModelTasksConditionInput | null,
  input: CreateTasksInput,
};

export type CreateTasksMutation = {
  createTasks?:  {
    __typename: "Tasks",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    due_date?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type CreateUsersMutationVariables = {
  condition?: ModelUsersConditionInput | null,
  input: CreateUsersInput,
};

export type CreateUsersMutation = {
  createUsers?:  {
    __typename: "Users",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    password?: string | null,
    role?: string | null,
    updatedAt: string,
    username?: string | null,
  } | null,
};

export type CreateVaultFilesMutationVariables = {
  condition?: ModelVaultFilesConditionInput | null,
  input: CreateVaultFilesInput,
};

export type CreateVaultFilesMutation = {
  createVaultFiles?:  {
    __typename: "VaultFiles",
    createdAt: string,
    data?: string | null,
    file_name?: string | null,
    id: string,
    is_encrypted?: boolean | null,
    storage_path?: string | null,
    updatedAt: string,
    uploaded_by?: string | null,
  } | null,
};

export type DeleteActivityLogsMutationVariables = {
  condition?: ModelActivityLogsConditionInput | null,
  input: DeleteActivityLogsInput,
};

export type DeleteActivityLogsMutation = {
  deleteActivityLogs?:  {
    __typename: "ActivityLogs",
    action?: string | null,
    createdAt: string,
    created_at?: string | null,
    data?: string | null,
    details?: string | null,
    id: string,
    target_id?: string | null,
    target_type?: string | null,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type DeleteApprovalsMutationVariables = {
  condition?: ModelApprovalsConditionInput | null,
  input: DeleteApprovalsInput,
};

export type DeleteApprovalsMutation = {
  deleteApprovals?:  {
    __typename: "Approvals",
    approved_at?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    reject_reason?: string | null,
    rejected_at?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteBillingsMutationVariables = {
  condition?: ModelBillingsConditionInput | null,
  input: DeleteBillingsInput,
};

export type DeleteBillingsMutation = {
  deleteBillings?:  {
    __typename: "Billings",
    amount?: string | null,
    authorities?: string | null,
    category?: string | null,
    client_name?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    invoice_no?: string | null,
    payment_received?: boolean | null,
    status?: string | null,
    type?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteCasesMutationVariables = {
  condition?: ModelCasesConditionInput | null,
  input: DeleteCasesInput,
};

export type DeleteCasesMutation = {
  deleteCases?:  {
    __typename: "Cases",
    case_number?: string | null,
    client_id?: number | null,
    court_details?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    next_hearing_date?: string | null,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteChamberDocumentsMutationVariables = {
  condition?: ModelChamberDocumentsConditionInput | null,
  input: DeleteChamberDocumentsInput,
};

export type DeleteChamberDocumentsMutation = {
  deleteChamberDocuments?:  {
    __typename: "ChamberDocuments",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
    version?: number | null,
  } | null,
};

export type DeleteChatMessagesMutationVariables = {
  condition?: ModelChatMessagesConditionInput | null,
  input: DeleteChatMessagesInput,
};

export type DeleteChatMessagesMutation = {
  deleteChatMessages?:  {
    __typename: "ChatMessages",
    createdAt: string,
    data?: string | null,
    id: string,
    message?: string | null,
    receiver?: string | null,
    sender?: string | null,
    timestamp?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteChecklistsMutationVariables = {
  condition?: ModelChecklistsConditionInput | null,
  input: DeleteChecklistsInput,
};

export type DeleteChecklistsMutation = {
  deleteChecklists?:  {
    __typename: "Checklists",
    assigned_to?: string | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteClientDocumentsMutationVariables = {
  condition?: ModelClientDocumentsConditionInput | null,
  input: DeleteClientDocumentsInput,
};

export type DeleteClientDocumentsMutation = {
  deleteClientDocuments?:  {
    __typename: "ClientDocuments",
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    is_signed?: boolean | null,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
  } | null,
};

export type DeleteClientsMutationVariables = {
  condition?: ModelClientsConditionInput | null,
  input: DeleteClientsInput,
};

export type DeleteClientsMutation = {
  deleteClients?:  {
    __typename: "Clients",
    address?: string | null,
    balance_due?: string | null,
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    type_of_work?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteCommunicationLogsMutationVariables = {
  condition?: ModelCommunicationLogsConditionInput | null,
  input: DeleteCommunicationLogsInput,
};

export type DeleteCommunicationLogsMutation = {
  deleteCommunicationLogs?:  {
    __typename: "CommunicationLogs",
    client_id?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    medium?: string | null,
    notes?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteDailyCasePaymentsMutationVariables = {
  condition?: ModelDailyCasePaymentsConditionInput | null,
  input: DeleteDailyCasePaymentsInput,
};

export type DeleteDailyCasePaymentsMutation = {
  deleteDailyCasePayments?:  {
    __typename: "DailyCasePayments",
    amount?: string | null,
    case_id?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    payment_date?: string | null,
    payment_mode?: string | null,
    received_by?: number | null,
    remarks?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteDealsMutationVariables = {
  condition?: ModelDealsConditionInput | null,
  input: DeleteDealsInput,
};

export type DeleteDealsMutation = {
  deleteDeals?:  {
    __typename: "Deals",
    amount?: number | null,
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    is_won?: boolean | null,
    name?: string | null,
    stage?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteDocumentAuditLogsMutationVariables = {
  condition?: ModelDocumentAuditLogsConditionInput | null,
  input: DeleteDocumentAuditLogsInput,
};

export type DeleteDocumentAuditLogsMutation = {
  deleteDocumentAuditLogs?:  {
    __typename: "DocumentAuditLogs",
    action?: string | null,
    createdAt: string,
    data?: string | null,
    details?: string | null,
    document_id?: number | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type DeleteDocumentTemplatesMutationVariables = {
  condition?: ModelDocumentTemplatesConditionInput | null,
  input: DeleteDocumentTemplatesInput,
};

export type DeleteDocumentTemplatesMutation = {
  deleteDocumentTemplates?:  {
    __typename: "DocumentTemplates",
    createdAt: string,
    data?: string | null,
    description?: string | null,
    file_path?: string | null,
    id: string,
    name?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteExpensesMutationVariables = {
  condition?: ModelExpensesConditionInput | null,
  input: DeleteExpensesInput,
};

export type DeleteExpensesMutation = {
  deleteExpenses?:  {
    __typename: "Expenses",
    amount?: string | null,
    category?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    description?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteInwardPostsMutationVariables = {
  condition?: ModelInwardPostsConditionInput | null,
  input: DeleteInwardPostsInput,
};

export type DeleteInwardPostsMutation = {
  deleteInwardPosts?:  {
    __typename: "InwardPosts",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    received_date?: string | null,
    sender?: string | null,
    status?: string | null,
    subject?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteLeadsMutationVariables = {
  condition?: ModelLeadsConditionInput | null,
  input: DeleteLeadsInput,
};

export type DeleteLeadsMutation = {
  deleteLeads?:  {
    __typename: "Leads",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    source?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteMeetingsMutationVariables = {
  condition?: ModelMeetingsConditionInput | null,
  input: DeleteMeetingsInput,
};

export type DeleteMeetingsMutation = {
  deleteMeetings?:  {
    __typename: "Meetings",
    attendees?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    location?: string | null,
    meeting_date?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteMessagesMutationVariables = {
  condition?: ModelMessagesConditionInput | null,
  input: DeleteMessagesInput,
};

export type DeleteMessagesMutation = {
  deleteMessages?:  {
    __typename: "Messages",
    content?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    is_read?: boolean | null,
    receiver_id?: number | null,
    sender_id?: number | null,
    sent_at?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteServiceItemsMutationVariables = {
  condition?: ModelServiceItemsConditionInput | null,
  input: DeleteServiceItemsInput,
};

export type DeleteServiceItemsMutation = {
  deleteServiceItems?:  {
    __typename: "ServiceItems",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    name?: string | null,
    price?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteStaffAttendanceMutationVariables = {
  condition?: ModelStaffAttendanceConditionInput | null,
  input: DeleteStaffAttendanceInput,
};

export type DeleteStaffAttendanceMutation = {
  deleteStaffAttendance?:  {
    __typename: "StaffAttendance",
    attendance_date?: string | null,
    check_in_time?: string | null,
    check_out_time?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type DeleteTasksMutationVariables = {
  condition?: ModelTasksConditionInput | null,
  input: DeleteTasksInput,
};

export type DeleteTasksMutation = {
  deleteTasks?:  {
    __typename: "Tasks",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    due_date?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type DeleteUsersMutationVariables = {
  condition?: ModelUsersConditionInput | null,
  input: DeleteUsersInput,
};

export type DeleteUsersMutation = {
  deleteUsers?:  {
    __typename: "Users",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    password?: string | null,
    role?: string | null,
    updatedAt: string,
    username?: string | null,
  } | null,
};

export type DeleteVaultFilesMutationVariables = {
  condition?: ModelVaultFilesConditionInput | null,
  input: DeleteVaultFilesInput,
};

export type DeleteVaultFilesMutation = {
  deleteVaultFiles?:  {
    __typename: "VaultFiles",
    createdAt: string,
    data?: string | null,
    file_name?: string | null,
    id: string,
    is_encrypted?: boolean | null,
    storage_path?: string | null,
    updatedAt: string,
    uploaded_by?: string | null,
  } | null,
};

export type UpdateActivityLogsMutationVariables = {
  condition?: ModelActivityLogsConditionInput | null,
  input: UpdateActivityLogsInput,
};

export type UpdateActivityLogsMutation = {
  updateActivityLogs?:  {
    __typename: "ActivityLogs",
    action?: string | null,
    createdAt: string,
    created_at?: string | null,
    data?: string | null,
    details?: string | null,
    id: string,
    target_id?: string | null,
    target_type?: string | null,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type UpdateApprovalsMutationVariables = {
  condition?: ModelApprovalsConditionInput | null,
  input: UpdateApprovalsInput,
};

export type UpdateApprovalsMutation = {
  updateApprovals?:  {
    __typename: "Approvals",
    approved_at?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    reject_reason?: string | null,
    rejected_at?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateBillingsMutationVariables = {
  condition?: ModelBillingsConditionInput | null,
  input: UpdateBillingsInput,
};

export type UpdateBillingsMutation = {
  updateBillings?:  {
    __typename: "Billings",
    amount?: string | null,
    authorities?: string | null,
    category?: string | null,
    client_name?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    invoice_no?: string | null,
    payment_received?: boolean | null,
    status?: string | null,
    type?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateCasesMutationVariables = {
  condition?: ModelCasesConditionInput | null,
  input: UpdateCasesInput,
};

export type UpdateCasesMutation = {
  updateCases?:  {
    __typename: "Cases",
    case_number?: string | null,
    client_id?: number | null,
    court_details?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    next_hearing_date?: string | null,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateChamberDocumentsMutationVariables = {
  condition?: ModelChamberDocumentsConditionInput | null,
  input: UpdateChamberDocumentsInput,
};

export type UpdateChamberDocumentsMutation = {
  updateChamberDocuments?:  {
    __typename: "ChamberDocuments",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
    version?: number | null,
  } | null,
};

export type UpdateChatMessagesMutationVariables = {
  condition?: ModelChatMessagesConditionInput | null,
  input: UpdateChatMessagesInput,
};

export type UpdateChatMessagesMutation = {
  updateChatMessages?:  {
    __typename: "ChatMessages",
    createdAt: string,
    data?: string | null,
    id: string,
    message?: string | null,
    receiver?: string | null,
    sender?: string | null,
    timestamp?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateChecklistsMutationVariables = {
  condition?: ModelChecklistsConditionInput | null,
  input: UpdateChecklistsInput,
};

export type UpdateChecklistsMutation = {
  updateChecklists?:  {
    __typename: "Checklists",
    assigned_to?: string | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateClientDocumentsMutationVariables = {
  condition?: ModelClientDocumentsConditionInput | null,
  input: UpdateClientDocumentsInput,
};

export type UpdateClientDocumentsMutation = {
  updateClientDocuments?:  {
    __typename: "ClientDocuments",
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    is_signed?: boolean | null,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
  } | null,
};

export type UpdateClientsMutationVariables = {
  condition?: ModelClientsConditionInput | null,
  input: UpdateClientsInput,
};

export type UpdateClientsMutation = {
  updateClients?:  {
    __typename: "Clients",
    address?: string | null,
    balance_due?: string | null,
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    type_of_work?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateCommunicationLogsMutationVariables = {
  condition?: ModelCommunicationLogsConditionInput | null,
  input: UpdateCommunicationLogsInput,
};

export type UpdateCommunicationLogsMutation = {
  updateCommunicationLogs?:  {
    __typename: "CommunicationLogs",
    client_id?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    medium?: string | null,
    notes?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateDailyCasePaymentsMutationVariables = {
  condition?: ModelDailyCasePaymentsConditionInput | null,
  input: UpdateDailyCasePaymentsInput,
};

export type UpdateDailyCasePaymentsMutation = {
  updateDailyCasePayments?:  {
    __typename: "DailyCasePayments",
    amount?: string | null,
    case_id?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    payment_date?: string | null,
    payment_mode?: string | null,
    received_by?: number | null,
    remarks?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateDealsMutationVariables = {
  condition?: ModelDealsConditionInput | null,
  input: UpdateDealsInput,
};

export type UpdateDealsMutation = {
  updateDeals?:  {
    __typename: "Deals",
    amount?: number | null,
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    is_won?: boolean | null,
    name?: string | null,
    stage?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateDocumentAuditLogsMutationVariables = {
  condition?: ModelDocumentAuditLogsConditionInput | null,
  input: UpdateDocumentAuditLogsInput,
};

export type UpdateDocumentAuditLogsMutation = {
  updateDocumentAuditLogs?:  {
    __typename: "DocumentAuditLogs",
    action?: string | null,
    createdAt: string,
    data?: string | null,
    details?: string | null,
    document_id?: number | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type UpdateDocumentTemplatesMutationVariables = {
  condition?: ModelDocumentTemplatesConditionInput | null,
  input: UpdateDocumentTemplatesInput,
};

export type UpdateDocumentTemplatesMutation = {
  updateDocumentTemplates?:  {
    __typename: "DocumentTemplates",
    createdAt: string,
    data?: string | null,
    description?: string | null,
    file_path?: string | null,
    id: string,
    name?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateExpensesMutationVariables = {
  condition?: ModelExpensesConditionInput | null,
  input: UpdateExpensesInput,
};

export type UpdateExpensesMutation = {
  updateExpenses?:  {
    __typename: "Expenses",
    amount?: string | null,
    category?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    description?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateInwardPostsMutationVariables = {
  condition?: ModelInwardPostsConditionInput | null,
  input: UpdateInwardPostsInput,
};

export type UpdateInwardPostsMutation = {
  updateInwardPosts?:  {
    __typename: "InwardPosts",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    received_date?: string | null,
    sender?: string | null,
    status?: string | null,
    subject?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateLeadsMutationVariables = {
  condition?: ModelLeadsConditionInput | null,
  input: UpdateLeadsInput,
};

export type UpdateLeadsMutation = {
  updateLeads?:  {
    __typename: "Leads",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    source?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateMeetingsMutationVariables = {
  condition?: ModelMeetingsConditionInput | null,
  input: UpdateMeetingsInput,
};

export type UpdateMeetingsMutation = {
  updateMeetings?:  {
    __typename: "Meetings",
    attendees?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    location?: string | null,
    meeting_date?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateMessagesMutationVariables = {
  condition?: ModelMessagesConditionInput | null,
  input: UpdateMessagesInput,
};

export type UpdateMessagesMutation = {
  updateMessages?:  {
    __typename: "Messages",
    content?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    is_read?: boolean | null,
    receiver_id?: number | null,
    sender_id?: number | null,
    sent_at?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateServiceItemsMutationVariables = {
  condition?: ModelServiceItemsConditionInput | null,
  input: UpdateServiceItemsInput,
};

export type UpdateServiceItemsMutation = {
  updateServiceItems?:  {
    __typename: "ServiceItems",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    name?: string | null,
    price?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateStaffAttendanceMutationVariables = {
  condition?: ModelStaffAttendanceConditionInput | null,
  input: UpdateStaffAttendanceInput,
};

export type UpdateStaffAttendanceMutation = {
  updateStaffAttendance?:  {
    __typename: "StaffAttendance",
    attendance_date?: string | null,
    check_in_time?: string | null,
    check_out_time?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type UpdateTasksMutationVariables = {
  condition?: ModelTasksConditionInput | null,
  input: UpdateTasksInput,
};

export type UpdateTasksMutation = {
  updateTasks?:  {
    __typename: "Tasks",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    due_date?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type UpdateUsersMutationVariables = {
  condition?: ModelUsersConditionInput | null,
  input: UpdateUsersInput,
};

export type UpdateUsersMutation = {
  updateUsers?:  {
    __typename: "Users",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    password?: string | null,
    role?: string | null,
    updatedAt: string,
    username?: string | null,
  } | null,
};

export type UpdateVaultFilesMutationVariables = {
  condition?: ModelVaultFilesConditionInput | null,
  input: UpdateVaultFilesInput,
};

export type UpdateVaultFilesMutation = {
  updateVaultFiles?:  {
    __typename: "VaultFiles",
    createdAt: string,
    data?: string | null,
    file_name?: string | null,
    id: string,
    is_encrypted?: boolean | null,
    storage_path?: string | null,
    updatedAt: string,
    uploaded_by?: string | null,
  } | null,
};

export type OnCreateActivityLogsSubscriptionVariables = {
  filter?: ModelSubscriptionActivityLogsFilterInput | null,
};

export type OnCreateActivityLogsSubscription = {
  onCreateActivityLogs?:  {
    __typename: "ActivityLogs",
    action?: string | null,
    createdAt: string,
    created_at?: string | null,
    data?: string | null,
    details?: string | null,
    id: string,
    target_id?: string | null,
    target_type?: string | null,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type OnCreateApprovalsSubscriptionVariables = {
  filter?: ModelSubscriptionApprovalsFilterInput | null,
};

export type OnCreateApprovalsSubscription = {
  onCreateApprovals?:  {
    __typename: "Approvals",
    approved_at?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    reject_reason?: string | null,
    rejected_at?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateBillingsSubscriptionVariables = {
  filter?: ModelSubscriptionBillingsFilterInput | null,
};

export type OnCreateBillingsSubscription = {
  onCreateBillings?:  {
    __typename: "Billings",
    amount?: string | null,
    authorities?: string | null,
    category?: string | null,
    client_name?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    invoice_no?: string | null,
    payment_received?: boolean | null,
    status?: string | null,
    type?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateCasesSubscriptionVariables = {
  filter?: ModelSubscriptionCasesFilterInput | null,
};

export type OnCreateCasesSubscription = {
  onCreateCases?:  {
    __typename: "Cases",
    case_number?: string | null,
    client_id?: number | null,
    court_details?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    next_hearing_date?: string | null,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateChamberDocumentsSubscriptionVariables = {
  filter?: ModelSubscriptionChamberDocumentsFilterInput | null,
};

export type OnCreateChamberDocumentsSubscription = {
  onCreateChamberDocuments?:  {
    __typename: "ChamberDocuments",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
    version?: number | null,
  } | null,
};

export type OnCreateChatMessagesSubscriptionVariables = {
  filter?: ModelSubscriptionChatMessagesFilterInput | null,
};

export type OnCreateChatMessagesSubscription = {
  onCreateChatMessages?:  {
    __typename: "ChatMessages",
    createdAt: string,
    data?: string | null,
    id: string,
    message?: string | null,
    receiver?: string | null,
    sender?: string | null,
    timestamp?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateChecklistsSubscriptionVariables = {
  filter?: ModelSubscriptionChecklistsFilterInput | null,
};

export type OnCreateChecklistsSubscription = {
  onCreateChecklists?:  {
    __typename: "Checklists",
    assigned_to?: string | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateClientDocumentsSubscriptionVariables = {
  filter?: ModelSubscriptionClientDocumentsFilterInput | null,
};

export type OnCreateClientDocumentsSubscription = {
  onCreateClientDocuments?:  {
    __typename: "ClientDocuments",
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    is_signed?: boolean | null,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
  } | null,
};

export type OnCreateClientsSubscriptionVariables = {
  filter?: ModelSubscriptionClientsFilterInput | null,
};

export type OnCreateClientsSubscription = {
  onCreateClients?:  {
    __typename: "Clients",
    address?: string | null,
    balance_due?: string | null,
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    type_of_work?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateCommunicationLogsSubscriptionVariables = {
  filter?: ModelSubscriptionCommunicationLogsFilterInput | null,
};

export type OnCreateCommunicationLogsSubscription = {
  onCreateCommunicationLogs?:  {
    __typename: "CommunicationLogs",
    client_id?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    medium?: string | null,
    notes?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateDailyCasePaymentsSubscriptionVariables = {
  filter?: ModelSubscriptionDailyCasePaymentsFilterInput | null,
};

export type OnCreateDailyCasePaymentsSubscription = {
  onCreateDailyCasePayments?:  {
    __typename: "DailyCasePayments",
    amount?: string | null,
    case_id?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    payment_date?: string | null,
    payment_mode?: string | null,
    received_by?: number | null,
    remarks?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateDealsSubscriptionVariables = {
  filter?: ModelSubscriptionDealsFilterInput | null,
};

export type OnCreateDealsSubscription = {
  onCreateDeals?:  {
    __typename: "Deals",
    amount?: number | null,
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    is_won?: boolean | null,
    name?: string | null,
    stage?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateDocumentAuditLogsSubscriptionVariables = {
  filter?: ModelSubscriptionDocumentAuditLogsFilterInput | null,
};

export type OnCreateDocumentAuditLogsSubscription = {
  onCreateDocumentAuditLogs?:  {
    __typename: "DocumentAuditLogs",
    action?: string | null,
    createdAt: string,
    data?: string | null,
    details?: string | null,
    document_id?: number | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type OnCreateDocumentTemplatesSubscriptionVariables = {
  filter?: ModelSubscriptionDocumentTemplatesFilterInput | null,
};

export type OnCreateDocumentTemplatesSubscription = {
  onCreateDocumentTemplates?:  {
    __typename: "DocumentTemplates",
    createdAt: string,
    data?: string | null,
    description?: string | null,
    file_path?: string | null,
    id: string,
    name?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateExpensesSubscriptionVariables = {
  filter?: ModelSubscriptionExpensesFilterInput | null,
};

export type OnCreateExpensesSubscription = {
  onCreateExpenses?:  {
    __typename: "Expenses",
    amount?: string | null,
    category?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    description?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateInwardPostsSubscriptionVariables = {
  filter?: ModelSubscriptionInwardPostsFilterInput | null,
};

export type OnCreateInwardPostsSubscription = {
  onCreateInwardPosts?:  {
    __typename: "InwardPosts",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    received_date?: string | null,
    sender?: string | null,
    status?: string | null,
    subject?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateLeadsSubscriptionVariables = {
  filter?: ModelSubscriptionLeadsFilterInput | null,
};

export type OnCreateLeadsSubscription = {
  onCreateLeads?:  {
    __typename: "Leads",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    source?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateMeetingsSubscriptionVariables = {
  filter?: ModelSubscriptionMeetingsFilterInput | null,
};

export type OnCreateMeetingsSubscription = {
  onCreateMeetings?:  {
    __typename: "Meetings",
    attendees?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    location?: string | null,
    meeting_date?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateMessagesSubscriptionVariables = {
  filter?: ModelSubscriptionMessagesFilterInput | null,
};

export type OnCreateMessagesSubscription = {
  onCreateMessages?:  {
    __typename: "Messages",
    content?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    is_read?: boolean | null,
    receiver_id?: number | null,
    sender_id?: number | null,
    sent_at?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateServiceItemsSubscriptionVariables = {
  filter?: ModelSubscriptionServiceItemsFilterInput | null,
};

export type OnCreateServiceItemsSubscription = {
  onCreateServiceItems?:  {
    __typename: "ServiceItems",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    name?: string | null,
    price?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateStaffAttendanceSubscriptionVariables = {
  filter?: ModelSubscriptionStaffAttendanceFilterInput | null,
};

export type OnCreateStaffAttendanceSubscription = {
  onCreateStaffAttendance?:  {
    __typename: "StaffAttendance",
    attendance_date?: string | null,
    check_in_time?: string | null,
    check_out_time?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type OnCreateTasksSubscriptionVariables = {
  filter?: ModelSubscriptionTasksFilterInput | null,
};

export type OnCreateTasksSubscription = {
  onCreateTasks?:  {
    __typename: "Tasks",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    due_date?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnCreateUsersSubscriptionVariables = {
  filter?: ModelSubscriptionUsersFilterInput | null,
};

export type OnCreateUsersSubscription = {
  onCreateUsers?:  {
    __typename: "Users",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    password?: string | null,
    role?: string | null,
    updatedAt: string,
    username?: string | null,
  } | null,
};

export type OnCreateVaultFilesSubscriptionVariables = {
  filter?: ModelSubscriptionVaultFilesFilterInput | null,
};

export type OnCreateVaultFilesSubscription = {
  onCreateVaultFiles?:  {
    __typename: "VaultFiles",
    createdAt: string,
    data?: string | null,
    file_name?: string | null,
    id: string,
    is_encrypted?: boolean | null,
    storage_path?: string | null,
    updatedAt: string,
    uploaded_by?: string | null,
  } | null,
};

export type OnDeleteActivityLogsSubscriptionVariables = {
  filter?: ModelSubscriptionActivityLogsFilterInput | null,
};

export type OnDeleteActivityLogsSubscription = {
  onDeleteActivityLogs?:  {
    __typename: "ActivityLogs",
    action?: string | null,
    createdAt: string,
    created_at?: string | null,
    data?: string | null,
    details?: string | null,
    id: string,
    target_id?: string | null,
    target_type?: string | null,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type OnDeleteApprovalsSubscriptionVariables = {
  filter?: ModelSubscriptionApprovalsFilterInput | null,
};

export type OnDeleteApprovalsSubscription = {
  onDeleteApprovals?:  {
    __typename: "Approvals",
    approved_at?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    reject_reason?: string | null,
    rejected_at?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteBillingsSubscriptionVariables = {
  filter?: ModelSubscriptionBillingsFilterInput | null,
};

export type OnDeleteBillingsSubscription = {
  onDeleteBillings?:  {
    __typename: "Billings",
    amount?: string | null,
    authorities?: string | null,
    category?: string | null,
    client_name?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    invoice_no?: string | null,
    payment_received?: boolean | null,
    status?: string | null,
    type?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteCasesSubscriptionVariables = {
  filter?: ModelSubscriptionCasesFilterInput | null,
};

export type OnDeleteCasesSubscription = {
  onDeleteCases?:  {
    __typename: "Cases",
    case_number?: string | null,
    client_id?: number | null,
    court_details?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    next_hearing_date?: string | null,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteChamberDocumentsSubscriptionVariables = {
  filter?: ModelSubscriptionChamberDocumentsFilterInput | null,
};

export type OnDeleteChamberDocumentsSubscription = {
  onDeleteChamberDocuments?:  {
    __typename: "ChamberDocuments",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
    version?: number | null,
  } | null,
};

export type OnDeleteChatMessagesSubscriptionVariables = {
  filter?: ModelSubscriptionChatMessagesFilterInput | null,
};

export type OnDeleteChatMessagesSubscription = {
  onDeleteChatMessages?:  {
    __typename: "ChatMessages",
    createdAt: string,
    data?: string | null,
    id: string,
    message?: string | null,
    receiver?: string | null,
    sender?: string | null,
    timestamp?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteChecklistsSubscriptionVariables = {
  filter?: ModelSubscriptionChecklistsFilterInput | null,
};

export type OnDeleteChecklistsSubscription = {
  onDeleteChecklists?:  {
    __typename: "Checklists",
    assigned_to?: string | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteClientDocumentsSubscriptionVariables = {
  filter?: ModelSubscriptionClientDocumentsFilterInput | null,
};

export type OnDeleteClientDocumentsSubscription = {
  onDeleteClientDocuments?:  {
    __typename: "ClientDocuments",
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    is_signed?: boolean | null,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
  } | null,
};

export type OnDeleteClientsSubscriptionVariables = {
  filter?: ModelSubscriptionClientsFilterInput | null,
};

export type OnDeleteClientsSubscription = {
  onDeleteClients?:  {
    __typename: "Clients",
    address?: string | null,
    balance_due?: string | null,
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    type_of_work?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteCommunicationLogsSubscriptionVariables = {
  filter?: ModelSubscriptionCommunicationLogsFilterInput | null,
};

export type OnDeleteCommunicationLogsSubscription = {
  onDeleteCommunicationLogs?:  {
    __typename: "CommunicationLogs",
    client_id?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    medium?: string | null,
    notes?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteDailyCasePaymentsSubscriptionVariables = {
  filter?: ModelSubscriptionDailyCasePaymentsFilterInput | null,
};

export type OnDeleteDailyCasePaymentsSubscription = {
  onDeleteDailyCasePayments?:  {
    __typename: "DailyCasePayments",
    amount?: string | null,
    case_id?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    payment_date?: string | null,
    payment_mode?: string | null,
    received_by?: number | null,
    remarks?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteDealsSubscriptionVariables = {
  filter?: ModelSubscriptionDealsFilterInput | null,
};

export type OnDeleteDealsSubscription = {
  onDeleteDeals?:  {
    __typename: "Deals",
    amount?: number | null,
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    is_won?: boolean | null,
    name?: string | null,
    stage?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteDocumentAuditLogsSubscriptionVariables = {
  filter?: ModelSubscriptionDocumentAuditLogsFilterInput | null,
};

export type OnDeleteDocumentAuditLogsSubscription = {
  onDeleteDocumentAuditLogs?:  {
    __typename: "DocumentAuditLogs",
    action?: string | null,
    createdAt: string,
    data?: string | null,
    details?: string | null,
    document_id?: number | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type OnDeleteDocumentTemplatesSubscriptionVariables = {
  filter?: ModelSubscriptionDocumentTemplatesFilterInput | null,
};

export type OnDeleteDocumentTemplatesSubscription = {
  onDeleteDocumentTemplates?:  {
    __typename: "DocumentTemplates",
    createdAt: string,
    data?: string | null,
    description?: string | null,
    file_path?: string | null,
    id: string,
    name?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteExpensesSubscriptionVariables = {
  filter?: ModelSubscriptionExpensesFilterInput | null,
};

export type OnDeleteExpensesSubscription = {
  onDeleteExpenses?:  {
    __typename: "Expenses",
    amount?: string | null,
    category?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    description?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteInwardPostsSubscriptionVariables = {
  filter?: ModelSubscriptionInwardPostsFilterInput | null,
};

export type OnDeleteInwardPostsSubscription = {
  onDeleteInwardPosts?:  {
    __typename: "InwardPosts",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    received_date?: string | null,
    sender?: string | null,
    status?: string | null,
    subject?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteLeadsSubscriptionVariables = {
  filter?: ModelSubscriptionLeadsFilterInput | null,
};

export type OnDeleteLeadsSubscription = {
  onDeleteLeads?:  {
    __typename: "Leads",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    source?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteMeetingsSubscriptionVariables = {
  filter?: ModelSubscriptionMeetingsFilterInput | null,
};

export type OnDeleteMeetingsSubscription = {
  onDeleteMeetings?:  {
    __typename: "Meetings",
    attendees?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    location?: string | null,
    meeting_date?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteMessagesSubscriptionVariables = {
  filter?: ModelSubscriptionMessagesFilterInput | null,
};

export type OnDeleteMessagesSubscription = {
  onDeleteMessages?:  {
    __typename: "Messages",
    content?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    is_read?: boolean | null,
    receiver_id?: number | null,
    sender_id?: number | null,
    sent_at?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteServiceItemsSubscriptionVariables = {
  filter?: ModelSubscriptionServiceItemsFilterInput | null,
};

export type OnDeleteServiceItemsSubscription = {
  onDeleteServiceItems?:  {
    __typename: "ServiceItems",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    name?: string | null,
    price?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteStaffAttendanceSubscriptionVariables = {
  filter?: ModelSubscriptionStaffAttendanceFilterInput | null,
};

export type OnDeleteStaffAttendanceSubscription = {
  onDeleteStaffAttendance?:  {
    __typename: "StaffAttendance",
    attendance_date?: string | null,
    check_in_time?: string | null,
    check_out_time?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type OnDeleteTasksSubscriptionVariables = {
  filter?: ModelSubscriptionTasksFilterInput | null,
};

export type OnDeleteTasksSubscription = {
  onDeleteTasks?:  {
    __typename: "Tasks",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    due_date?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnDeleteUsersSubscriptionVariables = {
  filter?: ModelSubscriptionUsersFilterInput | null,
};

export type OnDeleteUsersSubscription = {
  onDeleteUsers?:  {
    __typename: "Users",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    password?: string | null,
    role?: string | null,
    updatedAt: string,
    username?: string | null,
  } | null,
};

export type OnDeleteVaultFilesSubscriptionVariables = {
  filter?: ModelSubscriptionVaultFilesFilterInput | null,
};

export type OnDeleteVaultFilesSubscription = {
  onDeleteVaultFiles?:  {
    __typename: "VaultFiles",
    createdAt: string,
    data?: string | null,
    file_name?: string | null,
    id: string,
    is_encrypted?: boolean | null,
    storage_path?: string | null,
    updatedAt: string,
    uploaded_by?: string | null,
  } | null,
};

export type OnUpdateActivityLogsSubscriptionVariables = {
  filter?: ModelSubscriptionActivityLogsFilterInput | null,
};

export type OnUpdateActivityLogsSubscription = {
  onUpdateActivityLogs?:  {
    __typename: "ActivityLogs",
    action?: string | null,
    createdAt: string,
    created_at?: string | null,
    data?: string | null,
    details?: string | null,
    id: string,
    target_id?: string | null,
    target_type?: string | null,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type OnUpdateApprovalsSubscriptionVariables = {
  filter?: ModelSubscriptionApprovalsFilterInput | null,
};

export type OnUpdateApprovalsSubscription = {
  onUpdateApprovals?:  {
    __typename: "Approvals",
    approved_at?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    reject_reason?: string | null,
    rejected_at?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateBillingsSubscriptionVariables = {
  filter?: ModelSubscriptionBillingsFilterInput | null,
};

export type OnUpdateBillingsSubscription = {
  onUpdateBillings?:  {
    __typename: "Billings",
    amount?: string | null,
    authorities?: string | null,
    category?: string | null,
    client_name?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    invoice_no?: string | null,
    payment_received?: boolean | null,
    status?: string | null,
    type?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateCasesSubscriptionVariables = {
  filter?: ModelSubscriptionCasesFilterInput | null,
};

export type OnUpdateCasesSubscription = {
  onUpdateCases?:  {
    __typename: "Cases",
    case_number?: string | null,
    client_id?: number | null,
    court_details?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    next_hearing_date?: string | null,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateChamberDocumentsSubscriptionVariables = {
  filter?: ModelSubscriptionChamberDocumentsFilterInput | null,
};

export type OnUpdateChamberDocumentsSubscription = {
  onUpdateChamberDocuments?:  {
    __typename: "ChamberDocuments",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
    version?: number | null,
  } | null,
};

export type OnUpdateChatMessagesSubscriptionVariables = {
  filter?: ModelSubscriptionChatMessagesFilterInput | null,
};

export type OnUpdateChatMessagesSubscription = {
  onUpdateChatMessages?:  {
    __typename: "ChatMessages",
    createdAt: string,
    data?: string | null,
    id: string,
    message?: string | null,
    receiver?: string | null,
    sender?: string | null,
    timestamp?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateChecklistsSubscriptionVariables = {
  filter?: ModelSubscriptionChecklistsFilterInput | null,
};

export type OnUpdateChecklistsSubscription = {
  onUpdateChecklists?:  {
    __typename: "Checklists",
    assigned_to?: string | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateClientDocumentsSubscriptionVariables = {
  filter?: ModelSubscriptionClientDocumentsFilterInput | null,
};

export type OnUpdateClientDocumentsSubscription = {
  onUpdateClientDocuments?:  {
    __typename: "ClientDocuments",
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    file_path?: string | null,
    id: string,
    is_signed?: boolean | null,
    title?: string | null,
    updatedAt: string,
    uploaded_by?: number | null,
  } | null,
};

export type OnUpdateClientsSubscriptionVariables = {
  filter?: ModelSubscriptionClientsFilterInput | null,
};

export type OnUpdateClientsSubscription = {
  onUpdateClients?:  {
    __typename: "Clients",
    address?: string | null,
    balance_due?: string | null,
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    type_of_work?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateCommunicationLogsSubscriptionVariables = {
  filter?: ModelSubscriptionCommunicationLogsFilterInput | null,
};

export type OnUpdateCommunicationLogsSubscription = {
  onUpdateCommunicationLogs?:  {
    __typename: "CommunicationLogs",
    client_id?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    id: string,
    medium?: string | null,
    notes?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateDailyCasePaymentsSubscriptionVariables = {
  filter?: ModelSubscriptionDailyCasePaymentsFilterInput | null,
};

export type OnUpdateDailyCasePaymentsSubscription = {
  onUpdateDailyCasePayments?:  {
    __typename: "DailyCasePayments",
    amount?: string | null,
    case_id?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    payment_date?: string | null,
    payment_mode?: string | null,
    received_by?: number | null,
    remarks?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateDealsSubscriptionVariables = {
  filter?: ModelSubscriptionDealsFilterInput | null,
};

export type OnUpdateDealsSubscription = {
  onUpdateDeals?:  {
    __typename: "Deals",
    amount?: number | null,
    client_id?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    id: string,
    is_won?: boolean | null,
    name?: string | null,
    stage?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateDocumentAuditLogsSubscriptionVariables = {
  filter?: ModelSubscriptionDocumentAuditLogsFilterInput | null,
};

export type OnUpdateDocumentAuditLogsSubscription = {
  onUpdateDocumentAuditLogs?:  {
    __typename: "DocumentAuditLogs",
    action?: string | null,
    createdAt: string,
    data?: string | null,
    details?: string | null,
    document_id?: number | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type OnUpdateDocumentTemplatesSubscriptionVariables = {
  filter?: ModelSubscriptionDocumentTemplatesFilterInput | null,
};

export type OnUpdateDocumentTemplatesSubscription = {
  onUpdateDocumentTemplates?:  {
    __typename: "DocumentTemplates",
    createdAt: string,
    data?: string | null,
    description?: string | null,
    file_path?: string | null,
    id: string,
    name?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateExpensesSubscriptionVariables = {
  filter?: ModelSubscriptionExpensesFilterInput | null,
};

export type OnUpdateExpensesSubscription = {
  onUpdateExpenses?:  {
    __typename: "Expenses",
    amount?: string | null,
    category?: string | null,
    createdAt: string,
    data?: string | null,
    date?: string | null,
    description?: string | null,
    id: string,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateInwardPostsSubscriptionVariables = {
  filter?: ModelSubscriptionInwardPostsFilterInput | null,
};

export type OnUpdateInwardPostsSubscription = {
  onUpdateInwardPosts?:  {
    __typename: "InwardPosts",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    id: string,
    received_date?: string | null,
    sender?: string | null,
    status?: string | null,
    subject?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateLeadsSubscriptionVariables = {
  filter?: ModelSubscriptionLeadsFilterInput | null,
};

export type OnUpdateLeadsSubscription = {
  onUpdateLeads?:  {
    __typename: "Leads",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    phone?: string | null,
    source?: string | null,
    status?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateMeetingsSubscriptionVariables = {
  filter?: ModelSubscriptionMeetingsFilterInput | null,
};

export type OnUpdateMeetingsSubscription = {
  onUpdateMeetings?:  {
    __typename: "Meetings",
    attendees?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    location?: string | null,
    meeting_date?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateMessagesSubscriptionVariables = {
  filter?: ModelSubscriptionMessagesFilterInput | null,
};

export type OnUpdateMessagesSubscription = {
  onUpdateMessages?:  {
    __typename: "Messages",
    content?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    is_read?: boolean | null,
    receiver_id?: number | null,
    sender_id?: number | null,
    sent_at?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateServiceItemsSubscriptionVariables = {
  filter?: ModelSubscriptionServiceItemsFilterInput | null,
};

export type OnUpdateServiceItemsSubscription = {
  onUpdateServiceItems?:  {
    __typename: "ServiceItems",
    category?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    name?: string | null,
    price?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateStaffAttendanceSubscriptionVariables = {
  filter?: ModelSubscriptionStaffAttendanceFilterInput | null,
};

export type OnUpdateStaffAttendanceSubscription = {
  onUpdateStaffAttendance?:  {
    __typename: "StaffAttendance",
    attendance_date?: string | null,
    check_in_time?: string | null,
    check_out_time?: string | null,
    createdAt: string,
    data?: string | null,
    id: string,
    updatedAt: string,
    user_id?: number | null,
  } | null,
};

export type OnUpdateTasksSubscriptionVariables = {
  filter?: ModelSubscriptionTasksFilterInput | null,
};

export type OnUpdateTasksSubscription = {
  onUpdateTasks?:  {
    __typename: "Tasks",
    assigned_to?: number | null,
    createdAt: string,
    data?: string | null,
    description?: string | null,
    due_date?: string | null,
    id: string,
    status?: string | null,
    title?: string | null,
    updatedAt: string,
  } | null,
};

export type OnUpdateUsersSubscriptionVariables = {
  filter?: ModelSubscriptionUsersFilterInput | null,
};

export type OnUpdateUsersSubscription = {
  onUpdateUsers?:  {
    __typename: "Users",
    createdAt: string,
    data?: string | null,
    email?: string | null,
    id: string,
    name?: string | null,
    password?: string | null,
    role?: string | null,
    updatedAt: string,
    username?: string | null,
  } | null,
};

export type OnUpdateVaultFilesSubscriptionVariables = {
  filter?: ModelSubscriptionVaultFilesFilterInput | null,
};

export type OnUpdateVaultFilesSubscription = {
  onUpdateVaultFiles?:  {
    __typename: "VaultFiles",
    createdAt: string,
    data?: string | null,
    file_name?: string | null,
    id: string,
    is_encrypted?: boolean | null,
    storage_path?: string | null,
    updatedAt: string,
    uploaded_by?: string | null,
  } | null,
};
