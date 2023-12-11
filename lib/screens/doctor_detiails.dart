import 'dart:convert';

import 'package:appointmentapp/components/button.dart';
import 'package:appointmentapp/components/custom_appbar.dart';
import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../api-sql/Appointment.dart';
import '../api-sql/Doctor2.dart';
import '../api-sql/TodayAppoin.dart';
import '../api-sql/apiCon.dart';
import '../api-sql/user.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'booking_page.dart';

class DoctorDetails extends StatefulWidget {
  final String docId;
  final User user;

  const DoctorDetails({
    Key? key,
    required this.docId,
    required this.user,
  }) : super(key: key);

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool isFav = false; // for favorite doctors
  Doctor2? doctor;

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    try {
      final Uri uri = Uri.parse('${API.doctor}?DoctorID=${widget.docId}');
      final response = await http.get(uri);

      if (response.statusCode == 200) {

        var resBody = jsonDecode(response.body);

        setState(() {
          doctor = Doctor2.fromJson(resBody["userData"]);
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch Doctor data. Please try again.',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error occurred while fetching Doctor data. Please try again.',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final Doctor2? currentDoctor = doctor;

    return Scaffold(
      appBar: CustomAppBar(
        appTitile: 'Doctor Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          // Fav button
          IconButton(
            onPressed: () {
              setState(() {
                isFav = !isFav;
              });
            },
            icon: FaIcon(
              isFav ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            if (currentDoctor != null) ...[
              AboutDoctor(doctor: currentDoctor),
              DetailBody(doctor: currentDoctor),
            ],
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                width: double.infinity,
                title: 'Book Appointment',
                onPressed: () {
                  // redirect to doctor details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BookinkPage(docId: doctor?.DoctorID ?? '',user: widget.user!)

                    ),
                  );
                },
                disable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  final Doctor2 doctor;

  const AboutDoctor({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundImage: AssetImage('assets/${doctor.photoPath}'),
            backgroundColor: Colors.white,
          ),
          Config.spaceSmall,
          Text(
            doctor.doctorName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.65,
            child: Text(
              doctor.Education,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.65,
            child: Text(
              doctor.HospitalAffiliation,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
class DetailBody extends StatelessWidget {
  final Doctor2 doctor;

  const DetailBody({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Config.spaceSmall,
            DoctorInfo(doctor: doctor),
            Config.spaceSmall,
            const Text(
              'About Doctor',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Text(
              doctor.aboutDoctor,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              softWrap: true,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}


class DoctorInfo extends StatelessWidget {
  final Doctor2 doctor;

  const DoctorInfo({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  <Widget>[
        InfoCard(
          label: 'Patients',
          value: doctor.numAppointments,
        ),
        SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Experiences',
          value: doctor.Experience+' years',
        ),
        SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Rating',
          value: '4.5',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const InfoCard({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
