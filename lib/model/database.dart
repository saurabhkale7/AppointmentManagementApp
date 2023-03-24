import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../state_management/next_appointments_provider.dart';
import '../state_management/upcoming_appointments_provider.dart';
import '../constants/str_constants.dart';
import 'appointment.dart';

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

  void deleteAppointmentAt(DateTime appointmentDateTime) {
    for (int index = 0; index < appointmentBox.length; index++) {
      Appointment dbAppointment = appointmentBox.getAt(index);

      if (appointmentDateTime.compareTo(dbAppointment.dateAndTime) == 0) {
        appointmentBox.deleteAt(index);
        break;
      }
    }
  }

  void updateAppointmentAtWithNewData({required BuildContext context, required DateTime previousDateTime, required Appointment updatedAppointmentData, required bool isUpcomingAppointment}){
    bool willBecomeUpcomingAppointment = DateTime.now().add(const Duration(days: 2)).compareTo(updatedAppointmentData.dateAndTime)>=0?true:false;

    for (int index = 0; index < appointmentBox.length; index++) {
      Appointment dbAppointment = appointmentBox.getAt(index);

      if (previousDateTime.compareTo(dbAppointment.dateAndTime) == 0) {
        appointmentBox.putAt(index, updatedAppointmentData);

        if(isUpcomingAppointment){
          // debugPrint("in isUpcomingAppointment");
          Provider.of<UpcomingAppointmentsProvider>(context, listen: false).createUpcomingAppointments();
          // debugPrint("in isUpcomingAppointment after provider");
          if(!willBecomeUpcomingAppointment){
            // debugPrint("in !willBecomeUpcomingAppointment");
            Provider.of<NextAppointmentsProvider>(context, listen: false).createNextAppointments();
            // debugPrint("in !willBecomeUpcomingAppointment after provider");
          }
        }
        else{
          // debugPrint("in else");
          Provider.of<NextAppointmentsProvider>(context, listen: false).createNextAppointments();
          // debugPrint("in else after provider");
          if(willBecomeUpcomingAppointment){
            // debugPrint("in willBecomeUpcomingAppointment");
            Provider.of<UpcomingAppointmentsProvider>(context, listen: false).createUpcomingAppointments();
            // debugPrint("in willBecomeUpcomingAppointment after provider");
          }
        }

        break;
      }
    }
  }
}
