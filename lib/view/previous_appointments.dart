import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/constant_widgets.dart';
import '../constants/str_constants.dart';
import '../model/appointment.dart';
import '../state_management/previous_appointments_provider.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<PreviousAppointmentsProvider>(context, listen: false)
            .createPreviousAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Appointment> previousAppointmentList = AppointmentsDB.appointmentObj.getPreviousAppointmentList;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<PreviousAppointmentsProvider>(builder: (context, value, child){
        if(value.arePreviousAppointmentsLoading){
          return const Center(child: CircularProgressIndicator(),);
        }

        if(appointmentBox.isEmpty || value.previousAppointmentsList.isEmpty) {
          return const Center(
            child: Text(
                StrConstants.noPreviousAppointments
            ),
          );
        }

        return getAppointmentsListView(appointmentsList: value.previousAppointmentsList, typeOfAppointment: 0);
      },),
    );
  }
}
