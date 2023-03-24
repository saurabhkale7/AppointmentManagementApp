import 'package:flutter/material.dart';

import 'next_appointments.dart';
import 'previous_appointments.dart';
import 'upcoming_appointments.dart';
import '../constants/constant_widgets.dart';
import '../constants/font_constants.dart';
import '../constants/str_constants.dart';
import '../model/database.dart';

class AllAppointments extends StatelessWidget {
  AllAppointments({Key? key}) : super(key: key);

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    AppointmentsDB.appointmentObj.createAppointmentsList();

    return SafeArea(
      child: DecoratedBox(
        decoration: bgDecoration,
        child: DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(StrConstants.appointments, style: TextStyle(fontFamily: FontConstants.junge, fontSize: 28, fontWeight: FontWeight.bold,),),
              bottom: const TabBar(
                isScrollable: true,
                labelStyle: TextStyle(fontFamily: FontConstants.raleway, fontSize: 19,),
                tabs: [
                  Tab(
                    icon: Icon(Icons.format_align_left_rounded, ),
                    text: StrConstants.previous,
                  ),
                  Tab(
                    icon: Icon(Icons.format_align_center_rounded),
                    text: StrConstants.upcoming,
                  ),
                  Tab(
                    icon: Icon(Icons.format_align_right_outlined),
                    text: StrConstants.next,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.03, size.height * 0.05, size.width * 0.03, 0),
              child: const TabBarView(
                children: [
                  PreviousAppointments(),
                  UpcomingAppointments(),
                  NextAppointments(),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//ChangeNotifierProvider(
//                     create: (context) => PreviousAppointmentsProvider(),
//                     builder: (context, child){
//                       return const PreviousAppointments();
//                     },
//                   ),
//                   ChangeNotifierProvider(
//                     create: (context) => UpcomingAppointmentsProvider(),
//                     builder: (context, child){
//                       return const UpcomingAppointments();
//                     },
//                   ),
//                   ChangeNotifierProvider(
//                     create: (context) => NextAppointmentsProvider(),
//                     builder: (context, child){
//                       return const NextAppointments();
//                     },
//                   ),
