import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/models/product.dart';
import 'package:inventario_umsa_industrial2019/utils/firebase_request.dart'
    as firebase;
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'
    as common;
import 'package:inventario_umsa_industrial2019/ui/widgets/alert_product.dart'
    as alert;

class Inventary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListItems(),
    );
  }
}

class ListItems extends StatefulWidget {
  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase.readProducts(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (!snap.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: snap.data.length,
          itemBuilder: (context, item) {
            _products = snap.data;
            if (_products.length != 0) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: common.iconLeading(
                        data: _products[item].tipo, picker: item),
                    title: Text(
                        "${_products[item].nombre[0].toUpperCase()}${_products[item].nombre.substring(1)}"),
                    subtitle: Text("${_products[item].descripcion}"),
                    trailing: Text("${_products[item].cantidad} Uni."),
                    onTap: () {
                      alert.showAlert(
                          context: context,
                          picker: item%6,
                          producto: _products[item]);
                    },
                  ),
                  Divider()
                ],
              );
            } else {
              return Center(
                child: Text('No Items'),
              );
            }
          },
        );
      },
    );
  }
}
