import 'package:flutter/material.dart';
import 'package:inventario_umsa_industrial2019/data/constants.dart' as constant;

Widget textDescripcion({String key, String value, BuildContext context}) {
  return RichText(
    text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(text: "$key \t"),
          TextSpan(text: value, style: TextStyle(color: Colors.grey[700]))
        ]),
  );
}

Widget iconLeading({String data="otros", int picker, double size = 50.0}) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: constant.colorsDefault[picker % constant.colorsDefault.length]),
    child: Icon(constant.iconsSouvenir["$data"]),
  );
}

Widget customSnackBar({String title}) {
  return SnackBar(
    content: Text(title),
    duration: Duration(seconds: 5),
  );
}