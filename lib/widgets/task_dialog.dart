import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskDialog extends StatefulWidget {
  final Task? taskToEdit;
  final Function(Task) onSave;

  const TaskDialog({super.key, this.taskToEdit, required this.onSave});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskToEdit?.title ?? '');
    _descriptionController = TextEditingController(text: widget.taskToEdit?.description ?? '');
    _selectedDate = widget.taskToEdit?.date ?? DateTime.now();
    _selectedPriority = widget.taskToEdit?.priority ?? 'normal';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.taskToEdit == null ? 'New Task' : 'Edit Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              minLines: 1,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Priority:', style: TextStyle(
                fontSize: 16)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                textStyle: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width * 0.035).clamp(10.0, 14.0),
                ),
              ),
              segments: const [
                ButtonSegment(
                  value: 'normal',
                  label: FittedBox(fit: BoxFit.scaleDown, child: Text('Normal')),
                  icon: Icon(Icons.circle, color: Colors.green, size: 14),
                ),
                ButtonSegment(
                  value: 'main',
                  label: FittedBox(fit: BoxFit.scaleDown, child: Text('Main')),
                  icon: Icon(Icons.circle, color: Colors.amber, size: 14),
                ),
                ButtonSegment(
                  value: 'urgent',
                  label: FittedBox(fit: BoxFit.scaleDown, child: Text('Urgent')),
                  icon: Icon(Icons.circle, color: Colors.red, size: 14),
                ),
              ],
              selected: {_selectedPriority},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedPriority = newSelection.first;
                });
              },
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
          onPressed: () {
            if (_titleController.text.trim().isEmpty) return;
            
            final newTask = Task(
              id: widget.taskToEdit?.id ?? '', 
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              date: _selectedDate,
              isCompleted: widget.taskToEdit?.isCompleted ?? false,
              position: widget.taskToEdit?.position ?? DateTime.now().millisecondsSinceEpoch.toDouble(),
              priority: _selectedPriority,
            );
            
            widget.onSave(newTask);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
