import 'package:demo/Home_Screens/HomePage.dart';
import 'package:demo/auth/Newsapp.dart';
import 'package:demo/auth/demo.dart';
import 'package:demo/auth/login.dart';
import 'package:demo/auth/signinnew.dart';
import 'package:demo/auth/signup.dart';
import 'package:demo/auth/signup_new.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: HomePage()
        home: SignInPage()
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Demo App'),
      ),
      backgroundColor: Colors.greenAccent,
      body: Column(
        children: [
          // A simple Container for title
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200.0),
              color: Colors.cyan,
            ),
            child: const Center(
              child: Text(
                'Hello World',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            // Adding ListView and GridView in separate sections
            child: Row(
              children: [
                // ListView
                Expanded(
                  child: ListView.builder(
                    itemCount: 4, // Example for 5 items
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('List Item ${index + 1}'),
                        leading: Icon(Icons.list),
                      );
                    },
                  ),
                ),
                // GridView
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items in each row
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: 6, // Example for 4 grid items
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.primaries[index % Colors.primaries.length],
                        child: const Center(
                          child: Text(
                            'Grid Item',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyHome()),
          );
        },
        child: const Icon(Icons.account_box_outlined),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(ApiExampleApp());

class ApiExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ApiScreen(),
    );
  }
}

class ApiScreen extends StatefulWidget {
  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  String _response = 'Response will be shown here';

  // Example API URL (replace with your own API endpoints)
  final String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Function for GET request
  Future<void> getData() async {
    final response = await http.get(Uri.parse(apiUrl));
    setState(() {
      _response = 'GET Response: ${response.body}';
    });
  }

  // Function for POST request
  Future<void> postData() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': 'New Post', 'body': 'This is a post', 'userId': 1}),
    );
    setState(() {
      _response = 'POST Response: ${response.body}';
    });
  }

  // Function for PUT request
  Future<void> putData() async {
    final response = await http.put(
      Uri.parse('$apiUrl/1'),  // Update the resource with id 1
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': 'Updated Post', 'body': 'This post is updated', 'userId': 1}),
    );
    setState(() {
      _response = 'PUT Response: ${response.body}';
    });
  }

  // Function for PATCH request
  Future<void> patchData() async {
    final response = await http.patch(
      Uri.parse('$apiUrl/1'),  // Partially update the resource with id 1
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': 'Patched Post'}),
    );
    setState(() {
      _response = 'PATCH Response: ${response.body}';
    });
  }

  // Function for DELETE request
  Future<void> deleteData() async {
    final response = await http.delete(Uri.parse('$apiUrl/1'));  // Delete the resource with id 1
    setState(() {
      _response = 'DELETE Response: ${response.body}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Example'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ElevatedButton(onPressed: getData, child: Text('GET Data')),
              ElevatedButton(onPressed: postData, child: Text('POST Data')),
              ElevatedButton(onPressed: putData, child: Text('PUT Data')),
              ElevatedButton(onPressed: patchData, child: Text('PATCH Data')),
              ElevatedButton(onPressed: deleteData, child: Text('DELETE Data')),
              SizedBox(height: 20),
              Text(
                _response,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
