class Appointment {
  final String AppointmentID;
  final String userID;
  final String DoctorID;
  final String AppointmentDate;
  final String appointmentTime;
  final String Description;
  final String appointmentStatus;

  Appointment({
    required this.AppointmentID,
    required this.userID,
    required this.DoctorID,
    required this.AppointmentDate,
    required this.appointmentTime,
    required this.Description,
    required this.appointmentStatus,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      AppointmentID: json['AppointmentID'],
      userID: json['userID'],
      DoctorID: json['DoctorID'],
      AppointmentDate: json['AppointmentDate'],
      appointmentTime: json['appointmentTime'],
      Description: json['Description'],
      appointmentStatus: json['appointmentStatus'],
    );
  }
}
