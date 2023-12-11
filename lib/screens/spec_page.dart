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
import '../api-sql/user.dart';
import 'doctor_detiails.dart';

class spec_page extends StatefulWidget {
  final String specId;
  final User user;

  const spec_page({
    Key? key,
    required this.specId,
    required this.user,
  }) : super(key: key);

  @override
  State<spec_page> createState() => _spec_page();
}

class _spec_page extends State<spec_page> {
  final String routes = "";

  List<Doctor>? doctors = []; // Initialize with an empty list



  @override
  void initState() {
    super.initState();

    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final Uri uri = Uri.parse('${API.spec}?Specialization=${widget.specId}');
      final response = await http.get(uri);
      //final response = await http.post(Uri.parse(API.spec));

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);

        setState(() {
          doctors = List<Doctor>.from(
              resBody["userData"].map((x) => Doctor.fromJson(x)));
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        title: Text('Doctor List'),
        centerTitle: true,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            ),

          ),

          Expanded(
            child: ListView.builder(
              itemCount: doctors?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Doctor? doctor = doctors?[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
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
                              'assets/${doctor?.photoPath ?? ''}',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    doctor?.doctorName ?? '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    doctor?.Specialization ?? '',
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
                      // redirect to doctor details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DoctorDetails(docId: doctor?.DoctorID ?? '',user: widget.user!)

                        ),
                      );
                    }, // go to doctor details
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
