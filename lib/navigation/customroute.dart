import '../view/all_appointments.dart';
import '../view/home_page.dart';
import '../view/new_appointment.dart';
import 'package:flutter/material.dart';

import '../constants/nav_constants.dart';
import '../constants/str_constants.dart';

class CustomRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavConstants.homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case NavConstants.newAppointment:
        return MaterialPageRoute(builder: (_) => const NewAppointment());

      case NavConstants.allAppointments:
        return MaterialPageRoute(builder: (_) => AllAppointments());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text(StrConstants.error),
            ),
            body: const Text(StrConstants.error),
          ),
        );
    }
  }
}
