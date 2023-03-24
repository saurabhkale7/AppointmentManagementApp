import '../constants/constant_widgets.dart';
import '../constants/font_constants.dart';
import '../constants/nav_constants.dart';
import '../constants/str_constants.dart';
import '../model/appointment.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  late Size size;
  late final Box appointmentBox;


  ButtonStyle getElevatedButtonStyle() {
    return ElevatedButton.styleFrom(
        fixedSize: Size(size.width * 0.45, 100),
        shape: roundRectBorder40,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        elevation: 20);
  }

  @override
  void initState() {
    super.initState();

    appointmentBox = Hive.box<Appointment>(StrConstants.appointments.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
      child: DecoratedBox(
        decoration: bgDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.fromLTRB(size.width * 0.03, size.height * 0.02,
                size.width * 0.03, 0),// size.height * 0.05
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(NavConstants.newAppointment);
                      },
                      style: getElevatedButtonStyle(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.add_circle_rounded,
                              color: Colors.purple,
                              size: 40,
                            ),
                            Text(
                                StrConstants.newAppointment
                                    .split(StrConstants.space)[0],
                                style: commonTextStyle),
                            Text(
                                StrConstants.newAppointment
                                    .split(StrConstants.space)[1],
                                style: commonTextStyle),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.04,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(NavConstants.allAppointments);
                      },
                      style: getElevatedButtonStyle(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.upcoming_rounded,
                              color: Colors.purple,
                              size: 40,
                            ),
                            Text(
                                StrConstants.upcomingAppointments
                                    .split(StrConstants.space)[0],
                                style: commonTextStyle),
                            Text(
                                StrConstants.upcomingAppointments
                                    .split(StrConstants.space)[1],
                                style: commonTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                sizedBoxH20,
                sizedBoxH20,
                const Text(StrConstants.appointments, style: TextStyle(fontSize: 32, fontFamily: FontConstants.junge, fontWeight: FontWeight.bold, color: Colors.white),),
                const Divider(
                  height: 20,
                  thickness: 2,
                  color: Colors.lightBlueAccent,
                ),
                ValueListenableBuilder(
                  valueListenable: appointmentBox.listenable(),
                  builder: (BuildContext context, Box updatedAppointmentBox,
                      Widget? widget) {
                    if (updatedAppointmentBox.isEmpty) {
                      return const Center(child: Text(StrConstants.noAppointments, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, fontFamily: FontConstants.raleway),));
                    }

                    int appointmentBoxLength = updatedAppointmentBox.length;

                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: appointmentBoxLength,
                        itemBuilder: (BuildContext context, int index){
                          Appointment appointment = updatedAppointmentBox.getAt(appointmentBoxLength-index-1);
                          bool isUpcomingAppointment = DateTime.now().compareTo(appointment.dateAndTime)<=0 && DateTime.now().add(const Duration(days: 2)).compareTo(appointment.dateAndTime)>=0 ? true : false;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: DecoratedBox(
                              decoration: commonBoxDecoration,
                              child: ListTile(
                                title: Padding(
                                  padding: listTileTitlePadding,
                                  child: Text(appointment.name, style: listTileTitleStyle,),
                                ),
                                subtitle: Padding(
                                  padding: listTileSubtitlePadding,
                                  child: Text(getDateFormat(appointment.dateAndTime)),
                                ),
                                trailing: isUpcomingAppointment? upcomingAppointmentCircleIcon : const SizedBox(),
                                textColor: Colors.black,
                              ),
                            )
                          );
                        }
                      ),
                    );
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}