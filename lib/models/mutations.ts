/* tslint:disable */
/* eslint-disable */
// this is an auto generated file. This will be overwritten

import * as APITypes from "./API";
type GeneratedMutation<InputType, OutputType> = string & {
  __generatedMutationInput: InputType;
  __generatedMutationOutput: OutputType;
};

export const createActivityLogs = /* GraphQL */ `mutation CreateActivityLogs(
  $condition: ModelActivityLogsConditionInput
  $input: CreateActivityLogsInput!
) {
  createActivityLogs(condition: $condition, input: $input) {
    action
    createdAt
    created_at
    data
    details
    id
    target_id
    target_type
    updatedAt
    user_id
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateActivityLogsMutationVariables,
  APITypes.CreateActivityLogsMutation
>;
export const createApprovals = /* GraphQL */ `mutation CreateApprovals(
  $condition: ModelApprovalsConditionInput
  $input: CreateApprovalsInput!
) {
  createApprovals(condition: $condition, input: $input) {
    approved_at
    createdAt
    data
    id
    reject_reason
    rejected_at
    status
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateApprovalsMutationVariables,
  APITypes.CreateApprovalsMutation
>;
export const createBillings = /* GraphQL */ `mutation CreateBillings(
  $condition: ModelBillingsConditionInput
  $input: CreateBillingsInput!
) {
  createBillings(condition: $condition, input: $input) {
    amount
    authorities
    category
    client_name
    createdAt
    data
    date
    id
    invoice_no
    payment_received
    status
    type
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateBillingsMutationVariables,
  APITypes.CreateBillingsMutation
>;
export const createCases = /* GraphQL */ `mutation CreateCases(
  $condition: ModelCasesConditionInput
  $input: CreateCasesInput!
) {
  createCases(condition: $condition, input: $input) {
    case_number
    client_id
    court_details
    createdAt
    data
    id
    next_hearing_date
    status
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateCasesMutationVariables,
  APITypes.CreateCasesMutation
>;
export const createChamberDocuments = /* GraphQL */ `mutation CreateChamberDocuments(
  $condition: ModelChamberDocumentsConditionInput
  $input: CreateChamberDocumentsInput!
) {
  createChamberDocuments(condition: $condition, input: $input) {
    category
    createdAt
    data
    file_path
    id
    title
    updatedAt
    uploaded_by
    version
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateChamberDocumentsMutationVariables,
  APITypes.CreateChamberDocumentsMutation
>;
export const createChatMessages = /* GraphQL */ `mutation CreateChatMessages(
  $condition: ModelChatMessagesConditionInput
  $input: CreateChatMessagesInput!
) {
  createChatMessages(condition: $condition, input: $input) {
    createdAt
    data
    id
    message
    receiver
    sender
    timestamp
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateChatMessagesMutationVariables,
  APITypes.CreateChatMessagesMutation
>;
export const createChecklists = /* GraphQL */ `mutation CreateChecklists(
  $condition: ModelChecklistsConditionInput
  $input: CreateChecklistsInput!
) {
  createChecklists(condition: $condition, input: $input) {
    assigned_to
    createdAt
    data
    description
    id
    status
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateChecklistsMutationVariables,
  APITypes.CreateChecklistsMutation
>;
export const createClientDocuments = /* GraphQL */ `mutation CreateClientDocuments(
  $condition: ModelClientDocumentsConditionInput
  $input: CreateClientDocumentsInput!
) {
  createClientDocuments(condition: $condition, input: $input) {
    client_id
    createdAt
    data
    file_path
    id
    is_signed
    title
    updatedAt
    uploaded_by
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateClientDocumentsMutationVariables,
  APITypes.CreateClientDocumentsMutation
>;
export const createClients = /* GraphQL */ `mutation CreateClients(
  $condition: ModelClientsConditionInput
  $input: CreateClientsInput!
) {
  createClients(condition: $condition, input: $input) {
    address
    balance_due
    createdAt
    data
    email
    id
    name
    phone
    type_of_work
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateClientsMutationVariables,
  APITypes.CreateClientsMutation
>;
export const createCommunicationLogs = /* GraphQL */ `mutation CreateCommunicationLogs(
  $condition: ModelCommunicationLogsConditionInput
  $input: CreateCommunicationLogsInput!
) {
  createCommunicationLogs(condition: $condition, input: $input) {
    client_id
    createdAt
    data
    date
    id
    medium
    notes
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateCommunicationLogsMutationVariables,
  APITypes.CreateCommunicationLogsMutation
>;
export const createDailyCasePayments = /* GraphQL */ `mutation CreateDailyCasePayments(
  $condition: ModelDailyCasePaymentsConditionInput
  $input: CreateDailyCasePaymentsInput!
) {
  createDailyCasePayments(condition: $condition, input: $input) {
    amount
    case_id
    createdAt
    data
    id
    payment_date
    payment_mode
    received_by
    remarks
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateDailyCasePaymentsMutationVariables,
  APITypes.CreateDailyCasePaymentsMutation
>;
export const createDeals = /* GraphQL */ `mutation CreateDeals(
  $condition: ModelDealsConditionInput
  $input: CreateDealsInput!
) {
  createDeals(condition: $condition, input: $input) {
    amount
    client_id
    createdAt
    data
    description
    id
    is_won
    name
    stage
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateDealsMutationVariables,
  APITypes.CreateDealsMutation
>;
export const createDocumentAuditLogs = /* GraphQL */ `mutation CreateDocumentAuditLogs(
  $condition: ModelDocumentAuditLogsConditionInput
  $input: CreateDocumentAuditLogsInput!
) {
  createDocumentAuditLogs(condition: $condition, input: $input) {
    action
    createdAt
    data
    details
    document_id
    id
    updatedAt
    user_id
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateDocumentAuditLogsMutationVariables,
  APITypes.CreateDocumentAuditLogsMutation
>;
export const createDocumentTemplates = /* GraphQL */ `mutation CreateDocumentTemplates(
  $condition: ModelDocumentTemplatesConditionInput
  $input: CreateDocumentTemplatesInput!
) {
  createDocumentTemplates(condition: $condition, input: $input) {
    createdAt
    data
    description
    file_path
    id
    name
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateDocumentTemplatesMutationVariables,
  APITypes.CreateDocumentTemplatesMutation
>;
export const createExpenses = /* GraphQL */ `mutation CreateExpenses(
  $condition: ModelExpensesConditionInput
  $input: CreateExpensesInput!
) {
  createExpenses(condition: $condition, input: $input) {
    amount
    category
    createdAt
    data
    date
    description
    id
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateExpensesMutationVariables,
  APITypes.CreateExpensesMutation
>;
export const createInwardPosts = /* GraphQL */ `mutation CreateInwardPosts(
  $condition: ModelInwardPostsConditionInput
  $input: CreateInwardPostsInput!
) {
  createInwardPosts(condition: $condition, input: $input) {
    assigned_to
    createdAt
    data
    id
    received_date
    sender
    status
    subject
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateInwardPostsMutationVariables,
  APITypes.CreateInwardPostsMutation
>;
export const createLeads = /* GraphQL */ `mutation CreateLeads(
  $condition: ModelLeadsConditionInput
  $input: CreateLeadsInput!
) {
  createLeads(condition: $condition, input: $input) {
    createdAt
    data
    email
    id
    name
    phone
    source
    status
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateLeadsMutationVariables,
  APITypes.CreateLeadsMutation
>;
export const createMeetings = /* GraphQL */ `mutation CreateMeetings(
  $condition: ModelMeetingsConditionInput
  $input: CreateMeetingsInput!
) {
  createMeetings(condition: $condition, input: $input) {
    attendees
    createdAt
    data
    id
    location
    meeting_date
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateMeetingsMutationVariables,
  APITypes.CreateMeetingsMutation
>;
export const createMessages = /* GraphQL */ `mutation CreateMessages(
  $condition: ModelMessagesConditionInput
  $input: CreateMessagesInput!
) {
  createMessages(condition: $condition, input: $input) {
    content
    createdAt
    data
    id
    is_read
    receiver_id
    sender_id
    sent_at
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateMessagesMutationVariables,
  APITypes.CreateMessagesMutation
>;
export const createServiceItems = /* GraphQL */ `mutation CreateServiceItems(
  $condition: ModelServiceItemsConditionInput
  $input: CreateServiceItemsInput!
) {
  createServiceItems(condition: $condition, input: $input) {
    category
    createdAt
    data
    id
    name
    price
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateServiceItemsMutationVariables,
  APITypes.CreateServiceItemsMutation
>;
export const createStaffAttendance = /* GraphQL */ `mutation CreateStaffAttendance(
  $condition: ModelStaffAttendanceConditionInput
  $input: CreateStaffAttendanceInput!
) {
  createStaffAttendance(condition: $condition, input: $input) {
    attendance_date
    check_in_time
    check_out_time
    createdAt
    data
    id
    updatedAt
    user_id
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateStaffAttendanceMutationVariables,
  APITypes.CreateStaffAttendanceMutation
>;
export const createTasks = /* GraphQL */ `mutation CreateTasks(
  $condition: ModelTasksConditionInput
  $input: CreateTasksInput!
) {
  createTasks(condition: $condition, input: $input) {
    assigned_to
    createdAt
    data
    description
    due_date
    id
    status
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateTasksMutationVariables,
  APITypes.CreateTasksMutation
>;
export const createUsers = /* GraphQL */ `mutation CreateUsers(
  $condition: ModelUsersConditionInput
  $input: CreateUsersInput!
) {
  createUsers(condition: $condition, input: $input) {
    createdAt
    data
    email
    id
    name
    password
    role
    updatedAt
    username
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateUsersMutationVariables,
  APITypes.CreateUsersMutation
>;
export const createVaultFiles = /* GraphQL */ `mutation CreateVaultFiles(
  $condition: ModelVaultFilesConditionInput
  $input: CreateVaultFilesInput!
) {
  createVaultFiles(condition: $condition, input: $input) {
    createdAt
    data
    file_name
    id
    is_encrypted
    storage_path
    updatedAt
    uploaded_by
    __typename
  }
}
` as GeneratedMutation<
  APITypes.CreateVaultFilesMutationVariables,
  APITypes.CreateVaultFilesMutation
>;
export const deleteActivityLogs = /* GraphQL */ `mutation DeleteActivityLogs(
  $condition: ModelActivityLogsConditionInput
  $input: DeleteActivityLogsInput!
) {
  deleteActivityLogs(condition: $condition, input: $input) {
    action
    createdAt
    created_at
    data
    details
    id
    target_id
    target_type
    updatedAt
    user_id
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteActivityLogsMutationVariables,
  APITypes.DeleteActivityLogsMutation
>;
export const deleteApprovals = /* GraphQL */ `mutation DeleteApprovals(
  $condition: ModelApprovalsConditionInput
  $input: DeleteApprovalsInput!
) {
  deleteApprovals(condition: $condition, input: $input) {
    approved_at
    createdAt
    data
    id
    reject_reason
    rejected_at
    status
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteApprovalsMutationVariables,
  APITypes.DeleteApprovalsMutation
>;
export const deleteBillings = /* GraphQL */ `mutation DeleteBillings(
  $condition: ModelBillingsConditionInput
  $input: DeleteBillingsInput!
) {
  deleteBillings(condition: $condition, input: $input) {
    amount
    authorities
    category
    client_name
    createdAt
    data
    date
    id
    invoice_no
    payment_received
    status
    type
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteBillingsMutationVariables,
  APITypes.DeleteBillingsMutation
>;
export const deleteCases = /* GraphQL */ `mutation DeleteCases(
  $condition: ModelCasesConditionInput
  $input: DeleteCasesInput!
) {
  deleteCases(condition: $condition, input: $input) {
    case_number
    client_id
    court_details
    createdAt
    data
    id
    next_hearing_date
    status
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteCasesMutationVariables,
  APITypes.DeleteCasesMutation
>;
export const deleteChamberDocuments = /* GraphQL */ `mutation DeleteChamberDocuments(
  $condition: ModelChamberDocumentsConditionInput
  $input: DeleteChamberDocumentsInput!
) {
  deleteChamberDocuments(condition: $condition, input: $input) {
    category
    createdAt
    data
    file_path
    id
    title
    updatedAt
    uploaded_by
    version
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteChamberDocumentsMutationVariables,
  APITypes.DeleteChamberDocumentsMutation
>;
export const deleteChatMessages = /* GraphQL */ `mutation DeleteChatMessages(
  $condition: ModelChatMessagesConditionInput
  $input: DeleteChatMessagesInput!
) {
  deleteChatMessages(condition: $condition, input: $input) {
    createdAt
    data
    id
    message
    receiver
    sender
    timestamp
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteChatMessagesMutationVariables,
  APITypes.DeleteChatMessagesMutation
>;
export const deleteChecklists = /* GraphQL */ `mutation DeleteChecklists(
  $condition: ModelChecklistsConditionInput
  $input: DeleteChecklistsInput!
) {
  deleteChecklists(condition: $condition, input: $input) {
    assigned_to
    createdAt
    data
    description
    id
    status
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteChecklistsMutationVariables,
  APITypes.DeleteChecklistsMutation
>;
export const deleteClientDocuments = /* GraphQL */ `mutation DeleteClientDocuments(
  $condition: ModelClientDocumentsConditionInput
  $input: DeleteClientDocumentsInput!
) {
  deleteClientDocuments(condition: $condition, input: $input) {
    client_id
    createdAt
    data
    file_path
    id
    is_signed
    title
    updatedAt
    uploaded_by
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteClientDocumentsMutationVariables,
  APITypes.DeleteClientDocumentsMutation
>;
export const deleteClients = /* GraphQL */ `mutation DeleteClients(
  $condition: ModelClientsConditionInput
  $input: DeleteClientsInput!
) {
  deleteClients(condition: $condition, input: $input) {
    address
    balance_due
    createdAt
    data
    email
    id
    name
    phone
    type_of_work
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteClientsMutationVariables,
  APITypes.DeleteClientsMutation
>;
export const deleteCommunicationLogs = /* GraphQL */ `mutation DeleteCommunicationLogs(
  $condition: ModelCommunicationLogsConditionInput
  $input: DeleteCommunicationLogsInput!
) {
  deleteCommunicationLogs(condition: $condition, input: $input) {
    client_id
    createdAt
    data
    date
    id
    medium
    notes
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteCommunicationLogsMutationVariables,
  APITypes.DeleteCommunicationLogsMutation
>;
export const deleteDailyCasePayments = /* GraphQL */ `mutation DeleteDailyCasePayments(
  $condition: ModelDailyCasePaymentsConditionInput
  $input: DeleteDailyCasePaymentsInput!
) {
  deleteDailyCasePayments(condition: $condition, input: $input) {
    amount
    case_id
    createdAt
    data
    id
    payment_date
    payment_mode
    received_by
    remarks
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteDailyCasePaymentsMutationVariables,
  APITypes.DeleteDailyCasePaymentsMutation
>;
export const deleteDeals = /* GraphQL */ `mutation DeleteDeals(
  $condition: ModelDealsConditionInput
  $input: DeleteDealsInput!
) {
  deleteDeals(condition: $condition, input: $input) {
    amount
    client_id
    createdAt
    data
    description
    id
    is_won
    name
    stage
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteDealsMutationVariables,
  APITypes.DeleteDealsMutation
>;
export const deleteDocumentAuditLogs = /* GraphQL */ `mutation DeleteDocumentAuditLogs(
  $condition: ModelDocumentAuditLogsConditionInput
  $input: DeleteDocumentAuditLogsInput!
) {
  deleteDocumentAuditLogs(condition: $condition, input: $input) {
    action
    createdAt
    data
    details
    document_id
    id
    updatedAt
    user_id
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteDocumentAuditLogsMutationVariables,
  APITypes.DeleteDocumentAuditLogsMutation
>;
export const deleteDocumentTemplates = /* GraphQL */ `mutation DeleteDocumentTemplates(
  $condition: ModelDocumentTemplatesConditionInput
  $input: DeleteDocumentTemplatesInput!
) {
  deleteDocumentTemplates(condition: $condition, input: $input) {
    createdAt
    data
    description
    file_path
    id
    name
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteDocumentTemplatesMutationVariables,
  APITypes.DeleteDocumentTemplatesMutation
>;
export const deleteExpenses = /* GraphQL */ `mutation DeleteExpenses(
  $condition: ModelExpensesConditionInput
  $input: DeleteExpensesInput!
) {
  deleteExpenses(condition: $condition, input: $input) {
    amount
    category
    createdAt
    data
    date
    description
    id
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteExpensesMutationVariables,
  APITypes.DeleteExpensesMutation
>;
export const deleteInwardPosts = /* GraphQL */ `mutation DeleteInwardPosts(
  $condition: ModelInwardPostsConditionInput
  $input: DeleteInwardPostsInput!
) {
  deleteInwardPosts(condition: $condition, input: $input) {
    assigned_to
    createdAt
    data
    id
    received_date
    sender
    status
    subject
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteInwardPostsMutationVariables,
  APITypes.DeleteInwardPostsMutation
>;
export const deleteLeads = /* GraphQL */ `mutation DeleteLeads(
  $condition: ModelLeadsConditionInput
  $input: DeleteLeadsInput!
) {
  deleteLeads(condition: $condition, input: $input) {
    createdAt
    data
    email
    id
    name
    phone
    source
    status
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteLeadsMutationVariables,
  APITypes.DeleteLeadsMutation
>;
export const deleteMeetings = /* GraphQL */ `mutation DeleteMeetings(
  $condition: ModelMeetingsConditionInput
  $input: DeleteMeetingsInput!
) {
  deleteMeetings(condition: $condition, input: $input) {
    attendees
    createdAt
    data
    id
    location
    meeting_date
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteMeetingsMutationVariables,
  APITypes.DeleteMeetingsMutation
>;
export const deleteMessages = /* GraphQL */ `mutation DeleteMessages(
  $condition: ModelMessagesConditionInput
  $input: DeleteMessagesInput!
) {
  deleteMessages(condition: $condition, input: $input) {
    content
    createdAt
    data
    id
    is_read
    receiver_id
    sender_id
    sent_at
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteMessagesMutationVariables,
  APITypes.DeleteMessagesMutation
>;
export const deleteServiceItems = /* GraphQL */ `mutation DeleteServiceItems(
  $condition: ModelServiceItemsConditionInput
  $input: DeleteServiceItemsInput!
) {
  deleteServiceItems(condition: $condition, input: $input) {
    category
    createdAt
    data
    id
    name
    price
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteServiceItemsMutationVariables,
  APITypes.DeleteServiceItemsMutation
>;
export const deleteStaffAttendance = /* GraphQL */ `mutation DeleteStaffAttendance(
  $condition: ModelStaffAttendanceConditionInput
  $input: DeleteStaffAttendanceInput!
) {
  deleteStaffAttendance(condition: $condition, input: $input) {
    attendance_date
    check_in_time
    check_out_time
    createdAt
    data
    id
    updatedAt
    user_id
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteStaffAttendanceMutationVariables,
  APITypes.DeleteStaffAttendanceMutation
>;
export const deleteTasks = /* GraphQL */ `mutation DeleteTasks(
  $condition: ModelTasksConditionInput
  $input: DeleteTasksInput!
) {
  deleteTasks(condition: $condition, input: $input) {
    assigned_to
    createdAt
    data
    description
    due_date
    id
    status
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteTasksMutationVariables,
  APITypes.DeleteTasksMutation
>;
export const deleteUsers = /* GraphQL */ `mutation DeleteUsers(
  $condition: ModelUsersConditionInput
  $input: DeleteUsersInput!
) {
  deleteUsers(condition: $condition, input: $input) {
    createdAt
    data
    email
    id
    name
    password
    role
    updatedAt
    username
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteUsersMutationVariables,
  APITypes.DeleteUsersMutation
>;
export const deleteVaultFiles = /* GraphQL */ `mutation DeleteVaultFiles(
  $condition: ModelVaultFilesConditionInput
  $input: DeleteVaultFilesInput!
) {
  deleteVaultFiles(condition: $condition, input: $input) {
    createdAt
    data
    file_name
    id
    is_encrypted
    storage_path
    updatedAt
    uploaded_by
    __typename
  }
}
` as GeneratedMutation<
  APITypes.DeleteVaultFilesMutationVariables,
  APITypes.DeleteVaultFilesMutation
>;
export const updateActivityLogs = /* GraphQL */ `mutation UpdateActivityLogs(
  $condition: ModelActivityLogsConditionInput
  $input: UpdateActivityLogsInput!
) {
  updateActivityLogs(condition: $condition, input: $input) {
    action
    createdAt
    created_at
    data
    details
    id
    target_id
    target_type
    updatedAt
    user_id
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateActivityLogsMutationVariables,
  APITypes.UpdateActivityLogsMutation
>;
export const updateApprovals = /* GraphQL */ `mutation UpdateApprovals(
  $condition: ModelApprovalsConditionInput
  $input: UpdateApprovalsInput!
) {
  updateApprovals(condition: $condition, input: $input) {
    approved_at
    createdAt
    data
    id
    reject_reason
    rejected_at
    status
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateApprovalsMutationVariables,
  APITypes.UpdateApprovalsMutation
>;
export const updateBillings = /* GraphQL */ `mutation UpdateBillings(
  $condition: ModelBillingsConditionInput
  $input: UpdateBillingsInput!
) {
  updateBillings(condition: $condition, input: $input) {
    amount
    authorities
    category
    client_name
    createdAt
    data
    date
    id
    invoice_no
    payment_received
    status
    type
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateBillingsMutationVariables,
  APITypes.UpdateBillingsMutation
>;
export const updateCases = /* GraphQL */ `mutation UpdateCases(
  $condition: ModelCasesConditionInput
  $input: UpdateCasesInput!
) {
  updateCases(condition: $condition, input: $input) {
    case_number
    client_id
    court_details
    createdAt
    data
    id
    next_hearing_date
    status
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateCasesMutationVariables,
  APITypes.UpdateCasesMutation
>;
export const updateChamberDocuments = /* GraphQL */ `mutation UpdateChamberDocuments(
  $condition: ModelChamberDocumentsConditionInput
  $input: UpdateChamberDocumentsInput!
) {
  updateChamberDocuments(condition: $condition, input: $input) {
    category
    createdAt
    data
    file_path
    id
    title
    updatedAt
    uploaded_by
    version
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateChamberDocumentsMutationVariables,
  APITypes.UpdateChamberDocumentsMutation
>;
export const updateChatMessages = /* GraphQL */ `mutation UpdateChatMessages(
  $condition: ModelChatMessagesConditionInput
  $input: UpdateChatMessagesInput!
) {
  updateChatMessages(condition: $condition, input: $input) {
    createdAt
    data
    id
    message
    receiver
    sender
    timestamp
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateChatMessagesMutationVariables,
  APITypes.UpdateChatMessagesMutation
>;
export const updateChecklists = /* GraphQL */ `mutation UpdateChecklists(
  $condition: ModelChecklistsConditionInput
  $input: UpdateChecklistsInput!
) {
  updateChecklists(condition: $condition, input: $input) {
    assigned_to
    createdAt
    data
    description
    id
    status
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateChecklistsMutationVariables,
  APITypes.UpdateChecklistsMutation
>;
export const updateClientDocuments = /* GraphQL */ `mutation UpdateClientDocuments(
  $condition: ModelClientDocumentsConditionInput
  $input: UpdateClientDocumentsInput!
) {
  updateClientDocuments(condition: $condition, input: $input) {
    client_id
    createdAt
    data
    file_path
    id
    is_signed
    title
    updatedAt
    uploaded_by
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateClientDocumentsMutationVariables,
  APITypes.UpdateClientDocumentsMutation
>;
export const updateClients = /* GraphQL */ `mutation UpdateClients(
  $condition: ModelClientsConditionInput
  $input: UpdateClientsInput!
) {
  updateClients(condition: $condition, input: $input) {
    address
    balance_due
    createdAt
    data
    email
    id
    name
    phone
    type_of_work
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateClientsMutationVariables,
  APITypes.UpdateClientsMutation
>;
export const updateCommunicationLogs = /* GraphQL */ `mutation UpdateCommunicationLogs(
  $condition: ModelCommunicationLogsConditionInput
  $input: UpdateCommunicationLogsInput!
) {
  updateCommunicationLogs(condition: $condition, input: $input) {
    client_id
    createdAt
    data
    date
    id
    medium
    notes
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateCommunicationLogsMutationVariables,
  APITypes.UpdateCommunicationLogsMutation
>;
export const updateDailyCasePayments = /* GraphQL */ `mutation UpdateDailyCasePayments(
  $condition: ModelDailyCasePaymentsConditionInput
  $input: UpdateDailyCasePaymentsInput!
) {
  updateDailyCasePayments(condition: $condition, input: $input) {
    amount
    case_id
    createdAt
    data
    id
    payment_date
    payment_mode
    received_by
    remarks
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateDailyCasePaymentsMutationVariables,
  APITypes.UpdateDailyCasePaymentsMutation
>;
export const updateDeals = /* GraphQL */ `mutation UpdateDeals(
  $condition: ModelDealsConditionInput
  $input: UpdateDealsInput!
) {
  updateDeals(condition: $condition, input: $input) {
    amount
    client_id
    createdAt
    data
    description
    id
    is_won
    name
    stage
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateDealsMutationVariables,
  APITypes.UpdateDealsMutation
>;
export const updateDocumentAuditLogs = /* GraphQL */ `mutation UpdateDocumentAuditLogs(
  $condition: ModelDocumentAuditLogsConditionInput
  $input: UpdateDocumentAuditLogsInput!
) {
  updateDocumentAuditLogs(condition: $condition, input: $input) {
    action
    createdAt
    data
    details
    document_id
    id
    updatedAt
    user_id
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateDocumentAuditLogsMutationVariables,
  APITypes.UpdateDocumentAuditLogsMutation
>;
export const updateDocumentTemplates = /* GraphQL */ `mutation UpdateDocumentTemplates(
  $condition: ModelDocumentTemplatesConditionInput
  $input: UpdateDocumentTemplatesInput!
) {
  updateDocumentTemplates(condition: $condition, input: $input) {
    createdAt
    data
    description
    file_path
    id
    name
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateDocumentTemplatesMutationVariables,
  APITypes.UpdateDocumentTemplatesMutation
>;
export const updateExpenses = /* GraphQL */ `mutation UpdateExpenses(
  $condition: ModelExpensesConditionInput
  $input: UpdateExpensesInput!
) {
  updateExpenses(condition: $condition, input: $input) {
    amount
    category
    createdAt
    data
    date
    description
    id
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateExpensesMutationVariables,
  APITypes.UpdateExpensesMutation
>;
export const updateInwardPosts = /* GraphQL */ `mutation UpdateInwardPosts(
  $condition: ModelInwardPostsConditionInput
  $input: UpdateInwardPostsInput!
) {
  updateInwardPosts(condition: $condition, input: $input) {
    assigned_to
    createdAt
    data
    id
    received_date
    sender
    status
    subject
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateInwardPostsMutationVariables,
  APITypes.UpdateInwardPostsMutation
>;
export const updateLeads = /* GraphQL */ `mutation UpdateLeads(
  $condition: ModelLeadsConditionInput
  $input: UpdateLeadsInput!
) {
  updateLeads(condition: $condition, input: $input) {
    createdAt
    data
    email
    id
    name
    phone
    source
    status
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateLeadsMutationVariables,
  APITypes.UpdateLeadsMutation
>;
export const updateMeetings = /* GraphQL */ `mutation UpdateMeetings(
  $condition: ModelMeetingsConditionInput
  $input: UpdateMeetingsInput!
) {
  updateMeetings(condition: $condition, input: $input) {
    attendees
    createdAt
    data
    id
    location
    meeting_date
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateMeetingsMutationVariables,
  APITypes.UpdateMeetingsMutation
>;
export const updateMessages = /* GraphQL */ `mutation UpdateMessages(
  $condition: ModelMessagesConditionInput
  $input: UpdateMessagesInput!
) {
  updateMessages(condition: $condition, input: $input) {
    content
    createdAt
    data
    id
    is_read
    receiver_id
    sender_id
    sent_at
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateMessagesMutationVariables,
  APITypes.UpdateMessagesMutation
>;
export const updateServiceItems = /* GraphQL */ `mutation UpdateServiceItems(
  $condition: ModelServiceItemsConditionInput
  $input: UpdateServiceItemsInput!
) {
  updateServiceItems(condition: $condition, input: $input) {
    category
    createdAt
    data
    id
    name
    price
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateServiceItemsMutationVariables,
  APITypes.UpdateServiceItemsMutation
>;
export const updateStaffAttendance = /* GraphQL */ `mutation UpdateStaffAttendance(
  $condition: ModelStaffAttendanceConditionInput
  $input: UpdateStaffAttendanceInput!
) {
  updateStaffAttendance(condition: $condition, input: $input) {
    attendance_date
    check_in_time
    check_out_time
    createdAt
    data
    id
    updatedAt
    user_id
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateStaffAttendanceMutationVariables,
  APITypes.UpdateStaffAttendanceMutation
>;
export const updateTasks = /* GraphQL */ `mutation UpdateTasks(
  $condition: ModelTasksConditionInput
  $input: UpdateTasksInput!
) {
  updateTasks(condition: $condition, input: $input) {
    assigned_to
    createdAt
    data
    description
    due_date
    id
    status
    title
    updatedAt
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateTasksMutationVariables,
  APITypes.UpdateTasksMutation
>;
export const updateUsers = /* GraphQL */ `mutation UpdateUsers(
  $condition: ModelUsersConditionInput
  $input: UpdateUsersInput!
) {
  updateUsers(condition: $condition, input: $input) {
    createdAt
    data
    email
    id
    name
    password
    role
    updatedAt
    username
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateUsersMutationVariables,
  APITypes.UpdateUsersMutation
>;
export const updateVaultFiles = /* GraphQL */ `mutation UpdateVaultFiles(
  $condition: ModelVaultFilesConditionInput
  $input: UpdateVaultFilesInput!
) {
  updateVaultFiles(condition: $condition, input: $input) {
    createdAt
    data
    file_name
    id
    is_encrypted
    storage_path
    updatedAt
    uploaded_by
    __typename
  }
}
` as GeneratedMutation<
  APITypes.UpdateVaultFilesMutationVariables,
  APITypes.UpdateVaultFilesMutation
>;
