import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/ui/pages/ventas.dart';
import 'package:inventario_umsa_industrial2019/utils/firebase_request.dart'
    as firebase;
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'
    as common;
import 'package:inventario_umsa_industrial2019/utils/settings.dart' as settings;


DateTime _date = DateTime.now();
String fecha = "${_date.day}/${_date.month}/${_date.year}";


class NewInsume extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.create_new_folder),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NuevoProducto()));
            },
          )
        ],
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Adicionar Producto',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      body: Ventas(
        registro: true,
      ),
    );
  }
}

class NuevoProducto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Nuevo Producto',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        body: Formulario(),
      ),
    );
  }
}

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  TextEditingController _textEditingControllerNombre = TextEditingController();
  TextEditingController _textEditingControllerDescripcion =
      TextEditingController();
  TextEditingController _textEditingControllerPrecio = TextEditingController();
  TextEditingController _textEditingControllerReceta = TextEditingController();
  static DateTime now = DateTime.now();

  String name;
  String descripcion;
  double precio = 0.0;
  String receta;
  String fechaComp = "${now.day}/${now.month}/${now.year}";

  _changeName(String str) {
    setState(() {
      name = str;
    });
  }

  _changeReceta(String str) {
    setState(() {
      receta = str;
    });
  }

  _changePrecio(double str) {
    setState(() {
      precio = str;
    });
  }

  _changeDescripcion(String str) {
    setState(() {
      descripcion = str;
    });
  }

  Widget _entradaNombre() {
    return TextField(
      controller: _textEditingControllerNombre,
      decoration: InputDecoration(
        hintText: 'Nombre del producto',
        labelText: "Nombre",
        border: OutlineInputBorder(),
      ),
      onChanged: (str) => _changeName(str),
      onSubmitted: (str) => _changeName(str),
    );
  }

  Widget _entradaDescripcion() {
    return TextField(
      controller: _textEditingControllerDescripcion,
      decoration: InputDecoration(
        hintText: 'Descripción del producto',
        labelText: "Descripción",
        border: OutlineInputBorder(),
      ),
      onChanged: (str) => _changeDescripcion(str),
      onSubmitted: (str) => _changeDescripcion(str),
    );
  }

  Widget _entradaReceta() {
    return TextField(
      controller: _textEditingControllerReceta,
      decoration: InputDecoration(
        hintText: 'Receta del producto',
        labelText: "Receta",
        border: OutlineInputBorder(),
      ),
      onChanged: (str) => _changeReceta(str),
      onSubmitted: (str) => _changeReceta(str),
    );
  }

  Widget _entradaPrecio() {
    return TextField(
      controller: _textEditingControllerPrecio,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Precio del producto',
        labelText: "Precio",
        border: OutlineInputBorder(),
      ),
      onChanged: (str) => _changePrecio(str as double),
      onSubmitted: (str) => _changePrecio(str as double),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _entradaNombre(),
          SizedBox(height: 8.0),
          _entradaDescripcion(),
          SizedBox(height: 8.0),
          _entradaPrecio(),
          SizedBox(height: 8.0),
          _entradaReceta(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                color: Theme.of(context).accentColor,
                child: Text('Enviar'),
                onPressed: () {
                  if (name != null) {
                    settings.checkInternet().then((value) {
                      if (value) {
                        //TODO: change value ingredientes default
                        firebase.createInsume({
                          "cantidad": 0,
                          "descripcion": descripcion ?? "s/n",
                          "nombre": "$name",
                          "precio": precio,
                          "receta": receta ?? "s/n",
                          "ingredientes": ["ZUMVw7fI4VZxJT4otRXC"],
                        }).then((value) async{
                          await firebase.createMovimiento({
                            "fecha": fecha,
                            "detalle":
                                'se ha registrado el producto \"$name\" (${1} unidad)',
                            "venta": false,
                            "unidades": 0,
                            "id_producto": "$name",
                            "insumo": true,
                          });
                          Scaffold.of(context).showSnackBar(common
                              .customSnackBar(title: 'Guardado Correctamente'));
                        });
                      } else {
                        Scaffold.of(context).showSnackBar(common.customSnackBar(
                            title: 'Error en la conexión a internet'));
                      }
                    });
                  } else {
                    Scaffold.of(context).showSnackBar(common.customSnackBar(
                        title: 'Error datos inexistentes'));
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerDescripcion.dispose();
    _textEditingControllerNombre.dispose();
    _textEditingControllerPrecio.dispose();
    _textEditingControllerReceta.dispose();
  }
}
