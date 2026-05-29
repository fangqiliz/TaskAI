import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task_ai/core/theme/app_colors.dart';
import 'dart:io';

import '../providers/task_provider.dart';

import '../widgets/empty_state.dart';
import '../widgets/filter_bar.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.filteredTasks;
    
    // Obtener información del día
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d \'de\' MMMM', 'es').format(now);
    final capitalizedDate = formattedDate[0].toUpperCase() + formattedDate.substring(1);

    // Calcular tareas pendientes hoy para el saludo
    final pendingCount = taskProvider.pendingTasksCount;
    final String greetingMessage = pendingCount == 0
        ? '¡Todo al día! Disfruta tu tiempo.'
        : 'Tienes $pendingCount ${pendingCount == 1 ? 'tarea pendiente' : 'tareas pendientes'}.';

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Cabecera Premium (Greeting & Progreso)
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0, bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalizedDate,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'TaskAI Dashboard',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.textDark,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          greetingMessage,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Botón de estadísticas rápido
                  IconButton(
                    icon: const Icon(Icons.analytics_rounded, size: 28),
                    color: AppColors.primary,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.08),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () {
                      context.push('/stats');
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),

            // 2. Barra de Filtros
            const FilterBar(),
            
            const SizedBox(height: 12),

            // 3. Listado de Tareas Reactivo
            Expanded(
              child: tasks.isEmpty
                  ? EmptyState(
                      title: taskProvider.selectedCategory != null || taskProvider.selectedStatus != null
                          ? 'Sin resultados para los filtros'
                          : 'No tienes tareas registradas',
                      subtitle: taskProvider.selectedCategory != null || taskProvider.selectedStatus != null
                          ? 'Prueba limpiando o cambiando los filtros seleccionados.'
                          : 'Comienza agregando tu primera tarea presionando el botón "+".',
                      icon: taskProvider.selectedCategory != null || taskProvider.selectedStatus != null
                          ? Icons.filter_list_off_rounded
                          : Icons.playlist_add_check_rounded,
                      actionLabel: taskProvider.selectedCategory != null || taskProvider.selectedStatus != null
                          ? 'Limpiar Filtros'
                          : null,
                      onActionPressed: taskProvider.selectedCategory != null || taskProvider.selectedStatus != null
                          ? taskProvider.clearFilters
                          : null,
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: tasks.length,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        
                        // Dismissible para Swipe-to-delete
                        return Dismissible(
                          key: Key(task.id),
                          direction: DismissDirection.endToStart, // Swipe a la izquierda
                          background: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: AppColors.priorityHigh,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.centerRight,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Eliminar tarea',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.delete_sweep_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) {
                            // Guardar nombre antes de borrar para SnackBar
                            final taskTitle = task.title;
                            taskProvider.deleteTask(task.id);
                            
                            // Mostrar SnackBar con opción deshacer
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tarea "$taskTitle" eliminada'),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                action: SnackBarAction(
                                  label: 'DESHACER',
                                  textColor: AppColors.secondary,
                                  onPressed: () {
                                    taskProvider.undoDelete();
                                  },
                                ),
                              ),
                            );
                          },
                          child: TaskCard(
                            task: task,
                            onStatusChanged: (value) {
                              taskProvider.toggleTaskStatus(task.id);
                            },
                            onTap: () {
                              context.push('/detail/${task.id}');
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      
      // Botón Flotante (FAB) moderno
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/create');
        },
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'Nueva Tarea',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            context.push('/stats');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline_rounded),
            selectedIcon: Icon(Icons.check_circle_rounded, color: AppColors.primary),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics_rounded, color: AppColors.primary),
            label: 'Métricas',
          ),
        ],
      ),
    );
  }
}
