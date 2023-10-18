declare module 'rn-ios-push-provisioning' {
    


  interface RNPushProvisioningInterface {
    initiateAddToAppleWallet: (
      localizedDescription: string,
      primaryAccountSuffix: string,
      cardholderName: string,
      paymentNetwork: string,
      callback: (response: PaymentPassResponse) => void
    ) => void;
    completeAddPaymentPass: (response: CompletePaymentPassResponse) => void;
  }
  
  interface PaymentPassResponse {
    certificatesBase64: string[];
    nonceString: string;
    nonceSignatureString: string;
  }

  interface CompletePaymentPassResponse {
    encryptedPassData: string;
    activationData: string;
    ephemeralPublicKey: string;
  }

  export default RNPushProvisioning as RNPushProvisioningInterface
}
