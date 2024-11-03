import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DemoGETAPI extends StatefulWidget {
  @override
  _DemoGETAPIState createState() => _DemoGETAPIState();
}

class _DemoGETAPIState extends State<DemoGETAPI> {
  // API call function
  Future<void> postData() async {
    // Replace with your API endpoint
    final String apiUrl = 'https://your-api-endpoint.com/api/endpoint';

    // The data you want to send
    Map<String, dynamic> data = {
      'key1': 'value1',
      'key2': 'value2',
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Sending JSON data
          'Authorization': 'Bearer YOUR_API_TOKEN', // Replace with your token if needed
        },
        body: jsonEncode(data),
      );

      // Handle response
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
        showDialogMessage(context, 'Success', 'Data sent successfully!');
      } else {
        print('Error: ${response.statusCode}');
        showDialogMessage(context, 'Error', 'Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      showDialogMessage(context, 'Error', 'An exception occurred: $e');
    }
  }

  // Function to show dialog with messages
  void showDialogMessage(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter API POST Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            postData(); // Trigger the API call when the button is pressed
          },
          child: Text('Send Data to API'),
        ),
      ),
    );
  }
}
