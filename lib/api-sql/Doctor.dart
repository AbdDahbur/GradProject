
class Doctor {
  final String DoctorID;
  final String doctorName;
  final String Specialization;
  final String Experience;
  final String HospitalAffiliation;
  final String Education;
  final String aboutDoctor;
  final String photoPath;

  Doctor({
    required this.DoctorID,
    required this.doctorName,
    required this.Specialization,
    required this.Experience,
    required this.HospitalAffiliation,
    required this.Education,
    required this.aboutDoctor,
    required this.photoPath,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      DoctorID: json['DoctorID'],
      doctorName: json['doctorName'],
      Specialization: json['Specialization'],
      Experience: json['Experience'],
      HospitalAffiliation: json['HospitalAffiliation'],
      Education: json['Education'],
      aboutDoctor: json['aboutDoctor'],
      photoPath: json['photoPath'],
    );
  }
}
