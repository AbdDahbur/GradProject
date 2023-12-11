import 'package:appointmentapp/api-sql/current_user.dart';
import 'package:appointmentapp/components/appointment_card.dart';
import 'package:appointmentapp/components/doctor_card.dart';
import 'package:appointmentapp/screens/spec_page.dart';
import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../api-sql/user.dart';
import '../api-sql/userPref.dart';
import '../components/button.dart';
import 'auth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? userNow;
  @override
  void initState() {
  super.initState();
  initializeUser();
  }

  void initializeUser() async {
    User? getUserInfoFromLocalStorage = await getCurrentUser();
    setState(() {
      userNow = getUserInfoFromLocalStorage;
    });
  }


  Future<User?> getCurrentUser() async {
    User? getUserInfoFromLocalStorage = await RememberUser.readUser();
    return getUserInfoFromLocalStorage;
  }


  //_currentUser.value=getUser Info FromLocalStorage;
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General",
      "id":"1",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Carediology",
      "id":"2",
    },
    {
      "icon": FontAwesomeIcons.lungs,
      "category": "Respirations",
      "id":"3",
    },
    {
      "icon": FontAwesomeIcons.hand,
      "category": "Dermatology",
      "id":"4",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Gymecology",
      "id":"5",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Dental",
      "id":"6",
    },

  ];

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    Text(
                      'Hello',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                     userNow?.userName.toUpperCase() ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/logo.png'),
                      ),

                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthPage(),
                          ),
                        );
                      },

                      child: Column(
                        children: [
                          Icon(Icons.logout,
                            color: Config.primaryColor,
                          ),
                          Text('Log Out',
                            style: TextStyle( color: Config.primaryColor,),

                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                Config.spaceSmall,
                const Text(
                  'Category', // hard code user name at first
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(medCat.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          // Handle the on-press action for each category
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                spec_page(specId: medCat[index]['id'],user: userNow!)

                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(right: 20),
                          color: Config.primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FaIcon(
                                  medCat[index]['icon'],
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  medCat[index]['category'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Config.spaceSmall,
                const Text(
                  'Appointment Today', // hard code user name at first
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                if (userNow != null) AppointmentCard(user: userNow!),
                Config.spaceSmall,
                const Text(
                  'Top Doctors', // hard code user name at first
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // List of top doctors
                Config.spaceSmall,
                DoctorCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}