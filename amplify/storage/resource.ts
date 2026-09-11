import { defineStorage } from '@aws-amplify/backend';

export const storage = defineStorage({
  name: 'legalStorage',
  access: (allow) => ({
    'client-files/*': [
      allow.groups(['Admin', 'Manager']).to(['read', 'write', 'delete']),
      allow.groups(['Staff']).to(['read'])
    ],
    'vault/*': [
      allow.groups(['Admin', 'Manager']).to(['read', 'write', 'delete'])
    ],
  })
});
