class API {
  static const hostConnect = "http://172.19.2.23:8086/graduation";
  static const hostConnectUser = "$hostConnect/user";
//signUp user
  static const validateEmail = "$hostConnect/user/validate_email.php";
  static const signUp = "$hostConnect/user/signup.php";
  static const login = "$hostConnect/user/login.php";
  static const today = "$hostConnect/user/appointmenttoday.php";
  static const status = "$hostConnect/user/setappointmentstatus.php";
  static const top = "$hostConnect/user/topdoctors.php";
  static const spec = "$hostConnect/user/specdoctors.php";
  static const doctor = "$hostConnect/user/getDoctor.php";
  static const upcoming = "$hostConnect/user/upcoming.php";
  static const finished = "$hostConnect/user/finished.php";
  static const canceled = "$hostConnect/user/canceled.php";
  static const newappointment = "$hostConnect/user/newappointment.php";
  static const signupdoctor = "$hostConnect/user/signupdoctor.php";
  static const doctorappointments = "$hostConnect/user/doctorappointments.php";

  //http://172.20.10.2:8085/graduation/user/doctorappointments.php?doctorId=14
}