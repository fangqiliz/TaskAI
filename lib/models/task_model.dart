import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum TaskCategory {
  work,
  personal,
  study,
  urgent,
}

extension TaskCategoryExtension on TaskCategory {
  String get name {
    switch (this) {
      case TaskCategory.work:
        return 'Trabajo';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.study:
        return 'Estudio';
      case TaskCategory.urgent:
        return 'Urgente';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.work:
        return Icons.work_outline_rounded;
      case TaskCategory.personal:
        return Icons.person_outline_rounded;
      case TaskCategory.study:
        return Icons.school_outlined_rounded;
      case TaskCategory.urgent:
        return Icons.error_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.work:
        return AppColors.primary;
      case TaskCategory.personal:
        return AppColors.secondary;
      case TaskCategory.study:
        return AppColors.priorityLow;
      case TaskCategory.urgent:
        return AppColors.priorityHigh;
    }
  }
}

enum TaskPriority {
  low,
  medium,
  high,
}

extension TaskPriorityExtension on TaskPriority {
  String get name {
    switch (this) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return AppColors.priorityLow;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.high:
        return AppColors.priorityHigh;
    }
  }
}

enum TaskStatus {
  pending,
  completed,
}

extension TaskStatusExtension on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.completed:
        return 'Completada';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.pending:
        return AppColors.textLight;
      case TaskStatus.completed:
        return AppColors.success;
    }
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime dueDate;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskCategory? category,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
