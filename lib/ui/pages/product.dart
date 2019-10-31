import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListItems();
  }
}

class ListItems extends StatefulWidget {
  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {

  String id;
  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    print(db.collection('productos').document());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}