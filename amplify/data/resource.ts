import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

const schema = a.schema({
  Approvals: a.model({
    status: a.string(),
    approved_at: a.string(),
    rejected_at: a.string(),
    reject_reason: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  ActivityLogs: a.model({
    user_id: a.integer(),
    action: a.string(),
    target_type: a.string(),
    target_id: a.string(),
    details: a.string(),
    created_at: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  Billings: a.model({
    invoice_no: a.string(),
    client_name: a.string(),
    date: a.string(),
    amount: a.string(),
    type: a.string(),
    data: a.string(),
    category: a.string(),
    authorities: a.string(),
    status: a.string(),
    payment_received: a.boolean(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read', 'create', 'update', 'delete'])]),

  Cases: a.model({
    client_id: a.integer(),
    title: a.string(),
    case_number: a.string(),
    status: a.string(),
    court_details: a.string(),
    next_hearing_date: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read', 'create', 'update'])]),

  ChamberDocuments: a.model({
    title: a.string(),
    file_path: a.string(),
    category: a.string(),
    uploaded_by: a.integer(),
    version: a.integer(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  Clients: a.model({
    name: a.string(),
    email: a.string(),
    phone: a.string(),
    address: a.string(),
    balance_due: a.string(),
    type_of_work: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read', 'delete'])]),

  ClientDocuments: a.model({
    client_id: a.integer(),
    title: a.string(),
    file_path: a.string(),
    uploaded_by: a.integer(),
    is_signed: a.boolean(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  DailyCasePayments: a.model({
    case_id: a.integer(),
    amount: a.string(),
    payment_date: a.string(),
    payment_mode: a.string(),
    received_by: a.integer(),
    remarks: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  DocumentAuditLogs: a.model({
    document_id: a.integer(),
    action: a.string(),
    user_id: a.integer(),
    details: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  Deals: a.model({
    name: a.string(),
    client_id: a.integer(),
    stage: a.string(),
    amount: a.float(),
    description: a.string(),
    is_won: a.boolean(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  Expenses: a.model({
    title: a.string(),
    amount: a.string(),
    category: a.string(),
    date: a.string(),
    description: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  InwardPosts: a.model({
    sender: a.string(),
    received_date: a.string(),
    subject: a.string(),
    status: a.string(),
    assigned_to: a.integer(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  Leads: a.model({
    name: a.string(),
    email: a.string(),
    phone: a.string(),
    status: a.string(),
    source: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  Meetings: a.model({
    title: a.string(),
    meeting_date: a.string(),
    location: a.string(),
    attendees: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  Messages: a.model({
    sender_id: a.integer(),
    receiver_id: a.integer(),
    content: a.string(),
    sent_at: a.string(),
    is_read: a.boolean(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  StaffAttendance: a.model({
    user_id: a.integer(),
    check_in_time: a.string(),
    check_out_time: a.string(),
    attendance_date: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  Tasks: a.model({
    title: a.string(),
    description: a.string(),
    assigned_to: a.integer(),
    status: a.string(),
    due_date: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read', 'create', 'update'])]),

  Users: a.model({
    username: a.string(),
    password: a.string(),
    role: a.string(),
    name: a.string(),
    email: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read', 'create', 'update'])]),

  VaultFiles: a.model({
    file_name: a.string(),
    storage_path: a.string(),
    uploaded_by: a.string(),
    is_encrypted: a.boolean(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),
  Checklists: a.model({
    title: a.string(),
    description: a.string(),
    status: a.string(),
    assigned_to: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  ChatMessages: a.model({
    sender: a.string(),
    receiver: a.string(),
    message: a.string(),
    timestamp: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  CommunicationLogs: a.model({
    client_id: a.string(),
    medium: a.string(),
    notes: a.string(),
    date: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  DocumentTemplates: a.model({
    name: a.string(),
    description: a.string(),
    file_path: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  ServiceItems: a.model({
    name: a.string(),
    price: a.string(),
    category: a.string(),
    data: a.json(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  ClientLicenses: a.model({
    client_id: a.integer(),
    license_type_id: a.integer(),
    file_no: a.string(),
    service_date: a.string(),
    expiry_date: a.string(),
    status: a.string(),
    notes: a.string(),
    created_at: a.string(),
    updated_at: a.string(),
    manual_client_name: a.string(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  LicenseBilling: a.model({
    client_license_id: a.integer(),
    amount: a.float(),
    payment_status: a.string(),
    invoice_no: a.string(),
    payment_date: a.string(),
    created_at: a.string(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  LicenseTypes: a.model({
    name: a.string(),
    description: a.string(),
    created_at: a.string(),
    updated_at: a.string(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  DealActivities: a.model({
    deal_id: a.integer(),
    type: a.string(),
    title: a.string(),
    description: a.string(),
    due_date: a.string(),
    is_completed: a.boolean(),
    created_by: a.integer(),
    created_at: a.string(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  DealAssignees: a.model({
    deal_id: a.integer(),
    user_id: a.integer(),
    role: a.string(),
    assigned_at: a.string(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  DealHandoverHistory: a.model({
    deal_id: a.integer(),
    from_user_id: a.integer(),
    to_user_id: a.integer(),
    note: a.string(),
    handed_over_at: a.string(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  DealStageHistory: a.model({
    deal_id: a.integer(),
    from_stage: a.string(),
    to_stage: a.string(),
    changed_by: a.integer(),
    changed_at: a.string(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  CompanyBills: a.model({
    category: a.string(),
    title: a.string(),
    amount: a.float(),
    bill_date: a.string(),
    status: a.string(),
    description: a.string(),
    created_at: a.string(),
    spent_by: a.integer(),
    spent_by_name: a.string(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),

  DscRecords: a.model({
    username: a.string(),
    password: a.string(),
    client_name: a.string(),
    email_id: a.string(),
    phone_no: a.string(),
    dsc_taken_date: a.string(),
    dsc_expiry_date: a.string(),
    created_at: a.string(),
    updated_at: a.string(),
  }).authorization(allow => [allow.group('Admin').to(['read', 'create', 'update', 'delete']), allow.group('Manager').to(['read', 'create', 'update', 'delete']), allow.group('Staff').to(['read'])]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'userPool'
    // apiKeyAuthorizationMode: { expiresInDays: 30 },
  },
});

