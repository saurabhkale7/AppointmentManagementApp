import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/str_constants.dart';
import '../model/appointment.dart';

class PreviousAppointmentsProvider extends ChangeNotifier{
  bool arePreviousAppointmentsLoading=true;
  List<Appointment> previousAppointmentsList = [];

  final Box appointmentBox =
  Hive.box<Appointment>(StrConstants.appointments.toLowerCase());

  void createPreviousAppointments() {
    previousAppointmentsList = [];

    arePreviousAppointmentsLoading=true;
    notifyListeners();

    for (int index = 0; index < appointmentBox.length; index++) {
      Appointment appointment = appointmentBox.getAt(index);

      //check whether appointment date is previous to datetime.now
      if (DateTime.now().compareTo(appointment.dateAndTime) >= 0) {
        previousAppointmentsList.add(appointment);
      }
    }

    previousAppointmentsList=previousAppointmentsList.reversed.toList();

    arePreviousAppointmentsLoading=false;
    notifyListeners();
  }
}