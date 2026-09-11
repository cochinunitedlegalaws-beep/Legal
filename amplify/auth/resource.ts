import { defineAuth, defineFunction } from '@aws-amplify/backend';

/**
 * Define and configure your auth resource
 * @see https://docs.amplify.aws/gen2/build-a-backend/auth
 */
export const auth = defineAuth({
  loginWith: {
    email: {
      verificationEmailStyle: "CODE",
      verificationEmailSubject: "Account Verification - Cochin United Legal LLP",
    },
  },
  triggers: {
    preSignUp: defineFunction({
      entry: './pre-sign-up/handler.ts',
    }),
  },
  groups: ["Admin", "Manager", "Staff"],
});
