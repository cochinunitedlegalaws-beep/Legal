/* tslint:disable */
/* eslint-disable */
// this is an auto generated file. This will be overwritten

import * as APITypes from "./API";
type GeneratedSubscription<InputType, OutputType> = string & {
  __generatedSubscriptionInput: InputType;
  __generatedSubscriptionOutput: OutputType;
};

export const onCreateActivityLogs = /* GraphQL */ `subscription OnCreateActivityLogs(
  $filter: ModelSubscriptionActivityLogsFilterInput
) {
  onCreateActivityLogs(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateActivityLogsSubscriptionVariables,
  APITypes.OnCreateActivityLogsSubscription
>;
export const onCreateApprovals = /* GraphQL */ `subscription OnCreateApprovals($filter: ModelSubscriptionApprovalsFilterInput) {
  onCreateApprovals(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateApprovalsSubscriptionVariables,
  APITypes.OnCreateApprovalsSubscription
>;
export const onCreateBillings = /* GraphQL */ `subscription OnCreateBillings($filter: ModelSubscriptionBillingsFilterInput) {
  onCreateBillings(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateBillingsSubscriptionVariables,
  APITypes.OnCreateBillingsSubscription
>;
export const onCreateCases = /* GraphQL */ `subscription OnCreateCases($filter: ModelSubscriptionCasesFilterInput) {
  onCreateCases(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateCasesSubscriptionVariables,
  APITypes.OnCreateCasesSubscription
>;
export const onCreateChamberDocuments = /* GraphQL */ `subscription OnCreateChamberDocuments(
  $filter: ModelSubscriptionChamberDocumentsFilterInput
) {
  onCreateChamberDocuments(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateChamberDocumentsSubscriptionVariables,
  APITypes.OnCreateChamberDocumentsSubscription
>;
export const onCreateChatMessages = /* GraphQL */ `subscription OnCreateChatMessages(
  $filter: ModelSubscriptionChatMessagesFilterInput
) {
  onCreateChatMessages(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateChatMessagesSubscriptionVariables,
  APITypes.OnCreateChatMessagesSubscription
>;
export const onCreateChecklists = /* GraphQL */ `subscription OnCreateChecklists(
  $filter: ModelSubscriptionChecklistsFilterInput
) {
  onCreateChecklists(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateChecklistsSubscriptionVariables,
  APITypes.OnCreateChecklistsSubscription
>;
export const onCreateClientDocuments = /* GraphQL */ `subscription OnCreateClientDocuments(
  $filter: ModelSubscriptionClientDocumentsFilterInput
) {
  onCreateClientDocuments(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateClientDocumentsSubscriptionVariables,
  APITypes.OnCreateClientDocumentsSubscription
>;
export const onCreateClients = /* GraphQL */ `subscription OnCreateClients($filter: ModelSubscriptionClientsFilterInput) {
  onCreateClients(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateClientsSubscriptionVariables,
  APITypes.OnCreateClientsSubscription
>;
export const onCreateCommunicationLogs = /* GraphQL */ `subscription OnCreateCommunicationLogs(
  $filter: ModelSubscriptionCommunicationLogsFilterInput
) {
  onCreateCommunicationLogs(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateCommunicationLogsSubscriptionVariables,
  APITypes.OnCreateCommunicationLogsSubscription
>;
export const onCreateDailyCasePayments = /* GraphQL */ `subscription OnCreateDailyCasePayments(
  $filter: ModelSubscriptionDailyCasePaymentsFilterInput
) {
  onCreateDailyCasePayments(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateDailyCasePaymentsSubscriptionVariables,
  APITypes.OnCreateDailyCasePaymentsSubscription
>;
export const onCreateDeals = /* GraphQL */ `subscription OnCreateDeals($filter: ModelSubscriptionDealsFilterInput) {
  onCreateDeals(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateDealsSubscriptionVariables,
  APITypes.OnCreateDealsSubscription
>;
export const onCreateDocumentAuditLogs = /* GraphQL */ `subscription OnCreateDocumentAuditLogs(
  $filter: ModelSubscriptionDocumentAuditLogsFilterInput
) {
  onCreateDocumentAuditLogs(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateDocumentAuditLogsSubscriptionVariables,
  APITypes.OnCreateDocumentAuditLogsSubscription
>;
export const onCreateDocumentTemplates = /* GraphQL */ `subscription OnCreateDocumentTemplates(
  $filter: ModelSubscriptionDocumentTemplatesFilterInput
) {
  onCreateDocumentTemplates(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateDocumentTemplatesSubscriptionVariables,
  APITypes.OnCreateDocumentTemplatesSubscription
>;
export const onCreateExpenses = /* GraphQL */ `subscription OnCreateExpenses($filter: ModelSubscriptionExpensesFilterInput) {
  onCreateExpenses(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateExpensesSubscriptionVariables,
  APITypes.OnCreateExpensesSubscription
>;
export const onCreateInwardPosts = /* GraphQL */ `subscription OnCreateInwardPosts(
  $filter: ModelSubscriptionInwardPostsFilterInput
) {
  onCreateInwardPosts(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateInwardPostsSubscriptionVariables,
  APITypes.OnCreateInwardPostsSubscription
>;
export const onCreateLeads = /* GraphQL */ `subscription OnCreateLeads($filter: ModelSubscriptionLeadsFilterInput) {
  onCreateLeads(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateLeadsSubscriptionVariables,
  APITypes.OnCreateLeadsSubscription
>;
export const onCreateMeetings = /* GraphQL */ `subscription OnCreateMeetings($filter: ModelSubscriptionMeetingsFilterInput) {
  onCreateMeetings(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateMeetingsSubscriptionVariables,
  APITypes.OnCreateMeetingsSubscription
>;
export const onCreateMessages = /* GraphQL */ `subscription OnCreateMessages($filter: ModelSubscriptionMessagesFilterInput) {
  onCreateMessages(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateMessagesSubscriptionVariables,
  APITypes.OnCreateMessagesSubscription
>;
export const onCreateServiceItems = /* GraphQL */ `subscription OnCreateServiceItems(
  $filter: ModelSubscriptionServiceItemsFilterInput
) {
  onCreateServiceItems(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateServiceItemsSubscriptionVariables,
  APITypes.OnCreateServiceItemsSubscription
>;
export const onCreateStaffAttendance = /* GraphQL */ `subscription OnCreateStaffAttendance(
  $filter: ModelSubscriptionStaffAttendanceFilterInput
) {
  onCreateStaffAttendance(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateStaffAttendanceSubscriptionVariables,
  APITypes.OnCreateStaffAttendanceSubscription
>;
export const onCreateTasks = /* GraphQL */ `subscription OnCreateTasks($filter: ModelSubscriptionTasksFilterInput) {
  onCreateTasks(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateTasksSubscriptionVariables,
  APITypes.OnCreateTasksSubscription
>;
export const onCreateUsers = /* GraphQL */ `subscription OnCreateUsers($filter: ModelSubscriptionUsersFilterInput) {
  onCreateUsers(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateUsersSubscriptionVariables,
  APITypes.OnCreateUsersSubscription
>;
export const onCreateVaultFiles = /* GraphQL */ `subscription OnCreateVaultFiles(
  $filter: ModelSubscriptionVaultFilesFilterInput
) {
  onCreateVaultFiles(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnCreateVaultFilesSubscriptionVariables,
  APITypes.OnCreateVaultFilesSubscription
>;
export const onDeleteActivityLogs = /* GraphQL */ `subscription OnDeleteActivityLogs(
  $filter: ModelSubscriptionActivityLogsFilterInput
) {
  onDeleteActivityLogs(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteActivityLogsSubscriptionVariables,
  APITypes.OnDeleteActivityLogsSubscription
>;
export const onDeleteApprovals = /* GraphQL */ `subscription OnDeleteApprovals($filter: ModelSubscriptionApprovalsFilterInput) {
  onDeleteApprovals(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteApprovalsSubscriptionVariables,
  APITypes.OnDeleteApprovalsSubscription
>;
export const onDeleteBillings = /* GraphQL */ `subscription OnDeleteBillings($filter: ModelSubscriptionBillingsFilterInput) {
  onDeleteBillings(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteBillingsSubscriptionVariables,
  APITypes.OnDeleteBillingsSubscription
>;
export const onDeleteCases = /* GraphQL */ `subscription OnDeleteCases($filter: ModelSubscriptionCasesFilterInput) {
  onDeleteCases(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteCasesSubscriptionVariables,
  APITypes.OnDeleteCasesSubscription
>;
export const onDeleteChamberDocuments = /* GraphQL */ `subscription OnDeleteChamberDocuments(
  $filter: ModelSubscriptionChamberDocumentsFilterInput
) {
  onDeleteChamberDocuments(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteChamberDocumentsSubscriptionVariables,
  APITypes.OnDeleteChamberDocumentsSubscription
>;
export const onDeleteChatMessages = /* GraphQL */ `subscription OnDeleteChatMessages(
  $filter: ModelSubscriptionChatMessagesFilterInput
) {
  onDeleteChatMessages(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteChatMessagesSubscriptionVariables,
  APITypes.OnDeleteChatMessagesSubscription
>;
export const onDeleteChecklists = /* GraphQL */ `subscription OnDeleteChecklists(
  $filter: ModelSubscriptionChecklistsFilterInput
) {
  onDeleteChecklists(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteChecklistsSubscriptionVariables,
  APITypes.OnDeleteChecklistsSubscription
>;
export const onDeleteClientDocuments = /* GraphQL */ `subscription OnDeleteClientDocuments(
  $filter: ModelSubscriptionClientDocumentsFilterInput
) {
  onDeleteClientDocuments(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteClientDocumentsSubscriptionVariables,
  APITypes.OnDeleteClientDocumentsSubscription
>;
export const onDeleteClients = /* GraphQL */ `subscription OnDeleteClients($filter: ModelSubscriptionClientsFilterInput) {
  onDeleteClients(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteClientsSubscriptionVariables,
  APITypes.OnDeleteClientsSubscription
>;
export const onDeleteCommunicationLogs = /* GraphQL */ `subscription OnDeleteCommunicationLogs(
  $filter: ModelSubscriptionCommunicationLogsFilterInput
) {
  onDeleteCommunicationLogs(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteCommunicationLogsSubscriptionVariables,
  APITypes.OnDeleteCommunicationLogsSubscription
>;
export const onDeleteDailyCasePayments = /* GraphQL */ `subscription OnDeleteDailyCasePayments(
  $filter: ModelSubscriptionDailyCasePaymentsFilterInput
) {
  onDeleteDailyCasePayments(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteDailyCasePaymentsSubscriptionVariables,
  APITypes.OnDeleteDailyCasePaymentsSubscription
>;
export const onDeleteDeals = /* GraphQL */ `subscription OnDeleteDeals($filter: ModelSubscriptionDealsFilterInput) {
  onDeleteDeals(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteDealsSubscriptionVariables,
  APITypes.OnDeleteDealsSubscription
>;
export const onDeleteDocumentAuditLogs = /* GraphQL */ `subscription OnDeleteDocumentAuditLogs(
  $filter: ModelSubscriptionDocumentAuditLogsFilterInput
) {
  onDeleteDocumentAuditLogs(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteDocumentAuditLogsSubscriptionVariables,
  APITypes.OnDeleteDocumentAuditLogsSubscription
>;
export const onDeleteDocumentTemplates = /* GraphQL */ `subscription OnDeleteDocumentTemplates(
  $filter: ModelSubscriptionDocumentTemplatesFilterInput
) {
  onDeleteDocumentTemplates(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteDocumentTemplatesSubscriptionVariables,
  APITypes.OnDeleteDocumentTemplatesSubscription
>;
export const onDeleteExpenses = /* GraphQL */ `subscription OnDeleteExpenses($filter: ModelSubscriptionExpensesFilterInput) {
  onDeleteExpenses(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteExpensesSubscriptionVariables,
  APITypes.OnDeleteExpensesSubscription
>;
export const onDeleteInwardPosts = /* GraphQL */ `subscription OnDeleteInwardPosts(
  $filter: ModelSubscriptionInwardPostsFilterInput
) {
  onDeleteInwardPosts(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteInwardPostsSubscriptionVariables,
  APITypes.OnDeleteInwardPostsSubscription
>;
export const onDeleteLeads = /* GraphQL */ `subscription OnDeleteLeads($filter: ModelSubscriptionLeadsFilterInput) {
  onDeleteLeads(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteLeadsSubscriptionVariables,
  APITypes.OnDeleteLeadsSubscription
>;
export const onDeleteMeetings = /* GraphQL */ `subscription OnDeleteMeetings($filter: ModelSubscriptionMeetingsFilterInput) {
  onDeleteMeetings(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteMeetingsSubscriptionVariables,
  APITypes.OnDeleteMeetingsSubscription
>;
export const onDeleteMessages = /* GraphQL */ `subscription OnDeleteMessages($filter: ModelSubscriptionMessagesFilterInput) {
  onDeleteMessages(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteMessagesSubscriptionVariables,
  APITypes.OnDeleteMessagesSubscription
>;
export const onDeleteServiceItems = /* GraphQL */ `subscription OnDeleteServiceItems(
  $filter: ModelSubscriptionServiceItemsFilterInput
) {
  onDeleteServiceItems(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteServiceItemsSubscriptionVariables,
  APITypes.OnDeleteServiceItemsSubscription
>;
export const onDeleteStaffAttendance = /* GraphQL */ `subscription OnDeleteStaffAttendance(
  $filter: ModelSubscriptionStaffAttendanceFilterInput
) {
  onDeleteStaffAttendance(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteStaffAttendanceSubscriptionVariables,
  APITypes.OnDeleteStaffAttendanceSubscription
>;
export const onDeleteTasks = /* GraphQL */ `subscription OnDeleteTasks($filter: ModelSubscriptionTasksFilterInput) {
  onDeleteTasks(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteTasksSubscriptionVariables,
  APITypes.OnDeleteTasksSubscription
>;
export const onDeleteUsers = /* GraphQL */ `subscription OnDeleteUsers($filter: ModelSubscriptionUsersFilterInput) {
  onDeleteUsers(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteUsersSubscriptionVariables,
  APITypes.OnDeleteUsersSubscription
>;
export const onDeleteVaultFiles = /* GraphQL */ `subscription OnDeleteVaultFiles(
  $filter: ModelSubscriptionVaultFilesFilterInput
) {
  onDeleteVaultFiles(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnDeleteVaultFilesSubscriptionVariables,
  APITypes.OnDeleteVaultFilesSubscription
>;
export const onUpdateActivityLogs = /* GraphQL */ `subscription OnUpdateActivityLogs(
  $filter: ModelSubscriptionActivityLogsFilterInput
) {
  onUpdateActivityLogs(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateActivityLogsSubscriptionVariables,
  APITypes.OnUpdateActivityLogsSubscription
>;
export const onUpdateApprovals = /* GraphQL */ `subscription OnUpdateApprovals($filter: ModelSubscriptionApprovalsFilterInput) {
  onUpdateApprovals(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateApprovalsSubscriptionVariables,
  APITypes.OnUpdateApprovalsSubscription
>;
export const onUpdateBillings = /* GraphQL */ `subscription OnUpdateBillings($filter: ModelSubscriptionBillingsFilterInput) {
  onUpdateBillings(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateBillingsSubscriptionVariables,
  APITypes.OnUpdateBillingsSubscription
>;
export const onUpdateCases = /* GraphQL */ `subscription OnUpdateCases($filter: ModelSubscriptionCasesFilterInput) {
  onUpdateCases(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateCasesSubscriptionVariables,
  APITypes.OnUpdateCasesSubscription
>;
export const onUpdateChamberDocuments = /* GraphQL */ `subscription OnUpdateChamberDocuments(
  $filter: ModelSubscriptionChamberDocumentsFilterInput
) {
  onUpdateChamberDocuments(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateChamberDocumentsSubscriptionVariables,
  APITypes.OnUpdateChamberDocumentsSubscription
>;
export const onUpdateChatMessages = /* GraphQL */ `subscription OnUpdateChatMessages(
  $filter: ModelSubscriptionChatMessagesFilterInput
) {
  onUpdateChatMessages(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateChatMessagesSubscriptionVariables,
  APITypes.OnUpdateChatMessagesSubscription
>;
export const onUpdateChecklists = /* GraphQL */ `subscription OnUpdateChecklists(
  $filter: ModelSubscriptionChecklistsFilterInput
) {
  onUpdateChecklists(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateChecklistsSubscriptionVariables,
  APITypes.OnUpdateChecklistsSubscription
>;
export const onUpdateClientDocuments = /* GraphQL */ `subscription OnUpdateClientDocuments(
  $filter: ModelSubscriptionClientDocumentsFilterInput
) {
  onUpdateClientDocuments(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateClientDocumentsSubscriptionVariables,
  APITypes.OnUpdateClientDocumentsSubscription
>;
export const onUpdateClients = /* GraphQL */ `subscription OnUpdateClients($filter: ModelSubscriptionClientsFilterInput) {
  onUpdateClients(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateClientsSubscriptionVariables,
  APITypes.OnUpdateClientsSubscription
>;
export const onUpdateCommunicationLogs = /* GraphQL */ `subscription OnUpdateCommunicationLogs(
  $filter: ModelSubscriptionCommunicationLogsFilterInput
) {
  onUpdateCommunicationLogs(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateCommunicationLogsSubscriptionVariables,
  APITypes.OnUpdateCommunicationLogsSubscription
>;
export const onUpdateDailyCasePayments = /* GraphQL */ `subscription OnUpdateDailyCasePayments(
  $filter: ModelSubscriptionDailyCasePaymentsFilterInput
) {
  onUpdateDailyCasePayments(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateDailyCasePaymentsSubscriptionVariables,
  APITypes.OnUpdateDailyCasePaymentsSubscription
>;
export const onUpdateDeals = /* GraphQL */ `subscription OnUpdateDeals($filter: ModelSubscriptionDealsFilterInput) {
  onUpdateDeals(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateDealsSubscriptionVariables,
  APITypes.OnUpdateDealsSubscription
>;
export const onUpdateDocumentAuditLogs = /* GraphQL */ `subscription OnUpdateDocumentAuditLogs(
  $filter: ModelSubscriptionDocumentAuditLogsFilterInput
) {
  onUpdateDocumentAuditLogs(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateDocumentAuditLogsSubscriptionVariables,
  APITypes.OnUpdateDocumentAuditLogsSubscription
>;
export const onUpdateDocumentTemplates = /* GraphQL */ `subscription OnUpdateDocumentTemplates(
  $filter: ModelSubscriptionDocumentTemplatesFilterInput
) {
  onUpdateDocumentTemplates(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateDocumentTemplatesSubscriptionVariables,
  APITypes.OnUpdateDocumentTemplatesSubscription
>;
export const onUpdateExpenses = /* GraphQL */ `subscription OnUpdateExpenses($filter: ModelSubscriptionExpensesFilterInput) {
  onUpdateExpenses(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateExpensesSubscriptionVariables,
  APITypes.OnUpdateExpensesSubscription
>;
export const onUpdateInwardPosts = /* GraphQL */ `subscription OnUpdateInwardPosts(
  $filter: ModelSubscriptionInwardPostsFilterInput
) {
  onUpdateInwardPosts(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateInwardPostsSubscriptionVariables,
  APITypes.OnUpdateInwardPostsSubscription
>;
export const onUpdateLeads = /* GraphQL */ `subscription OnUpdateLeads($filter: ModelSubscriptionLeadsFilterInput) {
  onUpdateLeads(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateLeadsSubscriptionVariables,
  APITypes.OnUpdateLeadsSubscription
>;
export const onUpdateMeetings = /* GraphQL */ `subscription OnUpdateMeetings($filter: ModelSubscriptionMeetingsFilterInput) {
  onUpdateMeetings(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateMeetingsSubscriptionVariables,
  APITypes.OnUpdateMeetingsSubscription
>;
export const onUpdateMessages = /* GraphQL */ `subscription OnUpdateMessages($filter: ModelSubscriptionMessagesFilterInput) {
  onUpdateMessages(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateMessagesSubscriptionVariables,
  APITypes.OnUpdateMessagesSubscription
>;
export const onUpdateServiceItems = /* GraphQL */ `subscription OnUpdateServiceItems(
  $filter: ModelSubscriptionServiceItemsFilterInput
) {
  onUpdateServiceItems(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateServiceItemsSubscriptionVariables,
  APITypes.OnUpdateServiceItemsSubscription
>;
export const onUpdateStaffAttendance = /* GraphQL */ `subscription OnUpdateStaffAttendance(
  $filter: ModelSubscriptionStaffAttendanceFilterInput
) {
  onUpdateStaffAttendance(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateStaffAttendanceSubscriptionVariables,
  APITypes.OnUpdateStaffAttendanceSubscription
>;
export const onUpdateTasks = /* GraphQL */ `subscription OnUpdateTasks($filter: ModelSubscriptionTasksFilterInput) {
  onUpdateTasks(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateTasksSubscriptionVariables,
  APITypes.OnUpdateTasksSubscription
>;
export const onUpdateUsers = /* GraphQL */ `subscription OnUpdateUsers($filter: ModelSubscriptionUsersFilterInput) {
  onUpdateUsers(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateUsersSubscriptionVariables,
  APITypes.OnUpdateUsersSubscription
>;
export const onUpdateVaultFiles = /* GraphQL */ `subscription OnUpdateVaultFiles(
  $filter: ModelSubscriptionVaultFilesFilterInput
) {
  onUpdateVaultFiles(filter: $filter) {
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
` as GeneratedSubscription<
  APITypes.OnUpdateVaultFilesSubscriptionVariables,
  APITypes.OnUpdateVaultFilesSubscription
>;
