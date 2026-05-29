import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_ai/core/theme/app_colors.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';

import '../widgets/category_chip.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final task = taskProvider.getTaskById(taskId);

    // Si la tarea fue borrada y estamos saliendo de la pantalla
    if (task == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isCompleted = task.status == TaskStatus.completed;
    final formattedDueDate = DateFormat('EEEE, d \'de\' MMMM, yyyy', 'es').format(task.dueDate);
    final capitalizedDueDate = formattedDueDate[0].toUpperCase() + formattedDueDate.substring(1);
    
    final formattedCreatedAt = DateFormat('d \'de\' MMMM, yyyy • h:mm a', 'es').format(task.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle de Tarea',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Botón Editar Rápido
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              context.push('/edit/${task.id}');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Badge de Estado y Prioridad superior
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Categoría
                  CategoryChip(category: task.category, showIcon: true),
                  
                  // Estado Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? AppColors.success.withOpacity(0.1) 
                          : AppColors.textLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCompleted ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                          size: 14,
                          color: isCompleted ? AppColors.success : AppColors.textLight,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          task.status.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? AppColors.success : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // 2. Título de la Tarea (Grande)
              Text(
                task.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textDark,
                      height: 1.2,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
              ),
              
              const SizedBox(height: 24),
              
              // 3. Tarjeta de Detalles del Tiempo (Fechas)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  children: [
                    _buildMetaRow(
                      context: context,
                      icon: Icons.calendar_month_rounded,
                      iconColor: AppColors.primary,
                      label: 'Fecha Límite',
                      value: capitalizedDueDate,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: AppColors.border, height: 1),
                    ),
                    _buildMetaRow(
                      context: context,
                      icon: Icons.add_circle_outline_rounded,
                      iconColor: AppColors.textLight,
                      label: 'Creada el',
                      value: formattedCreatedAt,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: AppColors.border, height: 1),
                    ),
                    _buildMetaRow(
                      context: context,
                      icon: Icons.flag_rounded,
                      iconColor: task.priority.color,
                      label: 'Prioridad de Tarea',
                      value: 'Prioridad ${task.priority.name}',
                      valueColor: task.priority.color,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 4. Descripción de la Tarea
              Text(
                'Descripción',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Text(
                  task.description.isEmpty 
                      ? 'Sin descripción adicional proporcionada para esta tarea.'
                      : task.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: task.description.isEmpty ? AppColors.textLight : AppColors.textDark,
                        height: 1.5,
                      ),
                ),
              ),
              
              const SizedBox(height: 48),
              
              // 5. Botones de Acción inferior
              Row(
                children: [
                  // Eliminar Tarea
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 26),
                    color: AppColors.priorityHigh,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.priorityHigh.withOpacity(0.08),
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      final title = task.title;
                      taskProvider.deleteTask(task.id);
                      context.pop(); // Volver al Home
                      
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tarea "$title" eliminada'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          action: SnackBarAction(
                            label: 'DESHACER',
                            onPressed: () => taskProvider.undoDelete(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  
                  // Completar / Descompletar Tarea
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        isCompleted ? Icons.radio_button_off_rounded : Icons.check_circle_rounded,
                        size: 20,
                      ),
                      label: Text(
                        isCompleted ? 'Marcar como Pendiente' : 'Marcar como Completada',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted ? AppColors.textDark : AppColors.success,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        taskProvider.toggleTaskStatus(task.id);
                        
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isCompleted 
                                  ? 'Tarea marcada como pendiente' 
                                  : '¡Felicidades! Tarea completada',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: isCompleted ? AppColors.textDark : AppColors.success,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: valueColor ?? AppColors.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
