import 'package:flutter/material.dart';

class BodyHome extends StatefulWidget {
  @override
  _BodyHomeState createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              Container(),
              Container(),
              Container(),
            ],
          ),
        ),
        TabBar(
          indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          labelStyle: TextStyle(fontSize: 20.0),
          unselectedLabelStyle: TextStyle(fontSize: 14.0),
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: 'Inventario'),
            Tab(text: 'Registro'),
            Tab(text: 'Venta'),
          ],
        ),
      ],
    );
  }
}
