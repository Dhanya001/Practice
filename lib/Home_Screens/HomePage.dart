import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

void initPhonePeSdk() {
  PhonePePaymentSdk.init(
    environmentValue, // 'SANDBOX' or 'PRODUCTION'
    merchantId,
    flowId, // Unique identifier for the transaction flow
    enableLogs,
  ).then((isInitialized) {
    setState(() {
      result = 'PhonePe SDK Initialized - $isInitialized';
    });
  }).catchError((error) {
    handleError(error);
  });
}
void startTransaction() {
  PhonePePaymentSdk.startTransaction(
    request, // Base64 encoded request payload
    appSchema, // Your app's URL scheme
  ).then((response) {
    setState(() {
      if (response != null) {
        String status = response['status'].toString();
        String error = response['error'].toString();
        if (status == 'SUCCESS') {
          result = "Flow Completed - Status: Success!";
        } else {
          result = "Flow Completed - Status: $status and Error: $error";
        }
      } else {
        result = "Flow Incomplete";
      }
    });
  }).catchError((error) {
    handleError(error);
  });
}
import 'dart:convert';

Map<String, dynamic> requestPayload = {
  "merchantId": merchantId,
  "merchantTransactionId": "MT123456789",
  "merchantUserId": "MU123456789",
  "amount": 10000, // Amount in paise (e.g., 10000 paise = ₹100)
  "callbackUrl": "https://yourcallbackurl.com",
  "mobileNumber": "9999999999",
  "paymentInstrument": {
    "type": "PAY_PAGE",
  }
};

String request = base64Encode(utf8.encode(jsonEncode(requestPayload)));
