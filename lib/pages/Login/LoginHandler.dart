import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comp414/utils/functions.dart';
import 'package:crypt/crypt.dart';
import 'package:local_auth/local_auth.dart';
import 'package:comp414/main.dart';

final LocalAuthentication auth = LocalAuthentication();

class LoginHandler extends StatefulWidget {
  const LoginHandler({Key? key}) : super(key: key);

  @override
  State<LoginHandler> createState() => _LoginHandlerState();
}

class _LoginHandlerState extends State<LoginHandler> {
  bool _isAuthenticating = false;

  Future<bool> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Password Manager requires authentication to use',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        _isAuthenticating = false;
      });
      return false;
    }
    if (!mounted) {
      return false;
    }
    return authenticated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isAuthenticating ? const CircularProgressIndicator() : IconButton(
                onPressed: () async {
                  if (await _authenticate()) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String value2 = Crypt.sha256(
                            prefs.getString("password") ?? "",
                            salt: 'abcdefghijklmnop')
                        .toString();
                    if (await signIn(
                        prefs.getString("e_mail") ?? "", value2)) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      prefs.clear();
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  }
                },
                icon: const Icon(
                  Icons.lock,
                  color: Colors.purple,
                ),
                autofocus: true,
                iconSize: 125,
              ),
              const Text("Press the lock icon to authorize", style: TextStyle(
                fontSize: 20,
              ), textAlign: TextAlign.center,),
            ],
          ),
        ),
      ]),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Authorization"),
      ),
    );
  }
}
