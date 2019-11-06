import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_umsa_industrial2019/models/historial.dart';
import 'package:inventario_umsa_industrial2019/models/insumos.dart';
import 'package:inventario_umsa_industrial2019/models/product.dart';

final databaseReference = Firestore.instance;

//Product (ingredientes)

Future<List<Product>> readProducts() async {
  List<Product> _list = [];
  try {
    await databaseReference
        .collection("productos")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Product _product = Product.fromSnapshot(snapshot: f);
        _list.add(_product);
      });
    });
    return _list;
  } catch (e) {
    print("excepcion\n $e");
  }
  return _list;
}

Future<void> updateProduct(String id, Map<String, dynamic> data) async {
  try {
    databaseReference.collection('productos').document(id).updateData(data);
  } catch (e) {
    print(e.toString());
  }
}

Future<void> deleteProduct(String id) async {
  try {
    databaseReference.collection('productos').document(id).delete();
  } catch (e) {
    print(e.toString());
  }
}

Future<void> createProduct(Map<String, dynamic> data) async {
  await databaseReference.collection("productos").add(data);
}

Future<Product> readProduct(String id) async {
  Product _product;
  try {
    await databaseReference
        .collection("productos")
        .document(id)
        .get()
        .then((snapshot) {
      _product = Product.fromSnapshot(snapshot: snapshot);
    });
    return _product;
  } catch (e) {
    print("excepcion\n $e");
  }
  return null;
}

//Insumos

Future<List<Insumos>> readInsumes() async {
  List<Insumos> _list = [];
  try {
    await databaseReference
        .collection("insumos")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Insumos _insumo = Insumos.fromSnapshot(snapshot: f);
        _list.add(_insumo);
      });
    });
    return _list;
  } catch (e) {
    print("excepcion\n $e");
  }
  return _list;
}

Future<void> updateInsume(String id, Map<String, dynamic> data) async {
  try {
    databaseReference.collection('insumos').document(id).updateData(data);
  } catch (e) {
    print(e.toString());
  }
}

Future<void> deleteInsume(String id) async {
  try {
    databaseReference.collection('insumos').document(id).delete();
  } catch (e) {
    print(e.toString());
  }
}

Future<void> createInsume(Map<String, dynamic> data) async {
  await databaseReference.collection("insumos").add(data);
}

Future<Insumos> readInsume(String id) async {
  Insumos _product;
  try {
    await databaseReference
        .collection("insumos")
        .document(id)
        .get()
        .then((snapshot) {
      _product = Insumos.fromSnapshot(snapshot: snapshot);
    });
    return _product;
  } catch (e) {
    print("excepcion\n $e");
  }
  return null;
}

//movimientos

Future<List<Movimiento>> readHistorial() async {
  List<Movimiento> _list = [];
  try {
    await databaseReference
        .collection("historial")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Movimiento _movimiento = Movimiento.fromSnapshot(snapshot: f);
        _list.add(_movimiento);
      });
    });
    return _list;
  } catch (e) {
    print("excepcion\n $e");
  }
  return _list;
}

Future<void> updateMovimiento(String id, Map<String, dynamic> data) async {
  try {
    databaseReference.collection('historial').document(id).updateData(data);
  } catch (e) {
    print(e.toString());
  }
}

Future<void> deleteMovimiento(String id) async {
  try {
    databaseReference.collection('historial').document(id).delete();
  } catch (e) {
    print(e.toString());
  }
}

Future<void> createMovimiento(Map<String, dynamic> data) async {
  await databaseReference.collection("historial").add(data);
}

Future<Movimiento> readMovimiento(String id) async {
  Movimiento _movimiento;
  try {
    await databaseReference
        .collection("historial")
        .document(id)
        .get()
        .then((snapshot) {
      _movimiento = Movimiento.fromSnapshot(snapshot: snapshot);
    });
    return _movimiento;
  } catch (e) {
    print("excepcion\n $e");
  }
  return null;
}
