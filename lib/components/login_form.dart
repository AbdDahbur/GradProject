import 'dart:convert';

import 'package:appointmentapp/api-sql/userPref.dart';
import 'package:appointmentapp/components/button.dart';
import 'package:appointmentapp/components/signup_form.dart';
import 'package:appointmentapp/components/signup_formdoctor.dart';
import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../api-sql/apiCon.dart';
import '../api-sql/user.dart';
import '../screens/doctor_homePage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCotroller = TextEditingController();
  final _passCotroller = TextEditingController();
  bool obsecurePass = true;

  loginUserNow() async{
    try {
      var res = await http.post(
        Uri.parse(API.login),
        body: {
          'Username': _emailCotroller.text,
          'Password': _passCotroller.text,
        },
      );
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          Fluttertoast.showToast(
              msg: 'Your Logged-In Successfully');
          User userInfo = User.fromJson(resBody["userData"]);

          await RememberUser.saveUser(userInfo);
          if(userInfo.roleId =='2') {
            Future.delayed(Duration(milliseconds: 1000), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DoctorHomePage(),
                ),
              );
            });
          }
          else {
            Future.delayed(Duration(milliseconds: 1000), () {
              Navigator.of(context).pushNamed('main');
            });
          }
        }
        else {
          Fluttertoast.showToast(
              msg: 'Invalid Credentials, Please try again');
        }
      }
    }
    catch(e){
      Fluttertoast.showToast(
          msg: 'Error, Please try again');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailCotroller,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'User Name',
              labelText: 'User Name',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.person),
              prefixIconColor: Config.primaryColor,
            ),
          ),

          Config.spaceSmall,

          TextFormField(
            controller: _passCotroller,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration:  InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass= !obsecurePass;
                      });
                    },
                    icon : obsecurePass
                        ? const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.black38,
                    )
                        : const Icon (
                      Icons.visibility_outlined,
                      color: Config.primaryColor,
                    ),
                ),
            ),
          ),
          Config.spaceSmall,
          //login button
          Button(
            width: double.infinity,
            title: 'Log In ',
            onPressed:() {
              if(_formKey.currentState!.validate()){
                loginUserNow();
              }
            } ,
            disable: false ,
          ),
          Button(
            width: double.infinity,
            title: 'Sign Up',
            onPressed:() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupForm()),
              );
               },
            disable: false ,
          ),

          Button(
            width: double.infinity,
            title: 'Sign Up as Docotr',
            onPressed:() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupFormDoctor()),
              );
            },
            disable: false ,
          ),
        ],
      ),

    );
  }
}
