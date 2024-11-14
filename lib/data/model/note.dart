import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  final String title;
  
  @HiveField(1)
  final String description;
  
  @HiveField(2)
  final DateTime addedDate;
  
  @HiveField(3)
  DateTime dueDate;

  // Constructor with optional dueDate; defaults to 3 days after addedDate if not provided
  Note({
    required this.title,
    required this.description,
    required this.addedDate,
    DateTime? dueDate,
  }) : dueDate = dueDate ?? addedDate.add(Duration(days: 3));

  // Convert a Note object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'addedDate': addedDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
    };
  }

  // Create a Note object from a JSON map
  factory Note.fromJson(Map<String, dynamic> json) {
    DateTime parseOrDefault(String? dateStr, DateTime defaultDate) {
      return dateStr != null ? DateTime.parse(dateStr) : defaultDate;
    }

    final addedDate = parseOrDefault(json['addedDate'] as String?, DateTime.now());
    final dueDate = json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : addedDate.add(Duration(days: 3));
    
    return Note(
      title: json['title'] as String,
      description: json['description'] as String,
      addedDate: addedDate,
      dueDate: dueDate,
    );
  }

  // Convert a Note object to a Map (for Firebase)
  Map<String, dynamic> toMap() => toJson();

  // Create a Note object from a Map (for Firebase retrieval)
  factory Note.fromMap(Map<String, dynamic> map) => Note.fromJson(map);
}
