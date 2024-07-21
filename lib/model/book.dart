import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book {
  Book({
    required this.name,
    required this.updatedAt,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime updatedAt;

  @HiveField(2, defaultValue: [])
  List<int> state = [];
}
