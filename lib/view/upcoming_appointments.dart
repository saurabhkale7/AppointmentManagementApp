import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../state_management/upcoming_appointments_provider.dart';
import '../constants/constant_widgets.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UpcomingAppointmentsProvider>(context, listen: false)
          .createUpcomingAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Appointment> upcomingAppointmentList = AppointmentsDB.appointmentObj.getUpcomingAppointmentList;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<UpcomingAppointmentsProvider>(builder: (context, value, child){
        if(value.areUpcomingAppointmentsLoading){
          return const Center(child: CircularProgressIndicator(),);
        }

        if(appointmentBox.isEmpty || value.upcomingAppointmentsList.isEmpty) {
          return const Center(
            child: Text(
                StrConstants.noUpcomingAppointments
            ),
          );
        }

        // debugPrint("before return");
        return getAppointmentsListView(appointmentsList: value.upcomingAppointmentsList, typeOfAppointment: 1);
      },),
    );
  }
}
