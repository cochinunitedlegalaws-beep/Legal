import { defineStorage } from '@aws-amplify/backend';

export const storage = defineStorage({
  name: 'legalStorage',
  access: (allow) => ({
    // Client files organized by client ID — personal docs, work docs, voice notes
    'client-files/*': [
      allow.groups(['Admin', 'Manager']).to(['read', 'write', 'delete']),
      allow.groups(['Staff']).to(['read'])
    ],
    // Vault — encrypted/sensitive tenant-isolated files
    'vault/*': [
      allow.groups(['Admin', 'Manager']).to(['read', 'write', 'delete'])
    ],
    // Public uploads — license documents, shared files
    'public/*': [
      allow.groups(['Admin', 'Manager']).to(['read', 'write', 'delete']),
      allow.groups(['Staff']).to(['read'])
    ],
    // Document templates and chamber documents
    'documents/*': [
      allow.groups(['Admin', 'Manager']).to(['read', 'write', 'delete']),
      allow.groups(['Staff']).to(['read'])
    ],
  })
});
