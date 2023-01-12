import 'package:comp414/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    SharedPreferences prefs;

    return Center(
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pushReplacementNamed(context, '/login');
          final SharedPreferences prefs = await _prefs;
          prefs.clear();
          prefs.reload();
          },
        child: const Text("Sign Out"),
      ),
    );
  }
}
