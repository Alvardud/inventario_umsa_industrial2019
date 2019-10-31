import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventario_umsa_industrial2019/ui/widgets/initial.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Inventarios',
      theme: ThemeData(
        textTheme: TextTheme(
            title: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
        iconTheme: IconThemeData(color: Colors.black),
        primarySwatch: Colors.red,
      ),
      home: Initial(),
    );
  }
}
