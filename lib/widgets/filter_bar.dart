import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';
import 'category_chip.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final activeCategory = taskProvider.selectedCategory;
    final activeStatus = taskProvider.selectedStatus;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Fila de Filtro de Categorías
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Opción "Todas" las categorías
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: FilterChip(
                    selected: activeCategory == null,
                    onSelected: (selected) {
                      if (selected) {
                        taskProvider.setCategoryFilter(null);
                      }
                    },
                    label: const Text('Categorías'),
                    avatar: Icon(
                      Icons.grid_view_rounded,
                      size: 16,
                      color: activeCategory == null ? AppColors.primary : AppColors.textLight,
                    ),
                    backgroundColor: Colors.transparent,
                    selectedColor: AppColors.primary.withOpacity(0.08),
                    checkmarkColor: AppColors.primary,
                    side: BorderSide(
                      color: activeCategory == null ? AppColors.primary : AppColors.border,
                      width: activeCategory == null ? 1.5 : 1.0,
                    ),
                    labelStyle: TextStyle(
                      color: activeCategory == null ? AppColors.primary : AppColors.textDark,
                      fontWeight: activeCategory == null ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
                
                // Chips individuales para cada categoría del enum
                ...TaskCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: CategoryChip(
                      category: category,
                      isSelected: activeCategory == category,
                      onSelected: (selected) {
                        taskProvider.setCategoryFilter(selected ? category : null);
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          // 2. Fila de Filtro de Estados
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Estado: Todas
                _buildStatusChip(
                  context: context,
                  label: 'Todos los estados',
                  isSelected: activeStatus == null,
                  onSelected: () => taskProvider.setStatusFilter(null),
                  icon: Icons.list_alt_rounded,
                ),
                const SizedBox(width: 6),
                
                // Estado: Pendientes
                _buildStatusChip(
                  context: context,
                  label: 'Pendientes',
                  isSelected: activeStatus == TaskStatus.pending,
                  onSelected: () => taskProvider.setStatusFilter(TaskStatus.pending),
                  icon: Icons.radio_button_off_rounded,
                ),
                const SizedBox(width: 6),
                
                // Estado: Completadas
                _buildStatusChip(
                  context: context,
                  label: 'Completadas',
                  isSelected: activeStatus == TaskStatus.completed,
                  onSelected: () => taskProvider.setStatusFilter(TaskStatus.completed),
                  icon: Icons.check_circle_outline_rounded,
                ),
              ],
            ),
          ),
          
          // Botón indicador para limpiar filtros (si hay alguno activo)
          if (activeCategory != null || activeStatus != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: InkWell(
                onTap: taskProvider.clearFilters,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.clear_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Limpiar filtros',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    required IconData icon,
  }) {
    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => onSelected(),
      label: Text(label),
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected ? AppColors.primary : AppColors.textLight,
      ),
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.primary.withOpacity(0.08),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
        width: isSelected ? 1.5 : 1.0,
      ),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textDark,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}
