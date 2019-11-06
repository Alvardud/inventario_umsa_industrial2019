import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/models/product.dart';
import 'package:inventario_umsa_industrial2019/ui/pages/new_product.dart';
import 'package:inventario_umsa_industrial2019/utils/firebase_request.dart'
    as firebase;
import 'package:inventario_umsa_industrial2019/ui/widgets/boton_scan.dart';
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'
    as common;

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListItems(),
        Positioned(
          bottom: 8.0,
          right: 8.0,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => NewProduct()
              ));
            },
          ),
        )
      ],
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
                  ExpansionTile(
                    leading: common.iconLeading(
                        data: _products[item].tipo, picker: item,size:45.0),
                    key: Key(_products[item].id),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "${_products[item].nombre[0].toUpperCase()}${_products[item].nombre.substring(1)}"),
                        Text(
                          "${_products[item].fechaComp}",
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text(
                                '"${_products[item].descripcion}"',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            common.textDescripcion(
                                key: 'precio:',
                                value: "${_products[item].precio} Bs.",
                                context: context),
                            common.textDescripcion(
                                key: 'fecha compra:',
                                value: "${_products[item].fechaComp}",
                                context: context),
                            common.textDescripcion(
                                key: 'fecha vencimiento:',
                                value: "${_products[item].fechaVen}",
                                context: context),
                            SizedBox(height: 8.0),
                            Center(
                                child: BotonScan(
                              product: _products[item],
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
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
