import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp414/utils/functions.dart';
import 'package:crypt/crypt.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Warning'),
                content: const SingleChildScrollView(
                  child: Text(
                    'Are you sure you want to exit the application?',
                    //textAlign: TextAlign.center,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Confirm'),
                    onPressed: () async {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Log In"),
          ),
          body: CustomScrollView(
            //avoid render problems
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          child: //Image.asset("src/logo_1.png"), insert logo maybe
                              const Text("PM"),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: username,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: 'E Mail',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: ElevatedButton(
                              onPressed: () async {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                if (username.text.isNotEmpty &&
                                    password.text.isNotEmpty) {
                                  try {
                                    //login
                                    String value2 = Crypt.sha256(password.text,
                                            salt: 'abcdefghijklmnop')
                                        .toString();
                                    if (await signIn(username.text, value2)) {
                                      //on success
                                      Navigator.pushNamed(context, '/home');
                                    } else {
                                      //on wrong login
                                      ScaffoldMessenger.of(context).showSnackBar(wrongBar);
                                    }
                                  } catch (E) {
                                    //on timeout
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(failBar);
                                    //print(E);
                                  }
                                }
                              },
                              child: const Text('Login'),
                            ),
                          ),
                          SizedBox(
                            width: width / 20,
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text('Register'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

TextEditingController username = TextEditingController();
TextEditingController password = TextEditingController();

const failBar = SnackBar(
  content: Text(
    'An error has occurred while signing in.',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red,
);

const wrongBar = SnackBar(
  content: Text(
    'Please check your login credentials and try again.',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red,
);
