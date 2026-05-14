import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted; // Represents the status
  final double position; // Used for drag and drop reordering

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
    this.position = 0.0,
  });

  // Convert a Task into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'isCompleted': isCompleted,
      'position': position,
    };
  }

  // Create a Task from a Firestore Document
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
      position: (data['position'] as num?)?.toDouble() ?? 
                ((data['date'] as Timestamp?)?.toDate().millisecondsSinceEpoch.toDouble() ?? 0.0),
    );
  }
}
