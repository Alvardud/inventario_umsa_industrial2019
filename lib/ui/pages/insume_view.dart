import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/models/insumos.dart';
import 'package:inventario_umsa_industrial2019/models/product.dart';
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'
    as common;
import 'package:inventario_umsa_industrial2019/utils/cloud_storage.dart'
    as cloud;
import 'package:inventario_umsa_industrial2019/utils/firebase_request.dart'
    as firebase;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:inventario_umsa_industrial2019/utils/generate_image.dart'as image;

class InsumesView extends StatefulWidget {
  final Insumos insumo;

  InsumesView({this.insumo});

  @override
  _InsumesViewState createState() => _InsumesViewState();
}

class _InsumesViewState extends State<InsumesView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  GlobalObjectKey _renderObjectKey;

  String _generateContent() {
    return ("insumo|${widget.insumo.id}|${widget.insumo.nombre}|${widget.insumo.precio}");
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(4.0),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text("Generar QR"),
                ),
                FlatButton(
                  child: Text('Descargar'),
                  onPressed: () {
                    image
                        .saveData(_generateContent(),
                            "${widget.insumo.nombre}-${widget.insumo.id[0]}")
                        .then((value) {
                      Scaffold.of(context).showSnackBar(
                        common.customSnackBar(
                            title: 'Descargado correctamente'),
                      );
                    });
                  },
                )
              ],
            ),
            content: SizedBox(
                height: 300.0,
                child: SizedBox(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RepaintBoundary(
                      key: _renderObjectKey,
                      child: QrImage(
                        size: 200.0,
                        data: _generateContent(),
                        foregroundColor: Color(0xff03291c),
                      ),
                    ),
                  ],
                ))),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAlert(context);
        },
        child: Text('QR'),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          '${widget.insumo.nombre[0].toUpperCase()}${widget.insumo.nombre.substring(1)}',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        indicatorColor: Colors.transparent,
        unselectedLabelColor: Colors.grey,
        tabs: <Widget>[
          Tab(text: 'DESCRIPCION'),
          Tab(text: 'INGREDIENTES'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Descripcion(insumo: widget.insumo),
          Ingredientes(insumo: widget.insumo),
        ],
      ),
    );
  }
}

class Descripcion extends StatelessWidget {
  final Insumos insumo;

  Descripcion({this.insumo});

  Widget _image() {
    return Container(
      height: 150.0,
      width: 150.0,
      child: FutureBuilder(
        future: cloud.getImagePathInsume(name: "${insumo.id}.jpg"),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return SizedBox(
              height: 50.0,
              width: 50.0,
              child: Container(),
            );
          }
          return Image.network(snap.data);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _image(),
            SizedBox(
              height: 36.0,
            ),
            common.textDescripcion(
                context: context,
                key: 'Precio Unitario',
                value: '${insumo.precio} Bs.'),
            SizedBox(height: 8.0),
            Text(
              '${insumo.descripcion}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Receta',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 20.0),
            insumo.receta == "n/s"
                ? _textoVacio()
                : Text(
                    "${insumo.receta}",
                    textAlign: TextAlign.justify,
                  ),
          ],
        ),
      ),
    );
  }
}

class Ingredientes extends StatelessWidget {
  final Insumos insumo;
  Ingredientes({this.insumo});
  Product _product;

  Widget _ingredientElement(String id) {
    return FutureBuilder(
      future: firebase.readProduct(id),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (!snap.hasData) {
          return Container();
        } else {
          _product = snap.data;
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("*", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8.0),
                  Text(
                      "${_product.nombre[0].toString().toUpperCase()}${_product.nombre.toString().substring(1)}"),
                ],
              ));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Ingredientes',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: insumo.ingredientes.length,
            itemBuilder: (BuildContext context, item) {
              if (insumo.ingredientes.length == 0) {
                return Center(
                  child: _textoVacio(),
                );
              }
              return _ingredientElement(insumo.ingredientes[item]);
            },
          )
        ],
      ),
    );
  }
}

Widget _textoVacio() {
  return Text(
    "No\nDisponible",
    style: TextStyle(color: Colors.black54, fontSize: 24.0),
    textAlign: TextAlign.center,
  );
}
