import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../state_management/next_appointments_provider.dart';
import '../constants/constant_widgets.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<NextAppointmentsProvider>(context, listen: false)
          .createNextAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Appointment> nextAppointmentList = AppointmentsDB.appointmentObj.getNextAppointmentList;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<NextAppointmentsProvider>(builder: (context, value, child){
        if(value.areNextAppointmentsLoading){
          return const Center(child: CircularProgressIndicator(),);
        }

        if(appointmentBox.isEmpty || value.nextAppointmentsList.isEmpty) {
          return const Center(
            child: Text(
                StrConstants.noNextAppointments
            ),
          );
        }

        return getAppointmentsListView(appointmentsList: value.nextAppointmentsList, typeOfAppointment: 2);
      },),
    );
  }
}
