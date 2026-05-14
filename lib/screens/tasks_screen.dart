import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class TasksScreen extends StatefulWidget {
  TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  
  Set<String> selectedTaskIds = {};

  void _toggleSelection(String taskId) {
    setState(() {
      if (selectedTaskIds.contains(taskId)) {
        selectedTaskIds.remove(taskId);
      } else {
        selectedTaskIds.add(taskId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedTaskIds.clear();
    });
  }

  Future<void> _deleteSelectedTasks() async {
    for (String id in selectedTaskIds) {
      await _firestoreService.deleteTask(id);
    }
    _clearSelection();
  }

  void _showTaskDialog({Task? taskToEdit}) {
    final titleController = TextEditingController(text: taskToEdit?.title ?? '');
    final descriptionController = TextEditingController(text: taskToEdit?.description ?? '');
    DateTime selectedDate = taskToEdit?.date ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(taskToEdit == null ? 'New Task' : 'Edit Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      minLines: 1,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != selectedDate) {
                              setDialogState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: const Text('Select Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;
                    
                    if (taskToEdit == null) {
                      await _firestoreService.addTask(Task(
                        id: '', 
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        date: selectedDate,
                      ));
                    } else {
                      await _firestoreService.updateTask(Task(
                        id: taskToEdit.id,
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        date: selectedDate,
                        isCompleted: taskToEdit.isCompleted,
                      ));
                      _clearSelection();
                    }
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelectionMode = selectedTaskIds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(isSelectionMode ? '${selectedTaskIds.length} Selected' : 'My Tasks'),
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSelection,
              )
            : null,
        actions: [
          if (isSelectionMode && selectedTaskIds.length == 1)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final taskId = selectedTaskIds.first;
                final task = await _firestoreService.getTaskById(taskId);
                if (task != null && mounted) {
                  _showTaskDialog(taskToEdit: task);
                }
              },
            ),
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Tasks?'),
                    content: Text('Are you sure you want to delete ${selectedTaskIds.length} task(s)?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteSelectedTasks();
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          if (!isSelectionMode)
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
              final isSelected = selectedTaskIds.contains(task.id);
              
              return ListTile(
                selected: isSelected,
                selectedTileColor: Colors.blue.withAlpha(51),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(task.description),
                trailing: isSelectionMode
                  ? Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        _toggleSelection(task.id);
                      },
                    )
                  : Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        _firestoreService.toggleTaskStatus(task.id, task.isCompleted);
                      },
                    ),
                onLongPress: () {
                  if (!isSelectionMode) {
                    _toggleSelection(task.id);
                  }
                },
                onTap: () {
                  if (isSelectionMode) {
                    _toggleSelection(task.id);
                  } else {
                    // Open details or nothing in normal mode
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: isSelectionMode 
          ? null 
          : FloatingActionButton(
              onPressed: () => _showTaskDialog(),
              child: const Icon(Icons.add),
            ),
    );
  }
}
