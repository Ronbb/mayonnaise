import 'package:hive/hive.dart';

/// [DateTime] Adapter for hive.
class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final typeId = 2;

  @override
  DateTime read(BinaryReader reader) {
    return DateTime.fromMillisecondsSinceEpoch(reader.read());
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.write(obj.millisecondsSinceEpoch);
  }
}
