import 'package:appointmentapp/screens/booking_page.dart';
import 'package:appointmentapp/screens/doctor_detiails.dart';
import 'package:appointmentapp/screens/success_booked.dart';
import 'package:flutter/material.dart';
import 'components/signup_form.dart';
import 'utils/config.dart';
import 'screens/auth_page.dart';
import 'main_layout.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //this is for push navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: navigatorKey ,
      title: 'Appointment App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //pre-define input decoration
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: Config.primaryColor,
          errorBorder: Config.errorBorder,
          enabledBorder: Config.outlineBorder,
          floatingLabelStyle: TextStyle(color:Config.primaryColor),
          prefixIconColor: Colors.black38,

        ) ,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Config.primaryColor,
          selectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey.shade700,
          elevation: 10,
          type :BottomNavigationBarType.fixed,
        ),

      ),

      initialRoute: '/',
      //this is initial route
      routes: {
        '/':(context) => const AuthPage(),
        '/signup':(context) => const SignupForm(),
        'main': (context) => const MainLayout(),
        //'doc_details':(context) => const DoctorDetails(),
       // 'booking_page':(context) => const BookinkPage(),
        'success_booking':(context) => const AppointmentBooked(),
       },

    );
  }
}









