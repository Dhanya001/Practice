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



Future<void> login(String phone, String email) async {
    var response = await http.post(
      Uri.parse('http://192.168.0.190/scrap_app/api/login'),
      body: {
        'phone': phone,
        'email': email,
      },
    );
    print('status: ${response.statusCode}');
    print('body: ${response.body}');
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print('Login : $responseData');
    } else {
      //print('Error: ${response.reasonPhrase}');
      throw Exception('Failed to login: ${response.statusCode}');
    }
}


Future<void> login(String phone, String email) async {
  try {
    print('Sending data to API: phone=$phone, email=$email');

    var response = await http.post(
      Uri.parse('http://192.168.0.190/scrap_app/api/login'),
      body: {
        'phone': phone,
        'email': email,
      },
    );

    print('status: ${response.statusCode}');
    print('body: ${response.body}');

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print('data: $responseData');
    } else {
      print('error: ${response.reasonPhrase}');
      throw Exception('Failed to login: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during login: $e');
    rethrow;
  }
}

class Item {
  final String title;
  final double price;

  Item({required this.title, required this.price});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'] as String,
      price: double.parse(json['price'].toString()),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Item>> fetchItems() async {
  final response = await http.get(Uri.parse('http://192.168.0.190/scrap_app/api/items'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Item.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load items: ${response.statusCode}');
  }
}


import 'package:flutter/material.dart';

class ItemDetailsPage extends StatelessWidget {
  const ItemDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: FutureBuilder<List<Item>>(
        future: fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items available.'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
                onTap: () {
                  // Handle item tap
                  print('Tapped on: ${item.title}');
                },
              );
            },
          );
        },
      ),
    );
  }
}


[
  {"title": "Item 1", "price": 100.0},
  {"title": "Item 2", "price": 200.0}
]
