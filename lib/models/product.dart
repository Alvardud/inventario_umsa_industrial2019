import 'package:cloud_firestore/cloud_firestore.dart';

class Product{

  String id;
  String nombre;
  int cantidad;
  String descripcion;
  String fechaComp;
  String fechaVen;
  double precio;
  String tipo;

  Product({
    this.cantidad,
    this.descripcion,
    this.fechaComp,
    this.fechaVen,
    this.id,
    this.nombre,
    this.precio,
    this.tipo
  });

  factory Product.fromSnapshot({DocumentSnapshot snapshot}){
    return Product(
      cantidad: snapshot.data['cantidad'].toInt(),
      descripcion: snapshot.data['descripcion'],
      fechaComp: snapshot.data['fecha_comp'],
      fechaVen: snapshot.data['fecha_ven'],
      id: snapshot.documentID.toString(),
      nombre: snapshot.data['nombre'],
      precio: snapshot.data['precio'].toDouble(),
      tipo: snapshot.data['tipo']
    );
  }
}