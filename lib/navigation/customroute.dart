import 'package:flutter/material.dart';

import '../model/appointment.dart';
import '../view/all_appointments.dart';
import '../view/home_page.dart';
import '../view/new_appointment.dart';
import '../constants/nav_constants.dart';
import '../constants/str_constants.dart';

MaterialPageRoute<dynamic> errorRoute(){
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(
        title: const Text(StrConstants.error),
      ),
      body: const Text(StrConstants.error),
    ),
  );
}

class CustomRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavConstants.homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case NavConstants.allAppointments:
        return MaterialPageRoute(builder: (_) => AllAppointments());
      // case NavConstants.allAppointments:
      //   return MaterialPageRoute(builder: (_) => MultiProvider(
      //     providers: [
      //       ChangeNotifierProvider(
      //           create: (context) => PreviousAppointmentsProvider()),
      //       ChangeNotifierProvider(
      //           create: (context) => UpcomingAppointmentsProvider()),
      //       ChangeNotifierProvider(
      //           create: (context) => NextAppointmentsProvider()),
      //     ],
      //     child: AllAppointments(),
      //   ));


      case NavConstants.newAppointment:
        if(settings.arguments==null) {
          return MaterialPageRoute(builder: (_) => const NewAppointment(appointment: null, isUpcomingAppointment: null));
        }

        // debugPrint(settings.arguments.runtimeType.toString());
        if(settings.arguments is Map<String, dynamic>) {
          // debugPrint("hi");
          Map<String, dynamic> args =
          settings.arguments as Map<String, dynamic>;

          if (args[StrConstants.appointment].runtimeType == Appointment) {
            // debugPrint("hello");
            if (args[StrConstants.upcoming].runtimeType == bool) {
              // debugPrint("bye");

              // return MaterialPageRoute(builder: (_) => MultiProvider(
              //   providers: [
              //     ChangeNotifierProvider(
              //         create: (context) => PreviousAppointmentsProvider()),
              //     ChangeNotifierProvider(
              //         create: (context) => UpcomingAppointmentsProvider()),
              //     ChangeNotifierProvider(
              //         create: (context) => NextAppointmentsProvider()),
              //   ],
              //   builder: (_, __) => NewAppointment(
              //     appointment:
              //     args[StrConstants.appointment] as Appointment,
              //     isUpcomingAppointment:
              //     args[StrConstants.upcoming] as bool,
              //   ),
              // ));

              return MaterialPageRoute(
                builder: (_) => NewAppointment(
                  appointment:
                  args[StrConstants.appointment] as Appointment,
                  isUpcomingAppointment:
                  args[StrConstants.upcoming] as bool,
                ),
              );
            }
          }
        }

        // debugPrint("ok bye");

        return errorRoute();

      default:
        return errorRoute();
    }
  }
}
