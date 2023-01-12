import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:comp414/pages/home/PasswordGeneratePage.dart';
import 'package:comp414/pages/home/PasswordListPage.dart';
import 'package:comp414/pages/home/AccountPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

var bottomNavList = <BottomNavigationBarItem>[
  const BottomNavigationBarItem(
    icon: Icon(Icons.password),
    label: "Create Password",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.list),
    label: "View Passwords",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.account_circle),
    label: "Account",
  ),
];

var pageList = <Widget>[
  const PasswordGenerate(),
  const PasswordList(),
  const Account(),
];

int bottomNavIndex = 1;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        body: pageList[bottomNavIndex],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: const[
              Icon(Icons.enhanced_encryption_outlined, color: Colors.purple, size: 30,),
              Text("  PassPort", style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.w400,
              ),),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavList,
          currentIndex: bottomNavIndex,
          //selectedItemColor: Colors.blue,
          onTap: (int index) {
            setState(() {
              bottomNavIndex = index;
            });
          },
        ),
      ),
    );
  }
}
