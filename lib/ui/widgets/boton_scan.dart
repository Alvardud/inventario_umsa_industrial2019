import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/models/product.dart';
import 'package:inventario_umsa_industrial2019/ui/widgets/tab_alert.dart';
import 'package:inventario_umsa_industrial2019/utils/generate_image.dart'
    as image;
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'as common;

class BotonScan extends StatefulWidget {
  final Product product;

  BotonScan({this.product});

  @override
  _BotonScanState createState() => _BotonScanState();
}

class _BotonScanState extends State<BotonScan> {
  Image _qrImage;

  String _generateContent() {
    return ("producto|${widget.product.id}|${widget.product.nombre}|${widget.product.precio}|${widget.product.fechaVen}|${widget.product.tipo}|${widget.product.descripcion}");
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(4.0),
            title: Row(
              children: <Widget>[
                Expanded(child: Text("Generar QR"),),
                FlatButton(
                child: Text('Descargar'),
                onPressed: () {
                  image
                      .saveData(_generateContent(),
                          "${widget.product.nombre}-${widget.product.id[0]}")
                      .then((value) {
                    Scaffold.of(context).showSnackBar(
                      common.customSnackBar(
                          title:
                              'Descargado correctamente'),
                    );
                  });
                },
              )
              ],
            ),
            content: SizedBox(
                height: 300.0,
                child: WidgetTab(
                  product: widget.product,
                  image: _qrImage,
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          child: SizedBox(
            width: 120.0,
            height: 30.0,
            child: Center(
                child: Text(
              "Generar QR",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
          ),
          onTap: () async {
            _showAlert(context);
          },
        ),
      ),
    );
  }
}
