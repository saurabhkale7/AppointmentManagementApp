import 'constants/nav_constants.dart';
import 'model/appointment.dart';
import 'navigation/customroute.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants/str_constants.dart';

void main() async {
  // Initialize hive
  await Hive.initFlutter();

  //await Hive.deleteBoxFromDisk(StrConstants.appointments.toLowerCase());

  // Registering the adapter
  Hive.registerAdapter(AppointmentAdapter());

  // Open the box
  await Hive.openBox<Appointment>(StrConstants.appointments.toLowerCase());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: StrConstants.appointments,
      debugShowCheckedModeBanner: false,
      initialRoute: NavConstants.homePage,
      onGenerateRoute: CustomRoute.generateRoute,
    );
  }
}