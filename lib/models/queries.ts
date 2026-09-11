/* tslint:disable */
/* eslint-disable */
// this is an auto generated file. This will be overwritten

import * as APITypes from "./API";
type GeneratedQuery<InputType, OutputType> = string & {
  __generatedQueryInput: InputType;
  __generatedQueryOutput: OutputType;
};

export const getActivityLogs = /* GraphQL */ `query GetActivityLogs($id: ID!) {
  getActivityLogs(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetActivityLogsQueryVariables,
  APITypes.GetActivityLogsQuery
>;
export const getApprovals = /* GraphQL */ `query GetApprovals($id: ID!) {
  getApprovals(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetApprovalsQueryVariables,
  APITypes.GetApprovalsQuery
>;
export const getBillings = /* GraphQL */ `query GetBillings($id: ID!) {
  getBillings(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetBillingsQueryVariables,
  APITypes.GetBillingsQuery
>;
export const getCases = /* GraphQL */ `query GetCases($id: ID!) {
  getCases(id: $id) {
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
` as GeneratedQuery<APITypes.GetCasesQueryVariables, APITypes.GetCasesQuery>;
export const getChamberDocuments = /* GraphQL */ `query GetChamberDocuments($id: ID!) {
  getChamberDocuments(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetChamberDocumentsQueryVariables,
  APITypes.GetChamberDocumentsQuery
>;
export const getChatMessages = /* GraphQL */ `query GetChatMessages($id: ID!) {
  getChatMessages(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetChatMessagesQueryVariables,
  APITypes.GetChatMessagesQuery
>;
export const getChecklists = /* GraphQL */ `query GetChecklists($id: ID!) {
  getChecklists(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetChecklistsQueryVariables,
  APITypes.GetChecklistsQuery
>;
export const getClientDocuments = /* GraphQL */ `query GetClientDocuments($id: ID!) {
  getClientDocuments(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetClientDocumentsQueryVariables,
  APITypes.GetClientDocumentsQuery
>;
export const getClients = /* GraphQL */ `query GetClients($id: ID!) {
  getClients(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetClientsQueryVariables,
  APITypes.GetClientsQuery
>;
export const getCommunicationLogs = /* GraphQL */ `query GetCommunicationLogs($id: ID!) {
  getCommunicationLogs(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetCommunicationLogsQueryVariables,
  APITypes.GetCommunicationLogsQuery
>;
export const getDailyCasePayments = /* GraphQL */ `query GetDailyCasePayments($id: ID!) {
  getDailyCasePayments(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetDailyCasePaymentsQueryVariables,
  APITypes.GetDailyCasePaymentsQuery
>;
export const getDeals = /* GraphQL */ `query GetDeals($id: ID!) {
  getDeals(id: $id) {
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
` as GeneratedQuery<APITypes.GetDealsQueryVariables, APITypes.GetDealsQuery>;
export const getDocumentAuditLogs = /* GraphQL */ `query GetDocumentAuditLogs($id: ID!) {
  getDocumentAuditLogs(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetDocumentAuditLogsQueryVariables,
  APITypes.GetDocumentAuditLogsQuery
>;
export const getDocumentTemplates = /* GraphQL */ `query GetDocumentTemplates($id: ID!) {
  getDocumentTemplates(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetDocumentTemplatesQueryVariables,
  APITypes.GetDocumentTemplatesQuery
>;
export const getExpenses = /* GraphQL */ `query GetExpenses($id: ID!) {
  getExpenses(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetExpensesQueryVariables,
  APITypes.GetExpensesQuery
>;
export const getInwardPosts = /* GraphQL */ `query GetInwardPosts($id: ID!) {
  getInwardPosts(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetInwardPostsQueryVariables,
  APITypes.GetInwardPostsQuery
>;
export const getLeads = /* GraphQL */ `query GetLeads($id: ID!) {
  getLeads(id: $id) {
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
` as GeneratedQuery<APITypes.GetLeadsQueryVariables, APITypes.GetLeadsQuery>;
export const getMeetings = /* GraphQL */ `query GetMeetings($id: ID!) {
  getMeetings(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetMeetingsQueryVariables,
  APITypes.GetMeetingsQuery
>;
export const getMessages = /* GraphQL */ `query GetMessages($id: ID!) {
  getMessages(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetMessagesQueryVariables,
  APITypes.GetMessagesQuery
>;
export const getServiceItems = /* GraphQL */ `query GetServiceItems($id: ID!) {
  getServiceItems(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetServiceItemsQueryVariables,
  APITypes.GetServiceItemsQuery
>;
export const getStaffAttendance = /* GraphQL */ `query GetStaffAttendance($id: ID!) {
  getStaffAttendance(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetStaffAttendanceQueryVariables,
  APITypes.GetStaffAttendanceQuery
>;
export const getTasks = /* GraphQL */ `query GetTasks($id: ID!) {
  getTasks(id: $id) {
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
` as GeneratedQuery<APITypes.GetTasksQueryVariables, APITypes.GetTasksQuery>;
export const getUsers = /* GraphQL */ `query GetUsers($id: ID!) {
  getUsers(id: $id) {
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
` as GeneratedQuery<APITypes.GetUsersQueryVariables, APITypes.GetUsersQuery>;
export const getVaultFiles = /* GraphQL */ `query GetVaultFiles($id: ID!) {
  getVaultFiles(id: $id) {
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
` as GeneratedQuery<
  APITypes.GetVaultFilesQueryVariables,
  APITypes.GetVaultFilesQuery
>;
export const listActivityLogs = /* GraphQL */ `query ListActivityLogs(
  $filter: ModelActivityLogsFilterInput
  $limit: Int
  $nextToken: String
) {
  listActivityLogs(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListActivityLogsQueryVariables,
  APITypes.ListActivityLogsQuery
>;
export const listApprovals = /* GraphQL */ `query ListApprovals(
  $filter: ModelApprovalsFilterInput
  $limit: Int
  $nextToken: String
) {
  listApprovals(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListApprovalsQueryVariables,
  APITypes.ListApprovalsQuery
>;
export const listBillings = /* GraphQL */ `query ListBillings(
  $filter: ModelBillingsFilterInput
  $limit: Int
  $nextToken: String
) {
  listBillings(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListBillingsQueryVariables,
  APITypes.ListBillingsQuery
>;
export const listCases = /* GraphQL */ `query ListCases(
  $filter: ModelCasesFilterInput
  $limit: Int
  $nextToken: String
) {
  listCases(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<APITypes.ListCasesQueryVariables, APITypes.ListCasesQuery>;
export const listChamberDocuments = /* GraphQL */ `query ListChamberDocuments(
  $filter: ModelChamberDocumentsFilterInput
  $limit: Int
  $nextToken: String
) {
  listChamberDocuments(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListChamberDocumentsQueryVariables,
  APITypes.ListChamberDocumentsQuery
>;
export const listChatMessages = /* GraphQL */ `query ListChatMessages(
  $filter: ModelChatMessagesFilterInput
  $limit: Int
  $nextToken: String
) {
  listChatMessages(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListChatMessagesQueryVariables,
  APITypes.ListChatMessagesQuery
>;
export const listChecklists = /* GraphQL */ `query ListChecklists(
  $filter: ModelChecklistsFilterInput
  $limit: Int
  $nextToken: String
) {
  listChecklists(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListChecklistsQueryVariables,
  APITypes.ListChecklistsQuery
>;
export const listClientDocuments = /* GraphQL */ `query ListClientDocuments(
  $filter: ModelClientDocumentsFilterInput
  $limit: Int
  $nextToken: String
) {
  listClientDocuments(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListClientDocumentsQueryVariables,
  APITypes.ListClientDocumentsQuery
>;
export const listClients = /* GraphQL */ `query ListClients(
  $filter: ModelClientsFilterInput
  $limit: Int
  $nextToken: String
) {
  listClients(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListClientsQueryVariables,
  APITypes.ListClientsQuery
>;
export const listCommunicationLogs = /* GraphQL */ `query ListCommunicationLogs(
  $filter: ModelCommunicationLogsFilterInput
  $limit: Int
  $nextToken: String
) {
  listCommunicationLogs(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListCommunicationLogsQueryVariables,
  APITypes.ListCommunicationLogsQuery
>;
export const listDailyCasePayments = /* GraphQL */ `query ListDailyCasePayments(
  $filter: ModelDailyCasePaymentsFilterInput
  $limit: Int
  $nextToken: String
) {
  listDailyCasePayments(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListDailyCasePaymentsQueryVariables,
  APITypes.ListDailyCasePaymentsQuery
>;
export const listDeals = /* GraphQL */ `query ListDeals(
  $filter: ModelDealsFilterInput
  $limit: Int
  $nextToken: String
) {
  listDeals(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<APITypes.ListDealsQueryVariables, APITypes.ListDealsQuery>;
export const listDocumentAuditLogs = /* GraphQL */ `query ListDocumentAuditLogs(
  $filter: ModelDocumentAuditLogsFilterInput
  $limit: Int
  $nextToken: String
) {
  listDocumentAuditLogs(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListDocumentAuditLogsQueryVariables,
  APITypes.ListDocumentAuditLogsQuery
>;
export const listDocumentTemplates = /* GraphQL */ `query ListDocumentTemplates(
  $filter: ModelDocumentTemplatesFilterInput
  $limit: Int
  $nextToken: String
) {
  listDocumentTemplates(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
      createdAt
      data
      description
      file_path
      id
      name
      updatedAt
      __typename
    }
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListDocumentTemplatesQueryVariables,
  APITypes.ListDocumentTemplatesQuery
>;
export const listExpenses = /* GraphQL */ `query ListExpenses(
  $filter: ModelExpensesFilterInput
  $limit: Int
  $nextToken: String
) {
  listExpenses(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListExpensesQueryVariables,
  APITypes.ListExpensesQuery
>;
export const listInwardPosts = /* GraphQL */ `query ListInwardPosts(
  $filter: ModelInwardPostsFilterInput
  $limit: Int
  $nextToken: String
) {
  listInwardPosts(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListInwardPostsQueryVariables,
  APITypes.ListInwardPostsQuery
>;
export const listLeads = /* GraphQL */ `query ListLeads(
  $filter: ModelLeadsFilterInput
  $limit: Int
  $nextToken: String
) {
  listLeads(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<APITypes.ListLeadsQueryVariables, APITypes.ListLeadsQuery>;
export const listMeetings = /* GraphQL */ `query ListMeetings(
  $filter: ModelMeetingsFilterInput
  $limit: Int
  $nextToken: String
) {
  listMeetings(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListMeetingsQueryVariables,
  APITypes.ListMeetingsQuery
>;
export const listMessages = /* GraphQL */ `query ListMessages(
  $filter: ModelMessagesFilterInput
  $limit: Int
  $nextToken: String
) {
  listMessages(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListMessagesQueryVariables,
  APITypes.ListMessagesQuery
>;
export const listServiceItems = /* GraphQL */ `query ListServiceItems(
  $filter: ModelServiceItemsFilterInput
  $limit: Int
  $nextToken: String
) {
  listServiceItems(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
      category
      createdAt
      data
      id
      name
      price
      updatedAt
      __typename
    }
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListServiceItemsQueryVariables,
  APITypes.ListServiceItemsQuery
>;
export const listStaffAttendances = /* GraphQL */ `query ListStaffAttendances(
  $filter: ModelStaffAttendanceFilterInput
  $limit: Int
  $nextToken: String
) {
  listStaffAttendances(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListStaffAttendancesQueryVariables,
  APITypes.ListStaffAttendancesQuery
>;
export const listTasks = /* GraphQL */ `query ListTasks(
  $filter: ModelTasksFilterInput
  $limit: Int
  $nextToken: String
) {
  listTasks(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<APITypes.ListTasksQueryVariables, APITypes.ListTasksQuery>;
export const listUsers = /* GraphQL */ `query ListUsers(
  $filter: ModelUsersFilterInput
  $limit: Int
  $nextToken: String
) {
  listUsers(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<APITypes.ListUsersQueryVariables, APITypes.ListUsersQuery>;
export const listVaultFiles = /* GraphQL */ `query ListVaultFiles(
  $filter: ModelVaultFilesFilterInput
  $limit: Int
  $nextToken: String
) {
  listVaultFiles(filter: $filter, limit: $limit, nextToken: $nextToken) {
    items {
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
    nextToken
    __typename
  }
}
` as GeneratedQuery<
  APITypes.ListVaultFilesQueryVariables,
  APITypes.ListVaultFilesQuery
>;
