import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 4)
class InstanceInfo {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String url;
  @HiveField(2)
  final String name;

  InstanceInfo({
    required this.id,
    this.url = "",
    this.name = "",
  });

  InstanceInfo copyWith({
    String? url,
    String? name,
  }) {
    return InstanceInfo(
      id: this.id,
      url: url ?? this.url,
      name: name ?? this.name,
    );
  }
}
