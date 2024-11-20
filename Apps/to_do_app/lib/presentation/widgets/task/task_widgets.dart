import 'package:flutter/material.dart';
import 'package:to_do_app/presentation/widgets/create_task/task_details.dart';

class Task {
  final String name;
  final int priority;
  final String? description;

  const Task({
    required this.name,
    required this.priority,
    this.description,
  });
}

class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
    required this.tasks,
    required this.onTaskDeleted,
  });

  final List<Task> tasks;  // Tipado explícito
  final VoidCallback onTaskDeleted;

  @override
  State<TaskList> createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  void _deleteTask(int index) {
    setState(() {
      widget.tasks.removeAt(index);
    });
    widget.onTaskDeleted();
  }

  @override
  Widget build(BuildContext context) {
    final sortedTasks = List<Task>.from(widget.tasks)
      ..sort((a, b) => a.priority.compareTo(b.priority));

    return ListView.builder(
      itemCount: sortedTasks.length,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final task = sortedTasks[index];
        return GestureDetector(
          onTap: () => TaskDetailsDialog.show(context, task),
          child: TaskCard(
            task: task,
            onDelete: () => _deleteTask(index),
          ),
        );
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Row(
          children: [
            Expanded(
              child: Text(
                task.name,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.flag,
            ),
            const SizedBox(width: 5),
            Text(
              '${task.priority}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
          tooltip: 'Eliminar tarea',
        ),
      ),
    );
  }
}