import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendSmsOtp(String phoneNumber, String otp) async {
  final accountSid = 'YOUR_TWILIO_ACCOUNT_SID';
  final authToken = 'YOUR_TWILIO_AUTH_TOKEN';
  final fromNumber = 'YOUR_TWILIO_PHONE_NUMBER';
  
  final response = await http.post(
    Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json'),
    headers: {
      'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'From': fromNumber,
      'To': phoneNumber,
      'Body': 'Your OTP is: $otp',
    },
  );

  if (response.statusCode == 201) {
    print('SMS OTP sent successfully');
  } else {
    print('Failed to send SMS OTP: ${response.body}');
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendEmailOtp(String email, String otp) async {
  final apiKey = 'YOUR_SENDGRID_API_KEY';
  
  final response = await http.post(
    Uri.parse('https://api.sendgrid.com/v3/mail/send'),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'personalizations': [
        {
          'to': [
            {'email': email}
          ],
          'subject': 'Your OTP Code'
        }
      ],
      'from': {'email': 'your-email@example.com'},
      'content': [
        {
          'type': 'text/plain',
          'value': 'Your OTP is: $otp'
        }
      ]
    }),
  );

  if (response.statusCode == 202) {
    print('Email OTP sent successfully');
  } else {
    print('Failed to send Email OTP: ${response.body}');
  }
}

void authenticateUser (String phoneNumber, String email) {
  String otp = generateOtp(); // Implement your OTP generation logic here

  sendSmsOtp(phoneNumber, otp);
  sendEmailOtp(email, otp);
}
