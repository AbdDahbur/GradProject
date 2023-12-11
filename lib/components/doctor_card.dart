import 'dart:convert';

import 'package:appointmentapp/api-sql/Doctor.dart';
import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../api-sql/Appointment.dart';
import '../api-sql/TodayAppoin.dart';
import '../api-sql/apiCon.dart';
import '../api-sql/current_user.dart';
import '../api-sql/user.dart';
import '../api-sql/userPref.dart';
import '../screens/doctor_detiails.dart';
import 'package:get/get.dart';
class DoctorCard extends StatefulWidget {


  const DoctorCard({Key? key}) : super(key: key);
  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  final String routes = "";
  User? userNow;

  List<Doctor>? doctors = [];
  @override
  void initState() {
    initializeUser();

    super.initState();
    fetchDoctors();
  }

  Future<void> initializeUser() async {
    User? getUserInfoFromLocalStorage = await getCurrentUser();
    setState(() {
      userNow = getUserInfoFromLocalStorage!;
    });
  }

  Future<User?> getCurrentUser() async {
    User? getUserInfoFromLocalStorage = await RememberUser.readUser();
    return getUserInfoFromLocalStorage;
  }

  final CurrentUser _currentUser = Get.put(CurrentUser());// Initialize with an empty list


  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(Uri.parse(API.top));

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);

        setState(() {
          doctors =
          List<Doctor>.from(resBody["userData"].map((x) => Doctor.fromJson(x)));
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch Doctors data. Please try again.',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error occurred while fetching Doctors data. Please try again.',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Column(
      children: doctors!.isEmpty
          ? [
        Text(
          'No appointments available',
          style: TextStyle(color: Colors.white),
        ),
      ]
          : doctors!.map((doctor) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 150,
          child: GestureDetector(
            child: Card(
              elevation: 5,
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(
                    width: Config.widthSize * 0.33,
                    child: Image.asset(
                      'assets/${doctor.photoPath}',
                      fit: BoxFit.fill,
                    ),
                  ),
                   Flexible(
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            doctor.doctorName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            doctor.Specialization,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.star_border,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Text('4.5'),
                              Spacer(
                                flex: 1,
                              ),
                              Text('Reviews'),
                              Spacer(
                                flex: 1,
                              ),
                              Text('20'),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              // redirect to docotr details page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DoctorDetails(docId: doctor?.DoctorID ?? '',user: userNow!)

                ),
              );
            }, // go to doctor detalis
          ),
        );
      }).toList(),
    );
  }
}
