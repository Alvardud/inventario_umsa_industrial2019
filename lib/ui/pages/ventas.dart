import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:inventario_umsa_industrial2019/utils/movimiento.dart' as ventas;
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'
    as common;

class Ventas extends StatefulWidget {
  final bool registro;
  Ventas({this.registro});
  @override
  _VentasState createState() => _VentasState();
}

class _VentasState extends State<Ventas> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  String id;
  QRViewController controller;

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      setState(() {
        qrText = scanData;
      });
      try {
        var _valores = qrText.split("|");
        id = _valores[1];
        if (!widget.registro) {
          if (_valores[0] == "producto") {
            ventas.ventaProducto(id, context).then((value) => setState(() {
                  if (value) {
                    Scaffold.of(context).showSnackBar(
                        common.customSnackBar(title: 'Guardado Correctamente'));
                  } else {
                    Scaffold.of(context).showSnackBar(common.customSnackBar(
                        title:
                            'Ah ocurrido un error\nNo hay la cantidad de productos suficientes\nVerifique su conexion a internet'));
                  }
                }));
          } else {
            ventas.ventaInsumo(id, context).then((value) => setState(() {
                  if (value) {
                    Scaffold.of(context).showSnackBar(
                        common.customSnackBar(title: 'Guardado Correctamente'));
                  } else {
                    Scaffold.of(context).showSnackBar(common.customSnackBar(
                        title:
                            'Ah ocurrido un error\nNo hay la cantidad de productos suficientes\nVerifique su conexion a internet'));
                  }
                }));
          }
        } else {
          if(_valores[0]=="producto"){
            ventas.registroProducto(id, context).then((value) => setState(() {}));
          }else{

          }
        }
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: (Stack(
          children: <Widget>[
            QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                _onQRViewCreated(controller, context);
              },
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).accentColor,
                borderRadius: 10,
                borderLength: 20,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width - 100.0,
                overlayColor: Colors.black.withOpacity(0.7),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  'Align the QR code within \n the frame to scan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16.0),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  @override
  void dispose() {
    this.controller?.dispose();
    super.dispose();
  }
}

/*
  _customBottomSheet() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      height: 150.0,
      color: constant.primaryColor,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              'Seleccione los puntos a dar al asistente:',
              style: TextStyle(
                color: constant.secundaryColor,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CustomButton(
                      icon: Icons.filter_1,
                      addFunction: _updateTicket,
                      value: 1),
                  CustomButton(
                      icon: Icons.filter_3,
                      addFunction: _updateTicket,
                      value: 3),
                  CustomButton(
                      icon: Icons.filter_5,
                      addFunction: _updateTicket,
                      value: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _customOrganizerBottomSheet() {
    return Container(
      height: 150.0,
      color: constant.primaryColor,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              'Seleccione la logistica a entregar:',
              style: TextStyle(
                color: constant.secundaryColor,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CustomButton(
                    icon: constant.iconsSouvenir['desayuno'],
                    addFunction: _updateTicketOrganizer,
                    valueOrganizer: 'desayuno',
                    isEnable: this.ticket.data['logistic']['desayuno'],
                  ),
                  CustomButton(
                    icon: constant.iconsSouvenir['almuerzo'],
                    addFunction: _updateTicketOrganizer,
                    valueOrganizer: 'almuerzo',
                    isEnable: this.ticket.data['logistic']['almuerzo'],
                  ),
                  CustomButton(
                    icon: constant.iconsSouvenir['souvenir'],
                    addFunction: _updateTicketOrganizer,
                    valueOrganizer: 'souvenir',
                    isEnable: this.ticket.data['logistic']['souvenir'],
                  ),
                  CustomButton(
                    icon: constant.iconsSouvenir['regalo'],
                    addFunction: _updateTicketOrganizer,
                    valueOrganizer: 'regalo',
                    isEnable: this.ticket.data['logistic']['regalo'],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Firebase call query
  Future<void> _searchForTicket(String scanData) async {
    QuerySnapshot _t = await databaseReference
        .collection(constant.collectionDefault)
        .where('hash', isEqualTo: scanData)
        .getDocuments();
    if (_t.documents.length == 0) {
      // Lunch qr no register
      this.ticket = null;
    }
    if (_t.documents.length == 1) {
      // Lunch qr register Assign points or meals
      this.ticket = _t.documents[0];
    }
    return Future.value(0);
  }

  _updateTicket(int value) async {
    var x = this.ticket.data;
    x[_company.type][_company.name] = value;
    await databaseReference
        .collection(constant.collectionDefault)
        .document(this.ticket.documentID)
        .updateData(x);
  }

  _updateTicketOrganizer(String organizer) async {
    var x = this.ticket.data;
    x['logistic'][organizer] = true;
    await databaseReference
        .collection(constant.collectionDefault)
        .document(this.ticket.documentID)
        .updateData(x);
  }

  
}*/
