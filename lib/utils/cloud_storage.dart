import 'package:firebase_storage/firebase_storage.dart';

Future<String> getImagePathInsume({String name}) async {
  try {
    final ref = FirebaseStorage.instance.ref().child('gs://umsa-industrial.appspot.com/insumos/$name');
    var url = await ref.getDownloadURL() as String;
    print(url);
    return url;
  } catch (e) {
    print(e);
  }
  return null;
}

