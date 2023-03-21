import 'package:hive/hive.dart';
part 'appointment.g.dart';

@HiveType(typeId: 1)
class Appointment {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final DateTime dateAndTime;

  @HiveField(3)
  final String description;

  Appointment({
    required this.name,
    required this.email,
    required this.dateAndTime,
    required this.description
  });
}