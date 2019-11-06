import 'package:cloud_firestore/cloud_firestore.dart';

class Insumos {
  final String nombre;
  final String id;
  final String descripcion;
  final List<String> ingredientes;
  final String receta;
  final double precio;
  final int cantidad;

  Insumos(
      {this.descripcion,
      this.cantidad,
      this.id,
      this.ingredientes,
      this.nombre,
      this.precio,
      this.receta});

  factory Insumos.fromSnapshot({DocumentSnapshot snapshot}) {
    List<String> aux = [];
    snapshot.data["ingredientes"].forEach((value) => aux.add(value.toString()));
    ///aux.forEach((value)=>print("${snapshot.data['nombre']} "+value));
    
    return Insumos(
        descripcion: snapshot.data['descripcion'],
        cantidad: snapshot.data['cantidad'].toInt(),
        id: snapshot.documentID.toString(),
        nombre: snapshot.data['nombre'],
        precio: snapshot.data['precio'].toDouble(),
        receta: snapshot.data['receta'],
        ingredientes: aux);
  }
}
