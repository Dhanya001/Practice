import 'dart:convert';

import 'package:demo/auth/NewsModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Newsapp extends StatefulWidget {
  const Newsapp({super.key});

  @override
  State<Newsapp> createState() => _NewsappState();
}

class _NewsappState extends State<Newsapp> {

  Future<News_Model>fetchNews() async{
    final url=
        "https://newsapi.org/v2/everything?q=tesla&from=2024-09-01&sortBy=publishedAt&apiKey=9c93f3fe74cf42c4a9c6188766e25f15";
        var response=await http.get(Uri.parse(url));
    if(response.statusCode==200){
      final result=jsonDecode(response.body);

      return News_Model.fromJson(result);
    }
    else{
      return News_Model();
    }
  }

  @override
  void initState() {
    fetchNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fake Email App'),
        centerTitle: true,
      ),
      body: FutureBuilder(future: fetchNews(), builder: (context,snapshot){
        return ListView.builder(itemBuilder: (context,index){
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("${snapshot.data!.articles![index].urlToImage}"),
              //backgroundImage: NetworkImage("${snapshot.data!.Articles!.}"),
            ),
            title: Text("${snapshot.data!.articles![index].title}"),
            subtitle: Text("${snapshot.data!.articles![index].description}"),
          );
        });
      }),
    );
  }
}
