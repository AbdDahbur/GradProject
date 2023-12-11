import 'dart:convert';
import 'package:appointmentapp/components/appointment_card.dart';
import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/material.dart';
import '../api-sql/apiCon.dart';
import '../api-sql/user.dart';
import '../api-sql/userPref.dart';
import 'package:http/http.dart' as http;
import '../components/doctor_appointment.dart';
import 'auth_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  User? userNow;
  List<dynamic> pendingAppointments = []; // List to store pending appointments
  List<dynamic> approvedAppointments = []; // List to store approved appointments

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
    fetchAppointments();
  }

  Future<User?> getCurrentUser() async {
    User? getUserInfoFromLocalStorage = await RememberUser.readUser();
    return getUserInfoFromLocalStorage;
  }

  Future<void> fetchAppointments() async {
    try {
      var id =userNow?.userId;

      final response = await http.get(Uri.parse(API.doctorappointments + '?doctorId=${id}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> apiResponse = jsonDecode(response.body);
        setState(() {
          pendingAppointments = apiResponse['pendingAppointments'];
          approvedAppointments = apiResponse['approvedAppointments'];
          print(pendingAppointments);
        });

      } else {
        // Handle error if API call fails
        print('Failed to fetch appointments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exception that occurs during API call
      print('Error fetching appointments: $e');
    }
  }

  Widget buildPendingAppointments() {
    if (pendingAppointments.isEmpty) {
      return Text(
        'No pending appointments',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),
      );
    }

    return ListView.builder(

      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: pendingAppointments.length,
      itemBuilder: (context, index) {
        dynamic appointment = pendingAppointments[index];
        return AppointmentCarde(
          appointmentDate: appointment['AppointmentDate'],
          appointmentTime: appointment['appointmentTime'],
          UserName: appointment['UserName'],
          AppointmentID: appointment['AppointmentID'],
          onApprove: () => approveAppointment(appointment['AppointmentID'],'1'),
          onDecline: () => approveAppointment(appointment['AppointmentID'],'3'),
        );
      },
    );
  }
  Widget buildApprovedAppointments() {
    if (approvedAppointments.isEmpty) {
      return Text(
        'No Approved appointments',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),
      );
    }

    return ListView.builder(

      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: approvedAppointments.length,
      itemBuilder: (context, index) {
        dynamic appointment = approvedAppointments[index];
        return AppointmentCarde(
          appointmentDate: appointment['AppointmentDate'],
          appointmentTime: appointment['appointmentTime'],
          UserName: appointment['UserName'],
          AppointmentID: appointment['AppointmentID'],
          onApprove: () => Fluttertoast.showToast(
            msg: 'This Action Restricted After Approve',
            toastLength: Toast.LENGTH_LONG,
          ),
          onDecline: () => Fluttertoast.showToast(
            msg: 'This Action Restricted After Approve',
            toastLength: Toast.LENGTH_LONG,
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 60,
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/logo.png'),
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
                          Icon(
                            Icons.logout,
                            color: Colors.red, // Use Colors.red for logout icon
                          ),
                          Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.red, // Use Colors.red for logout text
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    userNow?.userName.toUpperCase() ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Config.spaceSmall,
                const Text(
                  'Appointments : ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                const Text(
                  'Pending Appointments:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                buildPendingAppointments(),
                Config.spaceSmall,
                const Text(
                  'Upcoming Appointments:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                buildApprovedAppointments(),
                Config.spaceSmall,

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> approveAppointment(String appointmentId,String status) async {
    try {
      var res = await http.post(
        Uri.parse(API.status),
        body: {
          'AppointmentID': appointmentId,
          'appointmentStatus': status,
        },
      );
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          Fluttertoast.showToast(
              msg: 'Appointment Changed Successfully');
          fetchAppointments();
        }

        else {
          Fluttertoast.showToast(
              msg: 'Error, Please try again');
        }
      }
    }
    catch(e){
      Fluttertoast.showToast(
          msg: 'Error, Please try again');
    }
  }

}