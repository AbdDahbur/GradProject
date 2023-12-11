
class TodayAppoin {
  final String AppointmentID;
  final String AppointmentDate;
  final String appointmentTime;
  final String doctorName;
  final String DoctorID;
  final String Specialization;
  final String photoPath;

  TodayAppoin({
    required this.AppointmentID,
    required this.AppointmentDate,
    required this.appointmentTime,
    required this.doctorName,
    required this.DoctorID,
    required this.Specialization,
    required this.photoPath,
  });

  factory TodayAppoin.fromJson(Map<String, dynamic> json) {
    return TodayAppoin(
      AppointmentID: json['AppointmentID'],
      AppointmentDate: json['AppointmentDate'],
      appointmentTime: json['appointmentTime'],
      doctorName: json['doctorName'],
      DoctorID: json['DoctorID'],
      Specialization: json['Specialization'],
      photoPath: json['photoPath'],
    );
  }
}

