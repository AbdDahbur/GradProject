import 'package:flutter/material.dart';

class AppointmentCarde extends StatelessWidget {
  final String appointmentDate;
  final String appointmentTime;
  final String UserName;
  final String AppointmentID;

  final Function() onApprove;
  final Function() onDecline;

  AppointmentCarde({
    required this.appointmentDate,
    required this.appointmentTime,
    required this.UserName,
    required this.AppointmentID,
    required this.onApprove,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text('Date: $appointmentDate'),
        subtitle: Text('Time: $appointmentTime\nPatient Name: $UserName\nAppointment ID:$AppointmentID '),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check_circle, color: Colors.green),
              onPressed: onApprove,
            ),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: onDecline,
            ),
          ],
        ),
      ),
    );
  }
}
