import '../constants/constant_widgets.dart';
import '../model/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../constants/str_constants.dart';
import '../model/appointment.dart';

class NextAppointments extends StatefulWidget {
  const NextAppointments({Key? key}) : super(key: key);

  @override
  State<NextAppointments> createState() => _NextAppointmentsState();
}

class _NextAppointmentsState extends State<NextAppointments> {

  late final Box appointmentBox;

  @override
  void initState() {
    super.initState();

    appointmentBox = Hive.box<Appointment>(StrConstants.appointments.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    List<Appointment> nextAppointmentList = AppointmentsDB.appointmentObj.getNextAppointmentList;

    if(appointmentBox.isEmpty || nextAppointmentList.isEmpty) {
      return const Center(
        child: Text(
          StrConstants.noNextAppointments
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: getAppointmentsListView(appointmentsList: nextAppointmentList, typeOfAppointment: 2,),
    );
  }
}
