import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/models/product.dart';
import 'package:inventario_umsa_industrial2019/data/constants.dart' as constan;

void showAlert({BuildContext context, Product producto, int picker}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(4.0),
          title: Text(
              "${producto.nombre[0].toUpperCase()}${producto.nombre.substring(1)}"),
          content: SizedBox(
              height: 250.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75.0),
                        color: constan.colorsDefault[picker]),
                    child: Icon(constan.iconsSouvenir[producto.tipo]),
                  ),
                  Expanded(
                    child: Center(
                                          child: Text(
                        "${producto.descripcion[0].toUpperCase()}${producto.descripcion.substring(1)}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Precio:\t${producto.precio} Bs."),
                        Text("Fecha de vencimiento:\t${producto.fechaVen}"),
                        Text("Cantidad restante:\t${producto.cantidad}")
                      ],
                    ),
                  )
                ],
              )),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      });
}
