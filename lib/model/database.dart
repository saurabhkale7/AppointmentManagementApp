import '../constants/str_constants.dart';
import 'appointment.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppointmentsDB {
  static AppointmentsDB appointmentObj = AppointmentsDB();

  final Box appointmentBox =
      Hive.box<Appointment>(StrConstants.appointments.toLowerCase());

  List<Appointment> previousAppointmentList = [];
  List<Appointment> upcomingAppointmentList = [];
  List<Appointment> nextAppointmentList = [];

  List<Appointment> get getPreviousAppointmentList =>
      previousAppointmentList.reversed.toList();

  List<Appointment> get getUpcomingAppointmentList =>
      upcomingAppointmentList.reversed.toList();

  List<Appointment> get getNextAppointmentList =>
      nextAppointmentList.reversed.toList();

  // List<Appointment> get getPreviousAppointmentList{
  //   return previousAppointmentList;
  // }

  // void createAppointment(Map<String, String> appointment){
  //   appointmentBox.put(appointment[StrConstants.email], appointment);
  // }

  void createAppointmentsList() {
    DateTime now = DateTime.now();
    previousAppointmentList = [];
    upcomingAppointmentList = [];
    nextAppointmentList = [];

    //check each appointment in appointment box
    for (int index = 0; index < appointmentBox.length; index++) {
      Appointment appointment = appointmentBox.getAt(index);

      //check whether appointment date is previous to datetime.now
      if (now.compareTo(appointment.dateAndTime) >= 0) {
        previousAppointmentList.add(appointment);
      } else {
        //check whether appointment date is in between datetime.now and 2 days after datetime.now
        bool isUpcomingAppointment =
            DateTime.now().compareTo(appointment.dateAndTime) <= 0 &&
                    DateTime.now()
                            .add(const Duration(days: 2))
                            .compareTo(appointment.dateAndTime) >=
                        0
                ? true
                : false;

        // DateTime.now().compareTo(appointment.dateAndTime)<=0 && DateTime(now.year, now.month, now.day, 23, 59).compareTo(appointment.dateAndTime)>=0

        //if yes
        if (isUpcomingAppointment) {
          upcomingAppointmentList.add(appointment);
        }
        //if no means appointment is scheduled after 2 days of datetime.now
        else {
          nextAppointmentList.add(appointment);
        }
      }
    }
  }
}
