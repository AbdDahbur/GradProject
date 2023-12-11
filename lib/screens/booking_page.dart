import 'dart:convert';

import 'package:appointmentapp/components/button.dart';
import 'package:appointmentapp/components/custom_appbar.dart';
import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../api-sql/apiCon.dart';
import '../api-sql/user.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class BookinkPage extends StatefulWidget {
  final String docId;
  final User user;

  const BookinkPage({
    Key? key,
    required this.docId,
    required this.user,
  }) : super(key: key);
  @override
  State<BookinkPage> createState() => _BookinkPageState();
}

class _BookinkPageState extends State<BookinkPage> {
  //declartion
  CalendarFormat _format = CalendarFormat.month;

  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  Future<void> insertAppointment() async {

    String formattedDate = DateFormat('yyyy-MM-dd').format(_currentDay);

    try {
      var res = await http.post(
        Uri.parse('${API.newappointment}'),
        body: {
          'userId': widget.user.userId.toString(),
          'doctorId': widget.docId.toString(),
          'selectedDate': formattedDate,
          'selectedTime': (_currentIndex! + 9).toString()+':00:00',
        },
      );
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          print('formattedDate');
          // Appointment inserted successfully
          Navigator.of(context).pushNamed('success_booking');
        } else {
          // Failed to insert appointment, display error message
          Fluttertoast.showToast(
            msg: resBody['message'],
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else {
        // Failed to insert appointment due to server error
        Fluttertoast.showToast(
          msg: 'Failed to insert appointment. Please try again.',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {

      print(e.toString());
      // Error occurred while making the request
      Fluttertoast.showToast(
        msg: 'Failed to insert appointment. Please try again.',
        toastLength: Toast.LENGTH_LONG,

      );
    }
  }


  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: CustomAppBar(
        appTitile: 'Appointment',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                // display table calemdar here
                _tableCalender(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  child: Center(
                    child: Text(
                      'select Consultation Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isWeekend? SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal:10 ,vertical: 30),
              alignment: Alignment.center,
              child: const Text(
                'Weekend is Not available , please select another date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ): SliverGrid(
            delegate: SliverChildBuilderDelegate((context,index){
            return InkWell(
              splashColor: Colors.black,
              onTap: () {
                setState(() {
                  //when select , update current index and set time set time selected to true
                  _currentIndex=index;
                  _timeSelected=true;
                });

              },
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _currentIndex ==index
                      ? Colors.white
                      :Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: _currentIndex== index
                    ?Config.primaryColor
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index +9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                  style: TextStyle(
                    fontWeight:  FontWeight.bold,
                    color: _currentIndex==index ? Colors.white :null,
                  ),

                ),
              ),
            );
          },
              childCount: 8,
          ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                childAspectRatio: 1.5,
              ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 1),
              child: Button(

                width: double.infinity,
                title: 'Make Appointment',
                onPressed: () {
                  insertAppointment();

                },
                disable: _timeSelected && _dateSelected? false:true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //table calendar
  Widget _tableCalender() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2023, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Config.primaryColor,
          shape: BoxShape.circle,
        ),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: (selectedDay, focusDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusDay;
          _dateSelected = true;
          //check if weekend is selected
          if (selectedDay.weekday == 5 || selectedDay.weekday == 6) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      },
    );
  }
}
