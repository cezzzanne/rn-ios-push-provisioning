package com.cezzanne.rnpushprovisioning;

import android.app.Activity;
import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.LinearLayoutCompat;
import com.facebook.react.bridge.*;
import android.util.Log;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.android.gms.tapandpay.TapAndPay;
import com.google.android.gms.tapandpay.TapAndPayClient;
import com.google.android.gms.tapandpay.issuer.IsTokenizedRequest;
import com.google.android.gms.tapandpay.issuer.PushTokenizeRequest;
import com.google.android.gms.tapandpay.issuer.UserAddress;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;


public class RNPushProvisioningModule extends ReactContextBaseJavaModule implements ActivityEventListener {

    private final TapAndPayClient tapAndPayClient;
    private static final int REQUEST_CODE_PUSH_TOKENIZE = 3;
    private static final String EVENT_NAME = "androidPushTokenId";


    // Constructor
    public RNPushProvisioningModule(ReactApplicationContext reactContext) {
        super(reactContext);
        tapAndPayClient = TapAndPay.getClient(reactContext);
        reactContext.addActivityEventListener(this); // Register this module to receive activity results.
    }

    // https://developers.google.com/pay/issuers/apis/push-provisioning/android/push-provisioning-objects#opaque_payment_card_opc
    @ReactMethod
    public void initiateAddToAppleWallet(byte[] opcBytes) {
        UserAddress userAddress =
                UserAddress.newBuilder()
                        .setName("Johnny Thunders")
                        .setAddress1("Hibbing")
                        .setLocality("San Francisco") // City
                        .setAdministrativeArea("CA") // state
                        .setCountryCode("US")
                        .setPostalCode("10014")
                        .setPhoneNumber("+14159390641")
                        .build();

        PushTokenizeRequest pushTokenizeRequest =
                new PushTokenizeRequest.Builder()
                        .setOpaquePaymentCard(opcBytes)
                        .setNetwork(TapAndPay.CARD_NETWORK_MASTERCARD)
                        .setTokenServiceProvider(TapAndPay.TOKEN_PROVIDER_MASTERCARD)
                        .setDisplayName("Arthur Rimbaud")
                        .setLastDigits("1234")
                        .setUserAddress(userAddress)
                        .build();

        tapAndPayClient.pushTokenize(getCurrentActivity(), pushTokenizeRequest, REQUEST_CODE_PUSH_TOKENIZE);
    }

    // We can call this to check if the card has been tokenized
    @ReactMethod
    public void checkIfTokenized(String lastFour, Promise promise) {
        IsTokenizedRequest isTokenizedRequest =
                new IsTokenizedRequest.Builder()
                        .setIdentifier(lastFour.trim())
                        .setNetwork(TapAndPay.CARD_NETWORK_MASTERCARD)
                        .setTokenServiceProvider(TapAndPay.TOKEN_PROVIDER_MASTERCARD)
                        .build();

        tapAndPayClient.isTokenized(isTokenizedRequest)
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        boolean isTokenized = task.getResult();
                        promise.resolve(isTokenized);
                    } else {
                        promise.reject("TOKENIZATION_CHECK_FAILED", "Failed to check if card is tokenized");
                    }
                });
    }

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, @Nullable @org.jetbrains.annotations.Nullable Intent intent) {
        if (requestCode == REQUEST_CODE_PUSH_TOKENIZE) {
            // Tokenization was successful
            if (resultCode == Activity.RESULT_OK && intent != null) {
                String tokenId = intent.getStringExtra(TapAndPay.EXTRA_ISSUER_TOKEN_ID);

                // Set the payload
                WritableMap params = Arguments.createMap();
                params.putString("tokenId", tokenId);

                sendEvent(EVENT_NAME, params);

            } else if (resultCode == Activity.RESULT_CANCELED) {
                // User canceled the operation or there was some other kind of cancellation.
            } else {
                // Handle other possible result codes or errors.
            }
        }
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        getReactApplicationContext()
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    @Override
    public String getName() {
        return "RNPushProvisioning";
    }

    @Override
    public void onNewIntent(Intent intent) {
        // Let it be empty since we don't handle this
    }
}
