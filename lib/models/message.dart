import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  final DateTime time;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final MessageType type;

  Message({
    required this.time,
    required this.message,
    this.type = MessageType.data,
  });

  @override
  String toString() {
    return message;
  }
}

@HiveType(typeId: 3)
enum MessageType {
  @HiveField(0)
  data,
  @HiveField(1)
  error,
  @HiveField(2)
  done,
}
