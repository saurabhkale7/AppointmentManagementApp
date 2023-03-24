import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../model/database.dart';
import '../constants/constant_widgets.dart';
import '../constants/str_constants.dart';
import '../model/appointment.dart';
import '../constants/font_constants.dart';

class NewAppointment extends StatefulWidget {
  const NewAppointment({Key? key, this.appointment, this.isUpcomingAppointment}) : super(key: key);
  final Appointment? appointment;
  final bool? isUpcomingAppointment;

  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  late Size size;
  int i = 0;

  //ValueNotifier<bool> dateTimeNotifier = ValueNotifier(false);
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController dateTimeCtrl;
  late final TextEditingController descCtrl;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  late final Box appointmentBox;

  final GlobalKey<FormState> appointmentFormKey = GlobalKey<FormState>();

// Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      selectedDate = selected;
    }
    return selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      selectedTime = selected;
    }
    return selectedTime;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime date = await _selectDate(context);
    // if (date == null) return;

    TimeOfDay time = await _selectTime(context);

    // if (time == null) return;

    dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  String getDateTime() {
    // ignore: unnecessary_null_comparison
    // if (dateTime == null) {
    //   return 'select date timer';
    // } else {
    return DateFormat(StrConstants.dateFormat).format(dateTime);
    // }
  }

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return StrConstants.emptyField;
    }
    return null;
  }

  void addAppointment() {
    Appointment appointment = Appointment(
        name: nameCtrl.text,
        email: emailCtrl.text,
        dateAndTime: dateTime,
        description: descCtrl.text);

    appointmentBox.add(appointment);

    // for (int i = 0; i < appointmentBox.length; i++) {
    //   var ap = appointmentBox.getAt(i)!;
    //   debugPrint(ap.name);
    //   debugPrint(ap.email);
    //   debugPrint(DateFormat(StrConstants.dateFormat).format(ap.dateAndTime));
    //   debugPrint(ap.description);
    // }
  }

  void updateAppointment(){
    Appointment appointment = Appointment(
        name: nameCtrl.text,
        email: emailCtrl.text,
        dateAndTime: dateTime,
        description: descCtrl.text);

    AppointmentsDB.appointmentObj.updateAppointmentAtWithNewData(context: context, previousDateTime: widget.appointment!.dateAndTime, updatedAppointmentData: appointment, isUpcomingAppointment: widget.isUpcomingAppointment!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    appointmentBox =
        Hive.box<Appointment>(StrConstants.appointments.toLowerCase());

    // widget.appointment==null?debugPrint("null"):debugPrint("not a null value");
    nameCtrl=TextEditingController(text: widget.appointment==null?"":widget.appointment!.name);
    emailCtrl=TextEditingController(text: widget.appointment==null?"":widget.appointment!.email);
    dateTimeCtrl=TextEditingController(text: widget.appointment==null?"":getDateFormat(widget.appointment!.dateAndTime));
    descCtrl=TextEditingController(text: widget.appointment==null?"":widget.appointment!.description);

    selectedDate=widget.appointment==null?selectedDate:widget.appointment!.dateAndTime;
    selectedTime=widget.appointment==null?selectedTime:TimeOfDay.fromDateTime(widget.appointment!.dateAndTime);
    dateTime=widget.appointment==null?dateTime:widget.appointment!.dateAndTime;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
      child: DecoratedBox(
        decoration: bgDecoration,
        child: Scaffold(
          //appBar: AppBar(title: a,),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.fromLTRB(size.width * 0.03, size.height * 0.02,
                size.width * 0.03, size.height * 0.05),
            child: SingleChildScrollView(
              primary: false,
              child: Form(
                key: appointmentFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      StrConstants.newAppointment,
                      style: TextStyle(
                          fontSize: 45,
                          fontFamily: FontConstants.junge,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 2,
                      color: Colors.cyan,
                    ),
                    sizedBoxH20,
                    TextFormField(
                      controller: nameCtrl,
                      validator: _fieldValidator,
                      style: whiteColouredText,
                      decoration: getInputDecoration(
                          StrConstants.name, StrConstants.enterName),
                    ),
                    sizedBoxH20,
                    TextFormField(
                      controller: emailCtrl,
                      validator: _fieldValidator,
                      style: whiteColouredText,
                      decoration: getInputDecoration(
                          StrConstants.email, StrConstants.enterEmail),
                    ),
                    sizedBoxH20,
                    TextFormField(
                      controller: dateTimeCtrl,
                      validator: _fieldValidator,
                      style: whiteColouredText,
                      readOnly: true,
                      decoration: getInputDecoration(
                          StrConstants.date, StrConstants.enterDate),
                      onTap: () async {
                        await _selectDateTime(context);
                        dateTimeCtrl.text = getDateTime();
                      },
                    ),
                    sizedBoxH20,
                    TextFormField(
                      controller: descCtrl,
                      validator: _fieldValidator,
                      style: whiteColouredText,
                      // readOnly: true,
                      decoration: getInputDecoration(
                          StrConstants.desc, StrConstants.enterDesc),
                    ),
                    sizedBoxH20,
                    // Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                          ),
                          child: Text(
                            StrConstants.back,
                            style: addAppointmentBtnStyle,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (appointmentFormKey.currentState!.validate()) {
                              if (dateTime.compareTo(DateTime.now()) <= 0) {
                                openDialog(context, StrConstants.warning,
                                    StrConstants.invalidAppointmentTime);
                                return;
                              }

                              Appointment appointment;
                              for (int i = 0; i < appointmentBox.length; i++) {
                                appointment = appointmentBox.getAt(i);

                                if (dateTime.compareTo(appointment.dateAndTime) ==
                                    0) {
                                  openDialog(context, StrConstants.warning,
                                      StrConstants.appointmentAlreadyBooked);
                                  return;
                                }
                              }

                              if(widget.appointment==null) {
                                addAppointment();
                              } else{
                                updateAppointment();
                              }

                              Navigator.of(context).pop();
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            widget.appointment==null?StrConstants.add:StrConstants.update,
                            style: addAppointmentBtnStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // floatingActionButton: ElevatedButton(
          //   onPressed: () {  },
          //   child: const Text(StrConstants.add),
          // ),
        ),
      ),
    );
  }
}
