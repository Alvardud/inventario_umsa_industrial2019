import 'package:firebase_storage/firebase_storage.dart';

StorageReference ref;

Future<String> getImagePathInsume({String name}) async {
  try {
    ref = FirebaseStorage.instance.ref().child('insumos').child(name);
    var url = await ref.getDownloadURL();
    return url;
  } catch (e) {
    print(e);
  }
  return null;
}

