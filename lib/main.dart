import 'package:flutter/material.dart';
import 'package:comp414/pages/login/LoginPage.dart';
import 'package:comp414/pages/login/RegisterPage.dart';
import 'package:comp414/pages/home/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PasswordManager());
}

class PasswordManager extends StatelessWidget {
  const PasswordManager({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        appBarTheme: const AppBarTheme(
          elevation: 3,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              fontSize: 18,
              color: Colors.black
          ),
          // actionsIconTheme: IconThemeData(
          //
          // ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          /*
          showUnselectedLabels: false,
          showSelectedLabels: false,
          */
          elevation: 2,
          selectedIconTheme: IconThemeData(
              size: 35
          ),
          unselectedIconTheme: IconThemeData(
              size: 30
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

