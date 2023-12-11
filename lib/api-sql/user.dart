class User{
  int userId;
  String userName ;
  String userPassword ;
  String userEmail ;
  String dateOfBirth ;
  String address;
  String phoneNumber ;
  String roleId;

  User(
      this.userId,
      this.userName,
      this.userPassword,
      this.userEmail,
      this.dateOfBirth,
      this.address,
      this.phoneNumber,
      this.roleId


      );

  factory User.fromJson(Map<String,dynamic> json) => User(
    int.parse(json["UserID"]) ,
    json["Username"],
    json["Password"],
    json["Email"],
    json["DateOfBirth"],
    json["Address"],
    json["PhoneNumber"],
    json["roleId"],
  );
  Map<String, dynamic> toJson() =>{
    'UserID': userId.toString(),
    'Username':userName,
    'Password': userPassword,
    'Email' : userEmail,
    'DateOfBirth' : dateOfBirth,
    'Address' : address,
    'PhoneNumber' : phoneNumber,
    'roleId' : roleId
  };

}