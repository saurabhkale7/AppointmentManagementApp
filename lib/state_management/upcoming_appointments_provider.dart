import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/str_constants.dart';
import '../model/appointment.dart';
import '../model/database.dart';

class UpcomingAppointmentsProvider extends ChangeNotifier{
  bool areUpcomingAppointmentsLoading=true;
  List<Appointment> upcomingAppointmentsList = [];

  final Box appointmentBox =
  Hive.box<Appointment>(StrConstants.appointments.toLowerCase());

  void createUpcomingAppointments() {
    upcomingAppointmentsList = [];

    areUpcomingAppointmentsLoading=true;
    notifyListeners();

    for (int index = 0; index < appointmentBox.length; index++) {
      Appointment appointment = appointmentBox.getAt(index);

      //check whether appointment date is in between datetime.now and 2 days after datetime.now
      bool isUpcomingAppointment =
      DateTime.now().compareTo(appointment.dateAndTime) <= 0 &&
          DateTime.now()
              .add(const Duration(days: 2))
              .compareTo(appointment.dateAndTime) >=
              0
          ? true
          : false;

      if (isUpcomingAppointment) {
        // debugPrint("${appointment.name} - ${appointment.dateAndTime.toString()}");
        upcomingAppointmentsList.add(appointment);
        // debugPrint("hello");
      }
    }

    upcomingAppointmentsList=upcomingAppointmentsList.reversed.toList();

    areUpcomingAppointmentsLoading=false;
    notifyListeners();
  }

  void deleteUpcomingAppointment(Appointment appointment){
    AppointmentsDB.appointmentObj.deleteAppointmentAt(appointment.dateAndTime);
    createUpcomingAppointments();
  }
}