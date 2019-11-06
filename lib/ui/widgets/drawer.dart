import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/data/state_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  Widget _drawerHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountEmail: Text(""),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/images/fondo1.png"))),
      accountName: Text(
        "Panaderia San Javier",
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }

  Widget _listElements(BuildContext context) {
    final manager = Provider.of<StateManager>(context);

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
            title: Text('Inventario'),
            leading: Icon(Icons.home),
            onTap: () {
              manager.statePickerMenu = 0;
              Navigator.pop(context);
            }),
        ListTile(
            title: Text('Producción'),
            leading: Icon(Icons.build),
            onTap: () {
              manager.statePickerMenu = 1;
              Navigator.pop(context);
            }),
        ListTile(
            title: Text('Historial'),
            leading: Icon(Icons.list),
            onTap: () {
              manager.statePickerMenu = 2;
              Navigator.pop(context);
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          _drawerHeader(context),
          _listElements(
            context,
          ),
        ],
      ),
    );
  }
}
