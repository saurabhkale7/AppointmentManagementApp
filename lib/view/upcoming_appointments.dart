import '../constants/constant_widgets.dart';

import '../model/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../constants/str_constants.dart';
import '../model/appointment.dart';

class UpcomingAppointments extends StatefulWidget {
  const UpcomingAppointments({Key? key}) : super(key: key);

  @override
  State<UpcomingAppointments> createState() => _UpcomingAppointmentsState();
}

class _UpcomingAppointmentsState extends State<UpcomingAppointments> {

  late final Box appointmentBox;

  @override
  void initState() {
    super.initState();

    appointmentBox = Hive.box<Appointment>(StrConstants.appointments.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    List<Appointment> upcomingAppointmentList = AppointmentsDB.appointmentObj.getUpcomingAppointmentList;

    if(appointmentBox.isEmpty || upcomingAppointmentList.isEmpty) {
      return const Center(
        child: Text(
          StrConstants.noUpcomingAppointments
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: getAppointmentsListView(appointmentsList: upcomingAppointmentList, typeOfAppointment: 1,),
    );
  }
}
