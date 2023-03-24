import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../state_management/next_appointments_provider.dart';
import '../state_management/upcoming_appointments_provider.dart';
import '../model/appointment.dart';
import 'nav_constants.dart';
import 'font_constants.dart';
import 'str_constants.dart';

BoxDecoration bgDecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.pinkAccent, Colors.purple],
  ),
);

RoundedRectangleBorder roundRectBorder40 = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(40),
  side: const BorderSide(
    color: Colors.transparent,
  ),
);

TextStyle commonTextStyle = const TextStyle(
    fontSize: 20,
    fontFamily: FontConstants.raleway,
    fontWeight: FontWeight.bold);

TextStyle newAppointmentTextStyle = const TextStyle(
    fontSize: 48,
    fontFamily: FontConstants.junge,
    fontWeight: FontWeight.bold,
    color: Colors.white);

SizedBox sizedBoxH10 = const SizedBox(
  height: 10,
);

SizedBox sizedBoxH20 = const SizedBox(
  height: 20,
);

SizedBox sizedBoxH100 = const SizedBox(
  height: 100,
);

SizedBox sizedBoxH190 = const SizedBox(
  height: 190,
);

TextStyle whiteColouredText = const TextStyle(color: Colors.white);

OutlineInputBorder whiteBorder20 = OutlineInputBorder(
  borderSide: const BorderSide(
    color: Colors.white,
  ),
  borderRadius: BorderRadius.circular(20.0),
);

OutlineInputBorder whiteBorder40 = OutlineInputBorder(
  borderSide: const BorderSide(
    color: Colors.white,
  ),
  borderRadius: BorderRadius.circular(40.0),
);

InputDecoration getInputDecoration(String label, String hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: whiteColouredText,
    labelStyle: whiteColouredText,
    errorStyle: whiteColouredText,
    enabledBorder: whiteBorder20,
    focusedBorder: whiteBorder40,
    errorBorder: whiteBorder20,
    focusedErrorBorder: whiteBorder40,
  );
}

TextStyle alertTitleStyle = const TextStyle(
  fontSize: 32,
  fontFamily: FontConstants.raleway,
);

TextStyle alertContentStyle =
    const TextStyle(fontFamily: FontConstants.junge, fontSize: 20);

TextStyle addAppointmentBtnStyle = const TextStyle(
    fontFamily: FontConstants.raleway,
    fontSize: 22,
    fontWeight: FontWeight.bold);

Future<void> openDialog(
    BuildContext context, String title, String content) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: alertTitleStyle,
          ),
          content: Text(
            content,
            style: alertContentStyle,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(StrConstants.ok)),
          ],
        );
      });
}

RoundedRectangleBorder roundRectBorder20 = RoundedRectangleBorder(
  side: const BorderSide(color: Colors.transparent, width: 5),
  borderRadius: BorderRadius.circular(20),
);

BoxDecoration commonBoxDecoration = BoxDecoration(
  border: Border.all(color: Colors.transparent, width: 5),
  borderRadius: BorderRadius.circular(20),
  gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
);

TextStyle listTileTitleStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    fontFamily: FontConstants.raleway);

EdgeInsetsGeometry listTileSubtitlePadding =
    const EdgeInsets.only(top: 10, left: 10);

EdgeInsetsGeometry listTileTitlePadding = const EdgeInsets.only(left: 10);

Icon upcomingAppointmentCircleIcon = const Icon(
  Icons.circle_rounded,
  color: Colors.blue,
);

String getDateFormat(DateTime dateAndTime) {
  return DateFormat(StrConstants.dateFormat).format(dateAndTime);
}

EdgeInsetsGeometry commonListViewPadding = const EdgeInsets.only(bottom: 10);

BoxDecoration listTileDecoration(int typeOfAppointment) => BoxDecoration(
      border: Border.all(color: Colors.transparent, width: 5),
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(colors: [
        Colors.white,
        typeOfAppointment == 0
            ? Colors.grey
            : (typeOfAppointment == 2 ? Colors.blue : Colors.white)
      ]),
    );

///[getAppointmentsListView].
/// ListView function(List<Appointment>, int).
/// This function accepts 2 arguments.
/// First one is appointmentsList which accepts list of appointments.
/// Second one is typeOfAppointment.
/// Different kind of background color gradient is given to each tile containing an appointment based on typeOfAppointment argument.
/// Pass 0 if typeOfAppointment is previous.
/// Pass 1 if typeOfAppointment is upcoming.
/// Pass 2 if typeOfAppointment is next.

ListView getAppointmentsListView(
    {required List<Appointment> appointmentsList,
    required int typeOfAppointment}) {
  bool wantToDeleteAnAppointment = false;

  return ListView.builder(
      shrinkWrap: true,
      itemCount: appointmentsList.length,
      itemBuilder: (BuildContext context, int index) {
        Appointment appointment = appointmentsList[index];

        return Padding(
            padding: commonListViewPadding,
            child: DecoratedBox(
              decoration: listTileDecoration(typeOfAppointment),
              child: ListTile(
                title: Padding(
                  padding: listTileTitlePadding,
                  child: Text(
                    appointment.name,
                    style: listTileTitleStyle,
                  ),
                ),
                subtitle: Padding(
                  padding: listTileSubtitlePadding,
                  child: Text(getDateFormat(appointment.dateAndTime)),
                ),
                textColor: Colors.black,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: typeOfAppointment == 0
                            ? null
                            : () {
                                Navigator.of(context).pushNamed(
                                    NavConstants.newAppointment,
                                    arguments: {
                                      StrConstants.appointment: appointment,
                                      StrConstants.upcoming:
                                          typeOfAppointment == 1 ? true : false
                                    });
                              },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: typeOfAppointment == 0
                              ? Colors.grey
                              : Colors.black,
                        )),
                    IconButton(
                        onPressed: typeOfAppointment == 0
                            ? null
                            : () async {
                                await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          StrConstants.warning,
                                          style: alertTitleStyle,
                                        ),
                                        content: Text(
                                          StrConstants.confirmDelete,
                                          style: alertContentStyle,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(StrConstants.no),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (typeOfAppointment == 1 ||
                                                  typeOfAppointment == 2) {
                                                wantToDeleteAnAppointment =
                                                    true;
                                              }
                                              Navigator.of(context).pop();
                                              // Navigator.pushReplacementNamed(context, NavConstants.allAppointments);
                                            },
                                            child: const Text(StrConstants.yes),
                                          ),
                                        ],
                                      );
                                    });
                                // debugPrint("hello");
                                if (wantToDeleteAnAppointment) {
                                  if (typeOfAppointment == 1) {
                                    () {
                                      Provider.of<UpcomingAppointmentsProvider>(
                                              context,
                                              listen: false)
                                          .deleteUpcomingAppointment(
                                              appointment);
                                    }();
                                  } else if (typeOfAppointment == 2) {
                                    () {
                                      Provider.of<NextAppointmentsProvider>(
                                              context,
                                              listen: false)
                                          .deleteNextAppointment(appointment);
                                    }();
                                  }
                                  wantToDeleteAnAppointment = false;
                                }
                              },
                        icon: Icon(
                          Icons.delete_outline,
                          color:
                              typeOfAppointment == 0 ? Colors.grey : Colors.red,
                        )),
                  ],
                ),
              ),
            ));
      });
}
