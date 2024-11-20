import 'package:flutter/material.dart';

/// Widget que maneja la selección de prioridad
/// Puede ser reutilizado en diferentes partes de la aplicación
class PrioritySelector extends StatelessWidget {
  final int selectedPriority;
  final ValueChanged<int> onPriorityChanged;
  static const int defaultPriority = 5;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Priority',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            // Grid de botones de prioridad
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                final priority = index + 1;
                return _PriorityButton(
                  priority: priority,
                  isSelected: priority == selectedPriority,
                  onTap: () {
                    onPriorityChanged(priority);
                    Navigator.of(context).pop(priority);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón individual para seleccionar una prioridad específica
class _PriorityButton extends StatelessWidget {
  final int priority;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityButton({
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.surfaceContainerHighest : Colors.transparent,
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$priority',
                style: TextStyle(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    Icons.flag,
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}