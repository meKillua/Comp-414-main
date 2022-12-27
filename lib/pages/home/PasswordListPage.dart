import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp414/utils/functions.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordList extends StatefulWidget {
  const PasswordList({Key? key}) : super(key: key);

  @override
  State<PasswordList> createState() => _PasswordListState();
}

class _PasswordListState extends State<PasswordList> {
  CollectionReference users = FirebaseFirestore.instance
      .collection('users')!
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Passwords");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: users.get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Card(
              elevation: 4,
              child: ListTile(
                // onTap: (() {
                //   showDialog(
                //       context: context,
                //       builder: (context) => AlertDialog(
                //           alignment: Alignment.center,
                //           content: Container(
                //             height: 500,
                //             width: 500,
                //             child: Column(
                //               children: [
                //                 Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: Container(
                //                     width: 500,
                //                     height: 50,
                //                     decoration: BoxDecoration(
                //                       color: Colors.transparent,
                //                       border: Border.all(color: Colors.purple),
                //                       borderRadius: BorderRadius.all(
                //                         Radius.circular(15.0),
                //                         //                 <--- border radius here
                //                       ),
                //                     ),
                //                     child: Padding(
                //                       padding: const EdgeInsets.only(
                //                           left: 15.0, right: 15.0),
                //                       child: Text(
                //                         snapshot
                //                             .data!.docs[index]["description"]
                //                             .toString(),
                //                         style: TextStyle(fontSize: 25),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //                 Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: Container(
                //                     width: 500,
                //                     height: 50,
                //                     decoration: BoxDecoration(
                //                       color: Colors.transparent,
                //                       border: Border.all(color: Colors.purple),
                //                       borderRadius: BorderRadius.all(
                //                         Radius.circular(15.0),
                //                         //                 <--- border radius here
                //                       ),
                //                     ),
                //                     child: Padding(
                //                       padding: const EdgeInsets.only(
                //                           left: 15.0, right: 15.0),
                //                       child: Text(
                //                         decryptPassword(snapshot
                //                             .data!.docs[index]["password"]
                //                             .toString()),
                //                         style: TextStyle(fontSize: 25),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           )));
                // }),
                trailing: IconButton(
                    onPressed: () {
                      final data = ClipboardData(
                          text: decryptPassword(snapshot
                              .data!.docs[index]["password"]
                              .toString()));
                      Clipboard.setData(data);
                    },
                    icon: const Icon(Icons.copy)),
                title: Text(
                  snapshot.data!.docs[index]["description"].toString(),
                  style: const TextStyle(fontSize: 23),
                ),
                subtitle: Text(
                  decryptPassword(
                      snapshot.data!.docs[index]["password"].toString()),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return const Center(
              child:
                  Text("Please make sure you are connected to the internet."),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
