import 'dart:convert';

import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api-sql/TodayAppoin.dart';
import '../api-sql/current_user.dart';
import '../api-sql/user.dart';
import '../api-sql/userPref.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../api-sql/apiCon.dart';
import 'doctor_detiails.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  User? userNow;
  List<TodayAppoin>? UPappointments = []; // Initialize with an empty list
  List<TodayAppoin>? COappointments = []; // Initialize with an empty list
  List<TodayAppoin>? CAappointments = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    initializeData();


  }
  void initializeData() async {
    await getUserData();
    await fetchAppointmentUp();
    await fetchAppointmentFin();
    await fetchAppointmentCan();
  }

  appointmentStatus(var id,var status) async{
    print(id);
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
      UPappointments = [];
      COappointments = [];
      CAappointments = [];
      schedules.clear(); // Clear the existing appointment data
    });
    setState(() {
      schedules.removeWhere((schedule) =>
      schedule['status'] == FilterStatus.cancel); // Remove canceled appointments
    });
    fetchAppointmentUp();
    fetchAppointmentFin();
    fetchAppointmentCan(); // Fetch the latest appointment data
  }
  User? user;

  Future<User?> getCurrentUser() async {
    User? getUserInfoFromLocalStorage = await RememberUser.readUser();
    return getUserInfoFromLocalStorage;
  }

  Future<void> getUserData() async {
    user = await getCurrentUser();
    if (user != null) {
      setState(() {});
    }
  }


  List<dynamic> schedules = []; // Initialize with an empty list

  Future<void> fetchAppointmentUp() async {
    try {
      final response = await http.get(Uri.parse(
          API.upcoming + '?UserID=${user?.userId}'));

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);

        List<TodayAppoin> appointments = List<TodayAppoin>.from(
            resBody["userData"].map((x) => TodayAppoin.fromJson(x)));

        List<dynamic> newSchedules = appointments.map((appointment) {
          return {
            "doctor_name": appointment.doctorName,
            "doctor_id": appointment.DoctorID,
            "doctor_profile": "assets/${appointment.photoPath}", // Replace with the actual profile image path
            "category": appointment.Specialization,
            "status": FilterStatus.upcoming,
            "time": appointment.appointmentTime,
            "date" :appointment.AppointmentDate ,
            "id"  : appointment.AppointmentID ,
          };
        }).toList();

        setState(() {
          schedules.addAll(newSchedules);
        });
      } else {
        Fluttertoast.showToast(
          msg: 'No Upcoming Appointments',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'No Upcoming Appointments',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> fetchAppointmentFin() async {
    try {
      final response = await http.get(Uri.parse(
          API.finished + '?UserID=${user?.userId}'));

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);

        List<TodayAppoin> appointments = List<TodayAppoin>.from(
            resBody["userData"].map((x) => TodayAppoin.fromJson(x)));

        List<dynamic> newSchedules = appointments.map((appointment) {
          return {
            "doctor_name": appointment.doctorName,
            "doctor_id": appointment.DoctorID,
            "doctor_profile": "assets/${appointment.photoPath}", // Replace with the actual profile image path
            "category": appointment.Specialization,
            "status": FilterStatus.complete,
            "time": appointment.appointmentTime,
            "date": appointment.AppointmentDate,
            "id": appointment.AppointmentID,
          };
        }).toList();

        setState(() {
          // Remove existing completed appointments from schedules list
          schedules.removeWhere((schedule) =>
          schedule['status'] == FilterStatus.complete);

          // Add new completed appointments to schedules list
          schedules.addAll(newSchedules);
        });
      } else {
        Fluttertoast.showToast(
          msg: 'No Finished Appointments',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'No Finished Appointments',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }


  Future<void> fetchAppointmentCan() async {
    try {
      final response = await http.get(Uri.parse(
          API.canceled + '?UserID=${user?.userId}'));

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);

        List<TodayAppoin> appointments = List<TodayAppoin>.from(
            resBody["userData"].map((x) => TodayAppoin.fromJson(x)));

        List<dynamic> newSchedules = appointments.map((appointment) {
          return {
            "doctor_name": appointment.doctorName,
            "doctor_id": appointment.DoctorID,
            "doctor_profile": "assets/${appointment.photoPath}", // Replace with the actual profile image path
            "category": appointment.Specialization,
            "status": FilterStatus.cancel,
            "time": appointment.appointmentTime,
            "date" :appointment.AppointmentDate ,
            "id"  : appointment.AppointmentID ,
          };
        }).toList();

        setState(() {
          schedules.addAll(newSchedules);
        });
      } else {
        Fluttertoast.showToast(
          msg: 'No Canceled Appointments',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'No Canceled Appointments',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }


  FilterStatus status = FilterStatus.upcoming; // initial status
  Alignment _alignment = Alignment.centerLeft;

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredSchedules = schedules.where((var schedule) {
      return schedule['status'] == status;
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Appointment schedule ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Config.spaceSmall,
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // for filter tabs
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (filterStatus == FilterStatus.upcoming) {
                                  status = FilterStatus.upcoming;
                                  _alignment = Alignment.centerLeft;
                                } else if (filterStatus ==
                                    FilterStatus.complete) {
                                  status = FilterStatus.complete;
                                  _alignment = Alignment.center;
                                } else if (filterStatus ==
                                    FilterStatus.cancel) {
                                  status = FilterStatus.cancel;
                                  _alignment = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(filterStatus.name),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Config.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Config.spaceSmall,
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchedules.length,
                itemBuilder: (context, index) {
                  var _schedule = filteredSchedules[index];
                  bool isLasrElement =
                      filteredSchedules.length + 1 == index;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: !isLasrElement
                        ? const EdgeInsets.only(bottom: 20)
                        : EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    _schedule['doctor_profile']),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _schedule['doctor_name'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _schedule['category'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //schedule card
                          ScheduleCard(schedule: _schedule),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    appointmentStatus(_schedule['id'],'3');
                                    refreshAppointments();

                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Config.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Config.primaryColor,
                                  ),
                                  onPressed: () {
                                    appointmentStatus(_schedule['id'], '2');
                                    refreshAppointments();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DoctorDetails(
                                                  docId: _schedule['doctor_id'],
                                                  user: user!)

                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Reschedule',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ScheduleCard extends StatelessWidget {
  final dynamic schedule;

  const ScheduleCard({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            color: Config.primaryColor,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            schedule['date'] ?? '', // Access the date property of the schedule
            style: TextStyle(color: Config.primaryColor),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.access_alarm,
            color: Config.primaryColor,
            size: 17,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              schedule['time'] ?? '',
              style: TextStyle(color: Config.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
