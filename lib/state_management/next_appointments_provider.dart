import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/str_constants.dart';
import '../model/appointment.dart';
import '../model/database.dart';

class NextAppointmentsProvider extends ChangeNotifier{
  bool areNextAppointmentsLoading=true;
  List<Appointment> nextAppointmentsList = [];

  final Box appointmentBox =
  Hive.box<Appointment>(StrConstants.appointments.toLowerCase());

  void createNextAppointments() {
    nextAppointmentsList = [];

    areNextAppointmentsLoading=true;
    notifyListeners();

    for (int index = 0; index < appointmentBox.length; index++) {
      Appointment appointment = appointmentBox.getAt(index);

      //check whether appointment date is 2 days after datetime.now
      bool isNextAppointment =
          DateTime.now()
              .add(const Duration(days: 2))
              .compareTo(appointment.dateAndTime) <
              0
          ? true
          : false;

      if (isNextAppointment) {
        nextAppointmentsList.add(appointment);
      }
    }

    nextAppointmentsList=nextAppointmentsList.reversed.toList();

    areNextAppointmentsLoading=false;
    notifyListeners();
  }

  void deleteNextAppointment(Appointment appointment){
    AppointmentsDB.appointmentObj.deleteAppointmentAt(appointment.dateAndTime);
    createNextAppointments();
  }
}