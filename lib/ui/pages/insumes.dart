import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/models/insumos.dart';
import 'package:inventario_umsa_industrial2019/ui/pages/insume_view.dart';
import 'package:inventario_umsa_industrial2019/utils/firebase_request.dart'
    as firebase;
import 'package:inventario_umsa_industrial2019/ui/pages/new_insume.dart';

class Insumes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      InsumesList(),
      Positioned(
          bottom: 8.0,
          right: 8.0,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => NewInsume()
              ));
            },
          ),
        )
    ]);
  }
}

class InsumesList extends StatefulWidget {
  @override
  _InsumesListState createState() => _InsumesListState();
}

class _InsumesListState extends State<InsumesList> {
  List<Insumos> _insumes = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase.readInsumes(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (!snap.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: snap.data.length,
          itemBuilder: (context, item) {
            _insumes = snap.data;
            if (_insumes.length != 0) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${_insumes[item].cantidad}',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Text(
                          "Unid.",
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      ],
                    ),
                    title: Text(
                        "${_insumes[item].nombre[0].toUpperCase()}${_insumes[item].nombre.substring(1)}"),
                    subtitle: Text("${_insumes[item].descripcion}"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InsumesView(
                                    insumo: _insumes[item],
                                  )));
                    },
                  ),
                  Divider()
                ],
              );
            } else {
              return Center(
                child: Text('No Items'),
              );
            }
          },
        );
      },
    );
  }
}
