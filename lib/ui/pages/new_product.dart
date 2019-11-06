import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/data/constants.dart' as constant;
import 'package:inventario_umsa_industrial2019/ui/pages/ventas.dart';
import 'package:inventario_umsa_industrial2019/utils/firebase_request.dart'
    as firebase;
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'
    as common;
import 'package:inventario_umsa_industrial2019/utils/settings.dart' as settings;


DateTime _date = DateTime.now();
String fecha = "${_date.day}/${_date.month}/${_date.year}";


class NewProduct extends StatelessWidget {
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
  TextEditingController _textEditingControllerFecha = TextEditingController();
  static DateTime now = DateTime.now();

  String name;
  String descripcion;
  double precio = 0.0;
  String fechaVencimiento;
  String dropDownValue;
  String fechaComp = "${now.day}/${now.month}/${now.year}";

  _changeName(String str) {
    setState(() {
      name = str;
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

  _changeFechaVencimiento(String str) {
    setState(() {
      fechaVencimiento = str;
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

  Widget _entradaFecha() {
    return TextField(
      controller: _textEditingControllerFecha,
      decoration: InputDecoration(
        hintText: 'Dia/Mes/Año',
        labelText: "Fecha de vencimiento",
        border: OutlineInputBorder(),
      ),
      onChanged: (str) => _changeFechaVencimiento(str),
      onSubmitted: (str) => _changeFechaVencimiento(str),
    );
  }

  Widget _dropDown() {
    return DropdownButton<String>(
      value: dropDownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Theme.of(context).accentColor),
      underline: Container(
        height: 2,
        color: Theme.of(context).accentColor,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropDownValue = newValue;
        });
      },
      items: constant.iconsSouvenir.keys.map((String valueItem) {
        return DropdownMenuItem<String>(
          value: valueItem,
          child: Text(valueItem),
        );
      }).toList(),
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
          _entradaFecha(),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Tipo:',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              _dropDown()
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                color: Theme.of(context).accentColor,
                child: Text('Enviar'),
                onPressed: () {
                  if (name != null &&
                      fechaVencimiento != null &&
                      dropDownValue != null) {
                    settings.checkInternet().then((value) {
                      if (value) {
                        firebase.createProduct({
                          "cantidad": 0,
                          "descripcion": descripcion ?? "s/n",
                          "fecha_comp": "$fechaComp",
                          "fecha_ven": "$fechaVencimiento",
                          "nombre": "$name",
                          "precio": precio,
                          "tipo": "$dropDownValue"
                        }).then((value)async {
                          await firebase.createMovimiento({
                            "fecha": fecha,
                            "detalle":
                                'se ha registrado el producto \"$name\" (${1} unidad)',
                            "venta": false,
                            "unidades": 0,
                            "id_producto": "$name",
                            "insumo": false,
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
    _textEditingControllerFecha.dispose();
    _textEditingControllerNombre.dispose();
    _textEditingControllerPrecio.dispose();
  }
}
