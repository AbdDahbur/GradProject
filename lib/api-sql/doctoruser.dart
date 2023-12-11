class DoctorUser{
  int userId;
  String userName ;
  String userPassword ;
  String userEmail ;
  String dateOfBirth ;
  String address;
  String phoneNumber ;
  String Specialization ;
  String Experience ;
  String HospitalAffiliation ;
  String Education ;
  String aboutDoctor ;

  DoctorUser(
      this.userId,
      this.userName,
      this.userPassword,
      this.userEmail,
      this.dateOfBirth,
      this.address,
      this.phoneNumber ,
      this.Specialization ,
      this.Experience ,
      this.HospitalAffiliation ,
      this.Education ,
      this.aboutDoctor


      );

  factory DoctorUser.fromJson(Map<String,dynamic> json) => DoctorUser(
    int.parse(json["UserID"]) ,
    json["Username"],
    json["Password"],
    json["Email"],
    json["DateOfBirth"],
    json["Address"],
    json["PhoneNumber"],
    json["Specialization"],
    json["Experience"],
    json["HospitalAffiliation"],
    json["Education"],
    json["aboutDoctor"],
  );
  Map<String, dynamic> toJson() =>{
    'UserID': userId.toString(),
    'Username':userName,
    'Password': userPassword,
    'Email' : userEmail,
    'DateOfBirth' : dateOfBirth,
    'Address' : address,
    'PhoneNumber' : phoneNumber,
    'Specialization' : Specialization,
    'Experience' : Experience,
    'HospitalAffiliation' : HospitalAffiliation,
    'Education' : Education,
    'aboutDoctor' : aboutDoctor
  };

}