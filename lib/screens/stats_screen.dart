import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:task_ai/core/theme/app_colors.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';

import '../widgets/stats_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Métricas generales
    final total = taskProvider.totalTasksCount;
    final completed = taskProvider.completedTasksCount;
    final pending = taskProvider.pendingTasksCount;
    final rate = taskProvider.completionRate;
    final ratePercent = (rate * 100).toStringAsFixed(0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabecera Premium
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0, bottom: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      color: AppColors.textDark,
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Rendimiento',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.textDark,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. Grid de KPIs principales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.15,
                  children: [
                    StatsCard(
                      title: 'Completado',
                      value: '$ratePercent%',
                      subtitle: '$completed de $total tareas',
                      icon: Icons.donut_large_rounded,
                      progress: rate,
                      gradientColors: AppColors.statsGradient1,
                    ),
                    StatsCard(
                      title: 'Pendientes',
                      value: '$pending',
                      subtitle: 'Por resolver',
                      icon: Icons.pending_actions_rounded,
                      gradientColors: AppColors.statsGradient4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 3. Indicador de Progreso Circular Central
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Círculo
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: rate,
                              strokeWidth: 12,
                              backgroundColor: AppColors.primary.withOpacity(0.08),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$ratePercent%',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const Text(
                                'Tasa',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Información detallada a la derecha
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tu Nivel de Foco',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              total == 0
                                  ? 'Aún no registras tareas para calcular tu productividad.'
                                  : rate == 1.0
                                      ? '¡Increíble! Has completado el 100% de tus objetivos.'
                                      : '¡Buen ritmo! Sigue así para completar tus pendientes.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textLight,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // 4. Sección: Tareas por Categorías
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tasa por Categorías',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: TaskCategory.values.map((category) {
                          final catTotal = taskProvider.getTasksCountByCategory(category);
                          final catCompleted = taskProvider.getCompletedTasksCountByCategory(category);
                          final catRate = taskProvider.getCompletionRateByCategory(category);
                          final catRatePercent = (catRate * 100).toStringAsFixed(0);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(category.icon, size: 18, color: category.color),
                                        const SizedBox(width: 8),
                                        Text(
                                          category.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$catCompleted/$catTotal ($catRatePercent%)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: category.color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: catTotal == 0 ? 0.0 : catRate,
                                    minHeight: 8,
                                    backgroundColor: category.color.withValues(alpha: 0.08),
                                    valueColor: AlwaysStoppedAnimation<Color>(category.color),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 5. Distribución de Tareas por Prioridades
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distribución por Prioridad',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: TaskPriority.values.map((priority) {
                        final count = taskProvider.getTasksCountByPriority(priority);
                        Color color;
                        String char;

                        switch (priority) {
                          case TaskPriority.low:
                            color = AppColors.priorityLow;
                            char = '🟦';
                            break;
                          case TaskPriority.medium:
                            color = AppColors.priorityMedium;
                            char = '🟨';
                            break;
                          case TaskPriority.high:
                            color = AppColors.priorityHigh;
                            char = '🟥';
                            break;
                        }

                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  char,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  priority.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$count ${count == 1 ? 'tarea' : 'tareas'}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      
      // Barra de navegación inferior con índice 1 activo
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          if (index == 0) {
            context.push('/');
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
