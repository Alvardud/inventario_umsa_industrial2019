import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/models/product.dart';
import 'package:inventario_umsa_industrial2019/ui/widgets/common.dart'
    as common;
import 'package:qr_flutter/qr_flutter.dart';

class WidgetTab extends StatefulWidget {
  final Product product;
  final Image image;
  WidgetTab({this.product, this.image});

  @override
  _WidgetTabState createState() => _WidgetTabState();
}

class _WidgetTabState extends State<WidgetTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  GlobalObjectKey _renderObjectKey;

  String _generateContent() {
    return ("producto|${widget.product.id}|${widget.product.nombre}|${widget.product.precio}|${widget.product.fechaVen}|${widget.product.tipo}|${widget.product.descripcion}");
  }

  Widget _qrWidget() {
    return SizedBox(
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
    ));
  }

  Widget _information() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
              child: Text(
            '${widget.product.nombre[0].toUpperCase()}${widget.product.nombre.substring(1)}',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 16.0,
          ),
          Center(
              child: Text(
            "${widget.product.descripcion[0].toUpperCase()}${widget.product.descripcion.substring(1)}",
            style: TextStyle(color: Colors.grey),
          )),
          SizedBox(
            height: 8.0,
          ),
          common.textDescripcion(
              key: 'Precio:',
              value: "${widget.product.precio} Bs.",
              context: context),
          common.textDescripcion(
              key: 'Fecha compra:',
              value: "${widget.product.fechaComp}",
              context: context),
          common.textDescripcion(
              key: 'Fecha vencimiento:',
              value: "${widget.product.fechaVen}",
              context: context),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _qrWidget(),
              _information(),
            ],
          ),
          bottomNavigationBar: TabBar(
            indicatorColor: Colors.transparent,
            labelColor: Colors.black,
            unselectedLabelStyle: TextStyle(color: Colors.grey),
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: 'QR'),
              Tab(
                text: "Información",
              )
            ],
          )),
    );
  }
}
