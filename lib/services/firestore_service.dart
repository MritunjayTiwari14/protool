import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get a reference to the current user's tasks collection
  CollectionReference get _tasksCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return _db.collection('users').doc(userId).collection('tasks');
  }

  DocumentReference get _userDoc {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return _db.collection('users').doc(userId);
  }

  // Get user settings
  Future<Map<String, dynamic>> getUserSettings() async {
    final doc = await _userDoc.get();
    if (doc.exists && doc.data() != null) {
      return doc.data() as Map<String, dynamic>;
    }
    return {};
  }

  // Update user settings
  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    await _userDoc.set(settings, SetOptions(merge: true));
  }

  // 1. Add Task (Create)
  Future<void> addTask(Task task) async {
    await _tasksCollection.add(task.toMap());
  }

  // 2. Get Tasks (Read - Stream for real-time updates)
  Stream<List<Task>> getTasks() {
    return _tasksCollection
        .snapshots()
        .map((snapshot) {
          final tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
          tasks.sort((a, b) => b.position.compareTo(a.position)); // Descending: newest/highest at the top
          return tasks;
        });
  }

  // Update task position for reordering
  Future<void> updateTaskPosition(String taskId, double newPosition) async {
    await _tasksCollection.doc(taskId).update({'position': newPosition});
  }

  // Get single task by ID
  Future<Task?> getTaskById(String taskId) async {
    final doc = await _tasksCollection.doc(taskId).get();
    if (doc.exists) {
      return Task.fromFirestore(doc);
    }
    return null;
  }

  // 3. Update Task (Edit)
  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  // 4. Delete Task
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  // Mark task as completed/uncompleted
  Future<void> toggleTaskStatus(String taskId, bool currentStatus) async {
    await _tasksCollection.doc(taskId).update({'isCompleted': !currentStatus});
  }
}
