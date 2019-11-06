import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/models/historial.dart';
import 'package:inventario_umsa_industrial2019/utils/firebase_request.dart'
    as firebase;
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'
    as common;

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 32.0,),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),child: Text(
          'Historial',style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w300
          ),
        ),),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0),
          child: Text("De ingresos y ventas",style: TextStyle(color: Colors.grey[600]),),
        ),
        SizedBox(height: 32.0,),
        ItemList(),
      ],
    );
  }
}

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<Movimiento> _historial = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase.readHistorial(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (!snap.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: snap.data.length,
          itemBuilder: (context, item) {
            _historial = snap.data;
            if (_historial.length != 0) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      _historial[item].venta
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 36.0,
                      color: _historial[item].venta ? Colors.green : Colors.red,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        common.textDescripcion(
                            key: 'Fecha:',
                            value: "${_historial[item].fecha}",
                            context: context),
                        common.textDescripcion(
                            key: 'Producto:',
                            value:
                                "${_historial[item].idProducto}" ?? "producto",
                            context: context),
                        common.textDescripcion(
                            key: 'Unidades:',
                            value: "${_historial[item].unidades}",
                            context: context),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "${_historial[item].detalle[0].toUpperCase()}${_historial[item].detalle.substring(1)}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
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
