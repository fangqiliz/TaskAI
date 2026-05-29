import 'package:flutter/material.dart';
import 'package:task_ai/core/theme/app_colors.dart';
import '../models/task_model.dart';


class CategoryChip extends StatelessWidget {
  final TaskCategory category;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final bool showIcon;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onSelected,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final name = category.name;
    final icon = category.icon;
    final color = category.color;

    if (onSelected != null) {
      // Versión interactiva para filtros y formularios
      return FilterChip(
        selected: isSelected,
        onSelected: onSelected,
        label: Text(name),
        avatar: showIcon 
            ? Icon(
                icon, 
                size: 16, 
                color: isSelected ? AppColors.primary : color,
              ) 
            : null,
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.primary.withOpacity(0.08),
        checkmarkColor: AppColors.primary,
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
    } else {
      // Versión puramente visual para tarjetas y detalles
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              name,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }
}
