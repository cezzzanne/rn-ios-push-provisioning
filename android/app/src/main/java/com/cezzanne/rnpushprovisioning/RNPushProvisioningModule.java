package com.cezzanne.rnpushprovisioning;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import android.util.Log;

public class RNPushProvisioningModule extends ReactContextBaseJavaModule {

    // Constructor
    public RNPushProvisioningModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void initiateAddToAppleWallet(String localizedDescription, String primaryAccountSuffix, String cardholderName, String paymentNetwork, Promise promise) {
        Log.d("RNPushProvisioning", "initiateAddToAppleWallet called with values: " + localizedDescription + ", " + primaryAccountSuffix + ", " + cardholderName + ", " + paymentNetwork);

        promise.resolve("Here");
    }

    @Override
    public String getName() {
        return "RNPushProvisioning";
    }
}
