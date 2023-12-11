import 'dart:convert';

import 'package:appointmentapp/api-sql/user.dart';
import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../api-sql/Appointment.dart';
import '../api-sql/TodayAppoin.dart';
import '../api-sql/apiCon.dart';
class AppointmentCard extends StatefulWidget {
  final User user;

  const AppointmentCard({Key? key, required this.user}) : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  List<TodayAppoin>? appointments = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    fetchAppointment();
  }

  Future<void> fetchAppointment() async {
    try {
      final response = await http.get(Uri.parse(API.today + '?UserID=${widget.user.userId}'));

      if (response.statusCode == 200) {

        var resBody = jsonDecode(response.body);

        setState(() {
          appointments = List<TodayAppoin>.from(resBody["userData"].map((x) => TodayAppoin.fromJson(x)));

        });
      } else {
        Fluttertoast.showToast(
          msg: 'No appointment data for today',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'No appointments data for today',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  appointmentStatus(var id,var status) async{
    try {
      var res = await http.post(
        Uri.parse(API.status),
        body: {
          'AppointmentID': id,
          'appointmentStatus': status,
        },
      );
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          Fluttertoast.showToast(
              msg: 'Appointment Changed Successfully');

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
  void refreshAppointments() {
    setState(() {
      List<TodayAppoin> appointments = [];
// Clear the existing appointment data
    });
    fetchAppointment(); // Fetch the latest appointment data
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: appointments!.isEmpty
          ? [
        Text(
          'No appointments available',
          style: TextStyle(color: Colors.white),
        ),
      ]
          : appointments!.map((appointment) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Config.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/${appointment.photoPath}'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            appointment.doctorName,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(width: 2),
                          Text(
                            appointment.Specialization,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Config.spaceSmall,
                  ScheduleCard(
                    appointmentDate: appointment.AppointmentDate,
                    appointmentTime: appointment.appointmentTime,
                  ),
                  Config.spaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            appointmentStatus(appointment.AppointmentID,'3');
                            setState(() {
                             appointments!.remove(appointment);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Complete',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            appointmentStatus(appointment.AppointmentID,'2');
                            setState(() {
                              appointments!.remove(appointment);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],

              ),

            ),

          ),

        );
      }).toList(),

    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String appointmentDate;
  final String appointmentTime;

  const ScheduleCard({
    Key? key,
    required this.appointmentDate,
    required this.appointmentTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(width: 5),
          Text(
            appointmentDate,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          SizedBox(width: 5),
          Flexible(child: Text(appointmentTime, style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
