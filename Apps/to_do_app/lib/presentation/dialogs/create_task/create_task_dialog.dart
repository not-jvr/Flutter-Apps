import 'package:flutter/material.dart';
import 'package:to_do_app/presentation/widgets/create_task/select_priority.dart';
import 'package:to_do_app/presentation/widgets/task/task_widgets.dart';

/// Widget que muestra un diálogo para crear una nueva tarea
class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({super.key});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  String _taskName = '';
  String? _description;
  int _selectedPriority = PrioritySelector.defaultPriority;
  bool _isPriorityDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agregar Tarea',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              theme: theme,
              hintText: 'Nombre de la tarea',
              onChanged: (value) => setState(() => _taskName = value.trim()),
            ),
            const SizedBox(height: 16),
            Text(
              'Descripción',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              theme: theme,
              hintText: 'Agregar descripción',
              onChanged: (value) => setState(() => _description = value.trim()),
            ),
            const SizedBox(height: 24),
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required ThemeData theme,
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    final actionButtons = [
      _ActionButton(
        icon: Icons.access_time,
        onTap: () {
          // TODO: Implementar funcionalidad de tiempo
        },
      ),
      _ActionButton(
        icon: Icons.notifications_none,
        onTap: () {
          // TODO: Implementar funcionalidad de recordatorio
        },
      ),
      _ActionButton(
        icon: Icons.flag_outlined,
        isSelected: _isPriorityDialogOpen,
        onTap: _showPrioritySelector,
      ),
      Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_forward),
          color: theme.colorScheme.onPrimary,
          onPressed: _taskName.isEmpty ? null : _handleCreate,
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actionButtons,
    );
  }

  Future<void> _showPrioritySelector() async {
    setState(() => _isPriorityDialogOpen = true);

    final result = await showDialog<int>(
      context: context,
      builder: (context) => PrioritySelector(
        selectedPriority: _selectedPriority,
        onPriorityChanged: (priority) {
          setState(() => _selectedPriority = priority);
        },
      ),
    );

    if (result != null) {
      setState(() => _selectedPriority = result);
    }
    setState(() => _isPriorityDialogOpen = false);
  }

  void _handleCreate() {
    Navigator.of(context).pop(
      Task(
        name: _taskName,
        priority: _selectedPriority,
        description: _description,
      ),
    );
  }
}

/// Widget reutilizable para los botones de acción circulares
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.surfaceContainerHighest
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withOpacity(0.7),
        onPressed: onTap,
      ),
    );
  }
}