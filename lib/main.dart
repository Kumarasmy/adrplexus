
import 'dart:developer';
import 'package:adrplexus/controller/listController.dart';
import 'package:adrplexus/views/clientList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log("in build");
    return MaterialApp(
      title: 'AdrPlexus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => DataCubit(),
        child: MyHomePage(),
      ),
    );
  }
}