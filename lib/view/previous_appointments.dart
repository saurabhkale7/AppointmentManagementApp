import '../constants/constant_widgets.dart';
import '../model/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../constants/str_constants.dart';
import '../model/appointment.dart';

class PreviousAppointments extends StatefulWidget {
  const PreviousAppointments({Key? key}) : super(key: key);

  @override
  State<PreviousAppointments> createState() => _PreviousAppointmentsState();
}

class _PreviousAppointmentsState extends State<PreviousAppointments> {

  late final Box appointmentBox;

  @override
  void initState() {
    super.initState();

    appointmentBox = Hive.box<Appointment>(StrConstants.appointments.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    List<Appointment> previousAppointmentList = AppointmentsDB.appointmentObj.getPreviousAppointmentList;

    if(appointmentBox.isEmpty || previousAppointmentList.isEmpty) {
      return const Center(
        child: Text(
          StrConstants.noPreviousAppointments
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: getAppointmentsListView(appointmentsList: previousAppointmentList, typeOfAppointment: 0,),
    );
  }
}
