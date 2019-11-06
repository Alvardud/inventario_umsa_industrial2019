import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<Uint8List> _toQrImageData(String text) async {
  try {
    final image = await QrPainter(
            data: text,
            version: QrVersions.auto,
            gapless: false,
            color: Color(0xff03291c),
            emptyColor: Colors.white)
        .toImage(300);
    final a = await image.toByteData(format: ImageByteFormat.png);
    return a.buffer.asUint8List();
  } catch (e) {
    throw e;
  }
}

Future<String> get localPath async {
  final directory = await getExternalStorageDirectory();
  Directory dir = Directory("${directory.path}/CodigosQR");
  dir.create(recursive: true);
  return dir.path;
}

Future<File> _localFile(String nombre) async {
  final path = await localPath;
  return File('$path/$nombre.png');
}

Future<void> saveData(String data, String nombre) async {
  var file = await _localFile(nombre);
  // Write the file.
  _toQrImageData(data).then((value) {
    file.writeAsBytes(value);
  });
}
