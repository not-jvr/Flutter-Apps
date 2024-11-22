import 'package:flutter/material.dart';

class Task {
  final String name;
  final int priority;
  final String? description;
  final String? tagName;
  final Color? tagColor;

  const Task({
    required this.name,
    required this.priority,
    this.description,
    this.tagName,
    this.tagColor,
  });
}

class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
    required this.tasks,
    required this.onTaskDeleted,
  });

  final List<Task> tasks;
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
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      itemBuilder: (context, index) {
        final task = sortedTasks[index];
        return _TaskItem(
          task: task,
          onDelete: () => _deleteTask(index),
          onTap: () => TaskDetailsDialog.show(context, task),
        );
      },
    );
  }
}

class _TaskItem extends StatelessWidget {
  const _TaskItem({
    required this.task,
    required this.onDelete,
    required this.onTap,
  });

  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  Color _getPriorityColor(BuildContext context, int priority) {
    final theme = Theme.of(context);
    switch (priority) {
      case 1:
        return theme.colorScheme.error;
      case 2:
        return theme.colorScheme.primary;
      case 3:
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColor = _getPriorityColor(context, task.priority);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: priorityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Priority indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: priorityColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: priorityColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (task.description?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (task.tagName != null && task.tagColor != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: task.tagColor!.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: task.tagColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                task.tagName!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: task.tagColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Delete button
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: theme.colorScheme.error,
                ),
                onPressed: onDelete,
                tooltip: 'Eliminar tarea',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskDetailsDialog {
  static void show(BuildContext context, Task task) {
    final theme = Theme.of(context);
    final priorityColor = theme.colorScheme.primary;
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (task.description != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    task.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (task.tagName != null && task.tagColor != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: task.tagColor!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: task.tagColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          task.tagName!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: task.tagColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}