import { CustomEmailSenderTriggerHandler } from 'aws-lambda';
import * as nodemailer from 'nodemailer';
import { buildClient, CommitmentPolicy, KmsKeyringNode } from '@aws-crypto/client-node';

const client = buildClient(CommitmentPolicy.REQUIRE_ENCRYPT_REQUIRE_DECRYPT);

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_EMAIL,
    pass: process.env.GMAIL_APP_PASSWORD,
  },
});

export const handler: CustomEmailSenderTriggerHandler = async (event) => {
  const generatorKeyId = process.env.KMS_KEY_ID;
  if (!generatorKeyId) {
    throw new Error('KMS_KEY_ID is not set');
  }
  
  const keyring = new KmsKeyringNode({ generatorKeyId });

  if (
    event.triggerSource === 'CustomEmailSender_SignUp' ||
    event.triggerSource === 'CustomEmailSender_ForgotPassword' ||
    event.triggerSource === 'CustomEmailSender_ResendCode'
  ) {
    const encryptedCode = event.request.code;
    if (encryptedCode) {
      try {
        const { plaintext } = await client.decrypt(keyring, Buffer.from(encryptedCode, 'base64'));
        const decryptedCode = plaintext.toString('utf-8');

        const mailOptions = {
          from: `"Cochin United Legal LLP" <${process.env.GMAIL_EMAIL}>`,
          to: event.request.userAttributes.email,
          subject: 'Account Verification - Cochin United Legal LLP',
          html: `<div style="font-family: 'Georgia', serif; background-color: #0A0A0A; color: #FFF7D6; padding: 50px; text-align: center; border: 1px solid #D4AF37; border-radius: 16px; max-width: 600px; margin: 0 auto; box-shadow: 0 10px 30px rgba(0,0,0,0.5);"><h2 style="color: #D4AF37; font-size: 26px; letter-spacing: 3px; margin-bottom: 5px;">COCHIN UNITED</h2><h3 style="color: #FFF7D6; font-size: 20px; letter-spacing: 4px; margin-top: 0;">LEGAL LLP</h3><p style="color: #888888; font-size: 11px; letter-spacing: 2px; text-transform: uppercase;">Advocates & Legal Consultants</p><hr style="border: 0; border-top: 1px solid #D4AF37; margin: 30px 0; opacity: 0.3;"><p style="font-size: 16px; line-height: 1.6; color: #E0E0E0; font-family: 'Arial', sans-serif;">Welcome to the firm's digital hub. To securely authenticate your account, please enter the authorization code below into your application:</p><div style="background: linear-gradient(145deg, #1A1A1A, #121212); padding: 25px; margin: 35px 0; border-radius: 12px; border: 1px solid #333333;"><span style="font-size: 38px; font-weight: bold; letter-spacing: 12px; color: #D4AF37; font-family: monospace;">${decryptedCode}</span></div><p style="font-size: 13px; color: #666666; font-family: 'Arial', sans-serif;">This secure token will expire in 24 hours. For security reasons, do not share this code with anyone.<br><br>© ${new Date().getFullYear()} Cochin United Legal LLP. All rights reserved.</p></div>`
        };
        
        await transporter.sendMail(mailOptions);
      } catch (err) {
        console.error('Error sending custom email', err);
        throw err;
      }
    }
  }
  return event;
};
