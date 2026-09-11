import { defineFunction, secret } from '@aws-amplify/backend';

export const customEmailSender = defineFunction({
  entry: './handler.ts',
  environment: {
    GMAIL_EMAIL: 'cochinunitedlegalaws@gmail.com',
    GMAIL_APP_PASSWORD: secret('GMAIL_APP_PASSWORD'),
  },
});
