import 'package:cloud_firestore/cloud_firestore.dart';

class Movimiento {
  String fecha;
  String detalle;
  String id;
  String idProducto;
  bool insumo;
  bool venta;
  int unidades;

  Movimiento(
      {this.detalle,
      this.fecha,
      this.id,
      this.idProducto,
      this.insumo,
      this.venta,
      this.unidades});

  factory Movimiento.fromSnapshot({DocumentSnapshot snapshot}) {
    return Movimiento(
      detalle: snapshot['detalle'],
      fecha: snapshot['fecha'],
      id: snapshot.documentID,
      insumo: snapshot['insumo'],
      idProducto: snapshot['id_producto'],
      venta: snapshot['venta'],
      unidades: snapshot['unidades'].toInt(),
    );
  }
}
