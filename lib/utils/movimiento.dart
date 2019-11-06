import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/models/insumos.dart';
import 'package:inventario_umsa_industrial2019/models/product.dart';
import 'package:inventario_umsa_industrial2019/utils/firebase_request.dart'
    as firebase;
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'
    as common;

//productos
DateTime _date = DateTime.now();
String fecha = "${_date.day}/${_date.month}/${_date.year}";

Future<bool> ventaProducto(String id, BuildContext context) async {
  try {
    Product _producto;
    int _cantidad;
    firebase.readProduct(id).then((value) async {
      _producto = value;
      _cantidad = _producto.cantidad - 1;
      if (_cantidad >= 0) {
        await firebase.updateInsume(id, {"cantidad": _cantidad});
        await firebase.createMovimiento({
          "fecha": fecha,
          "detalle":
              'se ha retirado el producto \"${_producto.nombre}\" (${1} unidad)',
          "venta": true,
          "unidades": 1,
          "id_producto": "${_producto.nombre}",
          "insumo": false,
        });
        return true;
      }
      return false;
    });
  } catch (e) {
    print("Excepcion\n\n$e");
    return false;
  }
  return false;
}

Future<void> registroProducto(String id, BuildContext context) async {
  try {
    Product _producto;
    int _cantidad;
    firebase.readProduct(id).then((value) async {
      _producto = value;
      _cantidad = _producto.cantidad + 1;
      await firebase.updateProduct(id, {"cantidad": _cantidad});
      await firebase.createMovimiento({
        "fecha": fecha,
        "detalle":
            'se ha registrado el producto \"${_producto.nombre}\" (${1} unidad)',
        "venta": false,
        "unidades": 1,
        "id_producto": "${_producto.nombre}",
        "insumo": false,
      });
    });
    Scaffold.of(context)
        .showSnackBar(common.customSnackBar(title: 'Guardado Correctamente'));
  } catch (e) {
    print("Excepcion\n\n$e");
    Scaffold.of(context).showSnackBar(
      common.customSnackBar(
          title: 'Ah ocurrido un error\nVerifique su conexion a internet'),
    );
  }
}

//insumos

Future<bool> ventaInsumo(String id, BuildContext context) async {
  try {
    Insumos _insumo;
    int _cantidad;
    firebase.readInsume(id).then((value) async {
      _insumo = value;
      _cantidad = _insumo.cantidad - 1;
      if (_cantidad >= 0) {
        await firebase.updateProduct(id, {"cantidad": _cantidad});
        await firebase.createMovimiento({
          "fecha": fecha,
          "detalle":
              'se ha vendido el producto \"${_insumo.nombre}\" (${1} unidad)',
          "venta": true,
          "unidades": 1,
          "id_producto": "${_insumo.nombre}",
          "insumo": true,
        });
        return true;
      }
      return false;
    });
  } catch (e) {
    print("Excepcion\n\n$e");
    return false;
  }
  return false;
}

Future<void> registroInsumo(String id, BuildContext context) async {
  try {
    Insumos _insumo;
    int _cantidad;
    firebase.readInsume(id).then((value) async {
      _insumo = value;
      _cantidad = _insumo.cantidad + 1;
      verificarIngredientes(_insumo).then((value) async {
        if (value) {
          _insumo.ingredientes.forEach((value) async {
            await ventaProducto(value, context);
          });
          await firebase.updateProduct(id, {"cantidad": _cantidad});
          await firebase.createMovimiento({
            "fecha": fecha,
            "detalle":
                'se ha registrado el producto \"${_insumo.nombre}\" (${1} unidad)',
            "venta": false,
            "unidades": 1,
            "id_producto": "${_insumo.nombre}",
            "insumo": true,
          });
          Scaffold.of(context).showSnackBar(
              common.customSnackBar(title: 'Guardado Correctamente'));
        } else {
          Scaffold.of(context).showSnackBar(common.customSnackBar(
              title:
                  'Error no hay los ingredientes suficientes para producir dicho producto'));
        }
      });
    });
  } catch (e) {
    print("Excepcion\n\n$e");
    Scaffold.of(context).showSnackBar(
      common.customSnackBar(
          title: 'Ah ocurrido un error\nVerifique su conexion a internet'),
    );
  }
}

Future<bool> verificarIngredientes(Insumos insumo) async {
  try {
    insumo.ingredientes.forEach((value) async {
      Product _product = await firebase.readProduct(value);
      if (_product.cantidad <= 0) {
        return false;
      }
    });
    return true;
  } catch (e) {
    print("Excepcion\n\n$e");
    return false;
  }
}
