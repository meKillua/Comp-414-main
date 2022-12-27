import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp414/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:crypt/crypt.dart';

class PasswordGenerate extends StatefulWidget {
  const PasswordGenerate({Key? key}) : super(key: key);

  @override
  State<PasswordGenerate> createState() => _PasswordGenerateState();
}

int passLength = 12;

class _PasswordGenerateState extends State<PasswordGenerate> {
  CollectionReference users = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Passwords");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
        Duration.zero,
        () => _generatePassword(
            length: passLength,
            includeMisc: includeMisc,
            includeNumbers: includeNum,
            includeLowerCase: includeLower,
            includeUpperCase: includeUpper));
  }

  void _generatePassword(
      {int length = 4,
      bool includeNumbers = true,
      bool includeLowerCase = false,
      bool includeUpperCase = false,
      bool includeMisc = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();

    bool doGenerate = false;

    var lowerCaseList = "qwertyuopasdfghjklizxcvbnm";
    var upperCaseList = "ABCDEWGHIJKLMNOPRSTUVYZQWX";
    var numberList = "0123456789";
    var miscList = "!_?*&%+-.,'^\"#:;";

    List<String> charList = [];
    String pass = "";

    length.clamp(4, 32);

    includeLower
        ? {charList.add(lowerCaseList), doGenerate = true}
        : charList = charList;
    includeUpper
        ? {charList.add(upperCaseList), doGenerate = true}
        : charList = charList;
    includeNum
        ? {charList.add(numberList), doGenerate = true}
        : charList = charList;
    includeMisc
        ? {charList.add(miscList), doGenerate = true}
        : charList = charList;

    if (doGenerate) {
      for (int i = 0; i < length; i++) {
        var currentList = charList[Random.secure().nextInt(charList.length)];
        pass += currentList[Random.secure().nextInt(currentList.length)];

        setState(() {
          generatedPasswordField.text = pass;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(passFailBar);
    }
  }

  bool includeNum = true;
  bool includeUpper = true;
  bool includeLower = true;
  bool includeMisc = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 0.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 24,
                                  ),
                                  controller: generatedPasswordField,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    final data = ClipboardData(
                                        text: generatedPasswordField.text);
                                    Clipboard.setData(data);
                                  },
                                  icon: const Icon(Icons.copy)),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: width / 8,
                                width: width / 8,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  autocorrect: false,
                                  controller: passLengthField,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == "") {
                                        value = "4";
                                      }
                                      passLength =
                                          int.parse(value).clamp(4, 32);
                                    });
                                  },
                                  onEditingComplete: () => setState(() {
                                    passLengthField.text =
                                        passLength.toString();
                                  }),
                                  onSubmitted: (value) => setState(() {
                                    passLengthField.text =
                                        passLength.toString();
                                  }),
                                ),
                              ),
                              RotatedBox(
                                quarterTurns: 3,
                                child: SizedBox(
                                  width: 2 * height / 8,
                                  child: Slider(
                                    value: passLength.toDouble(),
                                    max: 32,
                                    min: 4,
                                    label: passLength.toInt().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        passLength = value.toInt();
                                        passLengthField.text =
                                            passLength.toString();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2 * height / 7 + width / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        value: includeNum,
                                        onChanged: (value) => setState(() {
                                              includeNum = !includeNum;
                                            })),
                                    const Text("Include Numbers"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: includeLower,
                                        onChanged: (value) => setState(() {
                                              includeLower = !includeLower;
                                            })),
                                    const Text("Include Lowercase Letters"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: includeUpper,
                                        onChanged: (value) => setState(() {
                                              includeUpper = !includeUpper;
                                            })),
                                    const Text("Include Uppercase Letters"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: includeMisc,
                                        onChanged: (value) => setState(() {
                                              includeMisc = !includeMisc;
                                            })),
                                    const Text("Include Symbols"),
                                  ],
                                ),
                                SizedBox(
                                  width: width * 3 / 5,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _generatePassword(
                                            length: passLength,
                                            includeMisc: includeMisc,
                                            includeNumbers: includeNum,
                                            includeLowerCase: includeLower,
                                            includeUpperCase: includeUpper);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          elevation: 8),
                                      child: const Text('Generate')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Card(
                    elevation: 8,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Enter a description",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 20),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    hintText: 'Description',
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 24,
                                  ),
                                  controller: passDescriptionField,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passDescriptionField.text = "";
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (passDescriptionField.text.isNotEmpty) {
                                    createPassword(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        passDescriptionField.text,
                                        encryptPassword(
                                            generatedPasswordField.text));
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(successBar);
                                    setState(() {
                                      passDescriptionField.text = "";
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(descFailBar);
                                  }
                                },
                                style: ElevatedButton.styleFrom(elevation: 8),
                                child: const Text('Save')),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}

TextEditingController passDescriptionField = TextEditingController();
TextEditingController passLengthField =
    TextEditingController(text: passLength.toString());
TextEditingController generatedPasswordField = TextEditingController();

const passFailBar = SnackBar(
  content: Text(
    'Please select at least one type of characters',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red,
);

const descFailBar = SnackBar(
  content: Text(
    'Please enter a description',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red,
);

const failBar = SnackBar(
  content: Text(
    'An error has occured while saving your password',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red,
);

const passLengthFailBar = SnackBar(
  content: Text(
    'Please keep your password between 4 - 32 characters',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red,
);

const successBar = SnackBar(
  content: Text(
    'Successfully saved the password',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.green,
);

const copySuccessBar = SnackBar(
  content: Text(
    'Successfully copied the password to clipboard',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.green,
);
