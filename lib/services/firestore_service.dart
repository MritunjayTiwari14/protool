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

  // 1. Add Task (Create)
  Future<void> addTask(Task task) async {
    await _tasksCollection.add(task.toMap());
  }

  // 2. Get Tasks (Read - Stream for real-time updates)
  Stream<List<Task>> getTasks() {
    return _tasksCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList());
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
