// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
class GifPage extends StatelessWidget {
 // const GifPage({ Key? key, required this._gifData }) : super(key: key);

  final Map _gifData;

  const GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor:Colors.black,
      body: Center(child: Image.network(_gifData["images"]["fixed_height"]["url"]),),
    );
  }
}