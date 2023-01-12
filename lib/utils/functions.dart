


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ninja/asymmetric/rsa/rsa.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<bool> register(String email, String password) async {
  try {
     await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
     print("Succeed");
     return true;


  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      //print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      //print('The account already exists for that email.');
    }else{
      //print(e.code);
    }
    return false;
  } catch (e) {
    //print(e);
    return false;
  }
}


Future<bool> signIn(String email, String password) async {
  try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      //print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      //print('Wrong password provided for that user.');
    }
    return false;
  }
}

Future<void> createUser(String id, String name,String email, String password) async {
  users.doc(id).set({
    'id':id,
    'name':name,
    'email':email,
    'originalPassword': password,
  });
}



Future<void> createPassword(String id, String description, String password) async {
  users.doc(id).collection("Passwords").add({
    'description':description,
    'password': password,
  });
}

final privateKeyPem = '''
-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBAMv7Reawnxr0DfYN3IZbb5ih/XJGeLWDv7WuhTlie//c2TDXw/mW
914VFyoBfxQxAezSj8YpuADiTwqDZl13wKMCAwEAAQJAYaTrFT8/KpvhgwOnqPlk
NmB0/psVdW6X+tSMGag3S4cFid3nLkN384N6tZ+na1VWNkLy32Ndpxo6pQq4NSAb
YQIhAPNlJsV+Snpg+JftgviV5+jOKY03bx29GsZF+umN6hD/AiEA1ouXAO2mVGRk
BuoGXe3o/d5AOXj41vTB8D6IUGu8bF0CIQC6zah7LRmGYYSKPk0l8w+hmxFDBAex
IGE7SZxwwm2iCwIhAInnDbe2CbyjDrx2/oKvopxTmDqY7HHWvzX6K8pthZ6tAiAw
w+DJoSx81QQpD8gY/BXjovadVtVROALaFFvdmN64sw==
-----END RSA PRIVATE KEY-----''';

final privateKey = RSAPrivateKey.fromPEM(privateKeyPem);

encryptPassword(String password){

  final publicKey = privateKey.toPublicKey;

  String encrypted = publicKey.encryptOaepToBase64(password);


  return encrypted;
}

decryptPassword(String password){
  String decrypted = privateKey.decryptOaepToUtf8(password);

  return decrypted;
}

bool checkPassword(String password) {

  return false;
}
