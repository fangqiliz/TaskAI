import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_colors.dart';

class PrioritySelector extends StatelessWidget {
  final TaskPriority selectedPriority;
  final ValueChanged<TaskPriority> onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prioridad',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            children: TaskPriority.values.map((priority) {
              final isSelected = selectedPriority == priority;
              
              // Determinar colores según el requerimiento y la estética de la marca
              Color priorityColor;
              Color activeBgColor;
              Color activeTextColor = Colors.white;
              String indicatorChar;

              switch (priority) {
                case TaskPriority.low:
                  priorityColor = AppColors.priorityLow;
                  activeBgColor = AppColors.priorityLow;
                  indicatorChar = '🟦';
                  break;
                case TaskPriority.medium:
                  priorityColor = AppColors.priorityMedium;
                  activeBgColor = AppColors.priorityMedium;
                  indicatorChar = '🟨';
                  break;
                case TaskPriority.high:
                  priorityColor = AppColors.priorityHigh;
                  activeBgColor = AppColors.priorityHigh;
                  indicatorChar = '🟥';
                  break;
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () => onPriorityChanged(priority),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? activeBgColor.withOpacity(0.12) : Colors.transparent,
                      borderRadius: _getBorderRadiusForPriority(priority),
                      border: Border.all(
                        color: isSelected ? activeBgColor : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isSelected ? indicatorChar : '⬜',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          priority.name,
                          style: TextStyle(
                            color: isSelected ? activeBgColor : AppColors.textDark,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  BorderRadius _getBorderRadiusForPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const BorderRadius.only(
          topLeft: Radius.circular(11),
          bottomLeft: Radius.circular(11),
        );
      case TaskPriority.medium:
        return BorderRadius.zero;
      case TaskPriority.high:
        return const BorderRadius.only(
          topRight: Radius.circular(11),
          bottomRight: Radius.circular(11),
        );
    }
  }
}
