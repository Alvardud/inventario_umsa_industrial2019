import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/data/state_manager.dart';
import 'package:inventario_umsa_industrial2019/ui/pages/history.dart';
import 'package:inventario_umsa_industrial2019/ui/pages/home.dart';
import 'package:inventario_umsa_industrial2019/ui/pages/insumes.dart';
import 'package:inventario_umsa_industrial2019/ui/widgets/drawer.dart';
import 'package:provider/provider.dart';

class Initial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => StateManager(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0.0,
            iconTheme: Theme.of(context).iconTheme,
            title: Text(
              'Panaderia San Javier',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          drawer: CustomDrawer(),
          body: ControllerBody()),
    );
  }
}

class ControllerBody extends StatelessWidget {

  static List<Widget> _widgets = [
    BodyHome(),
    Insumes(),
    History()
  ];

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<StateManager>(context);
    return _widgets[manager.statePickerMenu];
  }
}