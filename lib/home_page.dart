import 'dart:convert';
import 'dart:core';
import 'package:busca_gif/gif_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int? _offSet = 0;

  String? _search;

  Future<Map> _getGifs() async {
    http.Response responseAll;
    if (_search == null) {
      responseAll = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=GLKNfVSLHaaRmOQ4fDdKYNLYQrUuk151&limit=30&rating=g"));
    }
    else {
        
      responseAll = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=GLKNfVSLHaaRmOQ4fDdKYNLYQrUuk151&q=$_search&limit=20&offset=$_offSet&rating=g&lang=en"));
    }
    return json.decode(responseAll.body);
  }
  @override
    void initState() {
      super.initState();
      _getGifs().then((map) {
        print(map);
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
         Padding(padding: EdgeInsets.all(10.0),
         child: TextField(
           decoration: InputDecoration(labelText:"Pesquise Aqui",
           labelStyle: TextStyle(color: Colors.white),
           border: OutlineInputBorder()
            ),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
         ),
         ),
         Expanded(
           child:FutureBuilder(
             future: _getGifs(),
             builder: (context, snapshot){
               switch(snapshot.connectionState){
                 case ConnectionState.waiting:
                 case ConnectionState.none:
                 return Container(
                   width: 200,
                   height: 200,
                   alignment: Alignment.center,
                   child: CircularProgressIndicator(
                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                     strokeWidth: 5,
                   ),
                 );
                 default:
                 if(snapshot.hasError) return Container();
                 else return _createGifTable(context, snapshot);
               }
             },)
           )
        ],
      ),
    );
  }
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
        itemCount: snapshot.data["data"].length,
       itemBuilder: (context, index){
         return GestureDetector(
           child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
           height:300.0,
           fit: BoxFit.cover,),
           onTap: (){
             Navigator.push(context, 
             MaterialPageRoute(builder: (context)=>GifPage(snapshot.data["data"][index])) );
           },
         );
       }
       );
  }
}