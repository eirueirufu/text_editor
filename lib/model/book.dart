import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book {
  Book({
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.ops,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime updatedAt;

  @HiveField(3, defaultValue: [])
  List<dynamic> ops;
}
