import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventario_umsa_industrial2019/ui/widgets/initial.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  PermissionStatus _status;
  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  void askPermission() {
    PermissionHandler()
        .requestPermissions([PermissionGroup.storage]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.storage];
    _updateStatus(status);
  }


  @override
  void initState() {
    super.initState();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then(_updateStatus);

  }

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
        accentColor: Colors.purpleAccent,
        primaryColor: Colors.red
      ),
      home: Initial(),
    );
  }
}
