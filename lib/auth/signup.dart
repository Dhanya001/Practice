import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController emailcontroller= TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();

  void login(String email, password) async{
    try{
      Response response =await post(
        Uri.parse('https://reqres.in/api/register'),
        body: {
          'email' : email,
          'password' : password
      }
      );

      if(response.statusCode==200)
        {
          var data= jsonDecode(response.body.toString());
          print(data);
          print("Account Created Successfully");
        }
      else
      {
        print("Failed");
      }
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Sign Up",style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
        ),
        ),
        centerTitle: true,
      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailcontroller,
              decoration: InputDecoration(
                hintText: "Enter Email Id.",
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordcontroller,
              decoration: InputDecoration(
                hintText: "Enter Password",
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                login(emailcontroller.toString(),passwordcontroller.toString());
              },
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Center(child: Text("Sign Up",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white
                ),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
