import 'package:appointmentapp/components/login_form.dart';
import 'package:appointmentapp/utils/config.dart';
import 'package:appointmentapp/utils/text.dart';
import 'package:flutter/material.dart';

import 'doctor_homePage.dart';

class AuthPage extends StatefulWidget {

  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    //login
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                /*Text(
                  'Welcome',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),*/
                Center(
                  child: Image.asset('assets/logo.png'



                  ),
                ),

                const Text(
                  'Log in to your account ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                LoginForm(),
                Config.spaceSmall,
                Center(
                  child: TextButton(
                    onPressed: () {

                      const snackBar = SnackBar(
                      content: Text('We Will Send you a new password via email in a few minutes!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);},
                    child: const Text(
                      'Forgot Your Password?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
