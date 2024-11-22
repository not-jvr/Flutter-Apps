import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/presentation/dialogs/create_task/tag/create_tag_dialog.dart';
import 'package:to_do_app/presentation/widgets/create_task/select_priority.dart';
import 'package:to_do_app/presentation/widgets/create_task/select_tag.dart';
import 'package:to_do_app/presentation/widgets/task/task_widgets.dart';
import 'package:to_do_app/providers/tag/provider_tag.dart';

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
  String? _selectedTagName; // Variable para almacenar la etiqueta seleccionada
  Color? _selectedTagColor; // Variable para almacenar el color de la etiqueta

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tagProvider = Provider.of<TagProvider>(context);

    return Dialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agregar Tarea', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            CustomTextField(
              theme: theme,
              hintText: 'Nombre de la tarea',
              onChanged: (value) => setState(() => _taskName = value.trim()),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              theme: theme,
              hintText: 'Descripción (opcional)',
              onChanged: (value) => setState(() => _description = value.trim()),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(theme, tagProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, TagProvider tagProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.access_time_outlined),
              onPressed: () {
                // TODO: Implementar funcionalidad de tiempo
              },
            ),
            IconButton(
              icon: const Icon(Icons.tag_outlined),
              onPressed: () => _showTagSelector(tagProvider),
            ),
            IconButton(
              icon: const Icon(Icons.flag_outlined),
              color: _isPriorityDialogOpen ? theme.colorScheme.primary : null,
              onPressed: _showPrioritySelector,
            ),
          ],
        ),
        FilledButton(
          onPressed: _taskName.isEmpty ? null : _handleCreate,
          style: FilledButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
          child: Icon(Icons.arrow_forward, color: theme.colorScheme.onPrimary),
        ),
      ],
    );
  }

  Future<void> _showTagSelector(TagProvider tagProvider) async {
    final tag = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SelectTagDialog(
        tags: tagProvider.tags, // Pasa las etiquetas existentes
        onCreateTag: () {
          Navigator.of(context).pop();
          _showCreateTagDialog(
              tagProvider); // Mostrar diálogo para crear nueva etiqueta
        },
        onDeleteTag: (tagToDelete) {
          setState(() {
            tagProvider.tags.remove(tagToDelete); // Elimina la etiqueta
          });
          Navigator.of(context)
              .pop(); // Cierra el diálogo después de eliminar la etiqueta
          _showTagSelector(
              tagProvider); // Vuelve a mostrar el diálogo actualizado
        },
        onAddTag: (newTag) {
          setState(() {
            tagProvider.tags.add(newTag); // Agrega la nueva etiqueta a la lista
          });
        },
      ),
    );

    if (tag != null) {
      setState(() {
        _selectedTagName = tag['name'];
        _selectedTagColor = tag['color'];
      });
    }
  }

  Future<void> _showCreateTagDialog(TagProvider tagProvider) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateTagDialog(),
    );
    if (result != null) {
      tagProvider.addTag(result);
    }
  }

  Future<void> _showPrioritySelector() async {
    setState(() => _isPriorityDialogOpen = true);
    final result = await showDialog<int>(
      context: context,
      builder: (context) => PrioritySelector(
        selectedPriority: _selectedPriority,
        onPriorityChanged: (priority) =>
            setState(() => _selectedPriority = priority),
      ),
    );
    setState(() {
      _isPriorityDialogOpen = false;
      if (result != null) _selectedPriority = result;
    });
  }

  void _handleCreate() {
    Task newTask = Task(
      name: _taskName,
      priority: _selectedPriority,
      description: _description,
      tagName: _selectedTagName,
      tagColor: _selectedTagColor,
    );
    Navigator.of(context).pop(newTask);
  }
}

class CustomTextField extends StatelessWidget {
  final ThemeData theme;
  final String hintText;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    super.key,
    required this.theme,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }
}
