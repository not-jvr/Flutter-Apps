import 'package:flutter/material.dart';
import 'package:to_do_app/presentation/widgets/task/task_widgets.dart';
import 'package:to_do_app/presentation/dialogs/create_task/create_task_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _tasks.isEmpty
          ? _buildEmptyState(theme)
          : TaskList(
              tasks: _tasks,
              onTaskDeleted: () => setState(() {}),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddTask,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Index'),
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist,
            size: 100,
            color: theme.colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 20),
          Text(
            '¿Qué tienes que hacer hoy?',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Presiona + para agregar una tarea',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _handleAddTask() async {
    final Task? newTask = await showDialog<Task>(
      context: context,
      builder: (context) => const CreateTaskDialog(),
    );

    if (newTask != null) {
      setState(() {
        _tasks.add(newTask);
      });
    }
  }
}