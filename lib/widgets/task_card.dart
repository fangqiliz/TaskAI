import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_ai/core/theme/app_colors.dart';
import '../models/task_model.dart';
import 'category_chip.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onStatusChanged;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onStatusChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;
    
    // Configuración visual según prioridad
    Color priorityColor = task.priority.color;
    
    return Card(
      // Elevación baja para sombras extremadamente sutiles
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCompleted ? AppColors.border.withOpacity(0.5) : AppColors.border, 
          width: 1,
        ),
      ),
      color: isCompleted ? AppColors.surface.withOpacity(0.6) : AppColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Barra de color lateral izquierda según prioridad
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.textLight.withOpacity(0.3) : priorityColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // 2. Checkbox e información de la tarea
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Checkbox personalizado con animación táctil
                      GestureDetector(
                        onTap: () => onStatusChanged(!isCompleted),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted ? AppColors.success : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCompleted ? AppColors.success : AppColors.textLight.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: isCompleted
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      
                      const SizedBox(width: 14),
                      
                      // Textos de la tarea (título y fecha/categoría)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Título de la tarea
                            Text(
                              task.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isCompleted ? AppColors.textLight : AppColors.textDark,
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            
                            const SizedBox(height: 6),
                            
                            // Fila de metadatos (Fecha, Categoría, Prioridad badge)
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                // Chips de categoría
                                CategoryChip(
                                  category: task.category,
                                  showIcon: true,
                                ),
                                
                                // Fecha límite
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 11,
                                      color: _getDueDateColor(task.dueDate, isCompleted),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDueDate(task.dueDate),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: _getDueDateColor(task.dueDate, isCompleted),
                                      ),
                                    ),
                                  ],
                                ),

                                // Badge de prioridad (pequeño texto coloreado)
                                Text(
                                  '• ${task.priority.name}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted ? AppColors.textLight.withOpacity(0.5) : priorityColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 3. Botón Editar
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: AppColors.textLight,
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  context.push('/edit/${task.id}');
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  // Formateador inteligente de fechas en español
  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Hoy';
    } else if (taskDate == tomorrow) {
      return 'Mañana';
    } else if (taskDate == yesterday) {
      return 'Ayer';
    } else {
      return DateFormat('d MMM', 'es').format(date);
    }
  }

  // Color de fecha inteligente (Rojo si está vencida y pendiente)
  Color _getDueDateColor(DateTime date, bool isCompleted) {
    if (isCompleted) return AppColors.textLight.withOpacity(0.5);
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate.isBefore(today)) {
      return AppColors.priorityHigh; // Vencida
    } else if (taskDate == today) {
      return AppColors.priorityMedium; // Hoy
    }
    return AppColors.textLight;
  }
}
