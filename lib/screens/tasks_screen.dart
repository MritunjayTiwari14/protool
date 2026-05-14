import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/task_dialog.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  
  Set<String> selectedTaskIds = {};
  List<Task>? _localTasks;
  List<Task>? _lastSnapshotData;
  late final Stream<List<Task>> _tasksStream;

  @override
  void initState() {
    super.initState();
    _tasksStream = _firestoreService.getTasks();
  }

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
    showDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
          taskToEdit: taskToEdit,
          onSave: (Task task) async {
            if (task.id.isEmpty) {
              await _firestoreService.addTask(task);
            } else {
              await _firestoreService.updateTask(task);
              _clearSelection();
            }
          },
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red.withAlpha(30);
      case 'main':
        return Colors.amber.withAlpha(30);
      case 'normal':
      default:
        return Colors.green.withAlpha(30);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;

    setState(() {
      if (_localTasks == null) return;
      
      final task = _localTasks!.removeAt(oldIndex);
      _localTasks!.insert(newIndex, task);

      double newPosition;
      if (newIndex == 0) {
        // Moved to top, higher position than current first
        newPosition = _localTasks!.length > 1 ? _localTasks![1].position + 10000.0 : DateTime.now().millisecondsSinceEpoch.toDouble();
      } else if (newIndex == _localTasks!.length - 1) {
        // Moved to bottom, lower position than current last
        newPosition = _localTasks![_localTasks!.length - 2].position - 10000.0;
      } else {
        // Moved in between
        double positionAbove = _localTasks![newIndex - 1].position;
        double positionBelow = _localTasks![newIndex + 1].position;
        newPosition = (positionAbove + positionBelow) / 2;
      }

      // Update the local task object visually
      _localTasks![newIndex] = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        date: task.date,
        isCompleted: task.isCompleted,
        position: newPosition,
        priority: task.priority,
      );

      _firestoreService.updateTaskPosition(task.id, newPosition);
    });
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
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteSelectedTasks();
                        },
                        child: const Text('Delete'),
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
        stream: _tasksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _localTasks == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (snapshot.hasData && snapshot.data != _lastSnapshotData) {
            _lastSnapshotData = snapshot.data;
            _localTasks = List.from(snapshot.data!);
          }

          if (_localTasks == null || _localTasks!.isEmpty) {
            return const Center(child: Text('No tasks yet.'));
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: _localTasks!.length,
              onReorderItem: _onReorder,
              proxyDecorator: (Widget child, int index, Animation<double> animation) {
                return Material(
                  elevation: 4,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shadowColor: Colors.black45,
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final task = _localTasks![index];
                final isSelected = selectedTaskIds.contains(task.id);

                return Container(
                  key: ValueKey(task.id),
                  color: isSelected ? Colors.blue.withAlpha(51) : _getPriorityColor(task.priority),
                  child: ListTile(
                    selected: isSelected,
                    leading: isSelectionMode
                      ? null
                      : ReorderableDragStartListener(
                          index: index,
                          child: const Icon(Icons.drag_indicator),
                        ),
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
                  )
                );
              },
            ),
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
