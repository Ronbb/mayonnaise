import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  final DateTime time;

  @HiveField(1)
  final String message;

  Message({
    required this.time,
    required this.message,
  });

  @override
  String toString() {
    return message;
  }
}
