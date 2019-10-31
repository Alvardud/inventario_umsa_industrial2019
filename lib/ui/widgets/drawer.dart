import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/data/state_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  Widget _drawerHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text("Ashish Rawat"),
      accountEmail: Text("ashishrawat2911@gmail.com"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          "A",
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Widget _listElements(BuildContext context) {

  final manager = Provider.of<StateManager>(context);

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          title: Text('Inicio'),
          leading: Icon(Icons.home),
          onTap: (){
            manager.statePickerMenu = 0;
            Navigator.pop(context);
          }
        ),
        ListTile(
          title: Text('Producción'),
          leading: Icon(Icons.build),
          onTap: (){
            manager.statePickerMenu = 1;
            Navigator.pop(context);
          }
        ),
        ListTile(
          title: Text('Historial'),
          leading: Icon(Icons.list),
          onTap: (){
            manager.statePickerMenu = 2;
            Navigator.pop(context);
          }
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          _drawerHeader(context),
          _listElements(context,),
        ],
      ),
    );
  }
}
