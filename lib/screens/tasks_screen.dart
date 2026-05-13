import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class TasksScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Colors.white30,
            width: 0.5,
          ),
        ),
      ),
      body: StreamBuilder<List<Task>>(
        stream: _firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks yet.'));
          }

          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(task.description),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    _firestoreService.toggleTaskStatus(task.id, task.isCompleted);
                  },
                ),
                onLongPress: () => _firestoreService.deleteTask(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for adding a task
          _firestoreService.addTask(Task(
            id: '', // Firestore auto-generates ID on add when we use add() but our model takes an id.
            // Wait, our addTask uses `await _tasksCollection.add(task.toMap());` which generates the ID.
            // And toMap() doesn't include the id, so the dummy id here won't be saved, but it's required by the model.
            title: 'New Task',
            description: 'Description here',
            date: DateTime.now(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
