

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp414/utils/functions.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users')!.doc(FirebaseAuth.instance.currentUser!.uid).collection("Passwords");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${FirebaseAuth.instance.currentUser!.email}"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[SingleChildScrollView(
              child: StreamBuilder(
                stream: users
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  print(streamSnapshot.data!.docs.length);
                  return Container(
                    width: 500,
                    height: 500,
                    child: ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (ctx, index) =>
                          InkWell(
                            onTap: ((){
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                  alignment: Alignment.center,
                                  content:
                                  Container(
                                    height: 500,
                                    width: 500,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 500,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: Colors.purple),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    15.0),
                                                //                 <--- border radius here
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                                              child: Text(streamSnapshot.data!.docs[index]["description"].toString(),style: TextStyle(fontSize: 25),),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 500,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: Colors.purple),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    15.0),
                                                //                 <--- border radius here
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                                              child: Text(decryptPassword(streamSnapshot.data!.docs[index]["password"].toString()),style: TextStyle(fontSize: 25),),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),

                                  )
                                  ));
                            }),
                            child: ListTile(
                                title:Text(streamSnapshot.data!.docs[index]["description"].toString(),style: TextStyle(fontSize: 25),),
                                subtitle:Text(decryptPassword(streamSnapshot.data!.docs[index]["password"].toString()),style: TextStyle(fontSize: 25),),

                            ),
                          ),
                    ),
                  );
                },
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ((){
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
              alignment: Alignment.center,
              content: Container(
                height: 500,
                width: 500,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 500,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: Colors.purple),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                15.0),
                            //                 <--- border radius here
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                          child: TextField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              hintText: "Description",hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            cursorColor: Colors.purple,
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 500,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: Colors.purple),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                15.0),
                            //                 <--- border radius here
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                          child: TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: "Password",hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            cursorColor: Colors.purple,
                            style: TextStyle(color: Colors.purple),
                            enableSuggestions: false,
                            autocorrect: false,

                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            child: Text('Add Password'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                            onPressed: ()  async {

                              //String s=encryptPassword( _passwordController.text);
                              //print(s);
                              //String k =decryptPassword(s);
                              //print( k);

                              createPassword(FirebaseAuth.instance.currentUser!.uid, _descriptionController.text, encryptPassword( _passwordController.text));
                              Navigator.pop(context);


                            }
                        ),
                      ) ,
                    )
                  ],
                ),

              )));
        }),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



/*
*
*
* */