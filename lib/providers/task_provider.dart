import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  // Lista de tareas privadas en memoria
  final List<Task> _tasks = [];

  // Filtros activos
  TaskCategory? _selectedCategory;
  TaskStatus? _selectedStatus;

  // Registro de la última tarea eliminada (para funcionalidad deshacer/undo)
  Task? _lastDeletedTask;
  int? _lastDeletedIndex;

  TaskProvider() {
    _loadInitialDemoTasks();
  }

  // Carga inicial de tareas demo obligatorias requeridas por el usuario
  void _loadInitialDemoTasks() {
    final now = DateTime.now();
    
    _tasks.addAll([
      Task(
        id: 'demo-1',
        title: 'Revisar arquitectura del proyecto',
        description: 'Verificar la modularidad, cohesión y acoplamiento de las carpetas de TaskAI v1.0.',
        category: TaskCategory.work,
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        dueDate: now.add(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      Task(
        id: 'demo-2',
        title: 'Estudiar Flutter Material 3',
        description: 'Revisar la guía de diseño de Material Design 3, colorScheme, uso de NavigationBar y nuevos widgets como SegmentedButton.',
        category: TaskCategory.study,
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        dueDate: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 'demo-3',
        title: 'Comprar café',
        description: 'Café de grano tostado medio para mantener la productividad durante la codificación.',
        category: TaskCategory.personal,
        priority: TaskPriority.low,
        status: TaskStatus.completed,
        dueDate: now,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: 'demo-4',
        title: 'Entregar propuesta urgente',
        description: 'Enviar el documento final de la arquitectura del MVP v1.0 antes de que termine la jornada laboral.',
        category: TaskCategory.urgent,
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        dueDate: now,
        createdAt: now.subtract(const Duration(minutes: 45)),
      ),
    ]);
  }

  // Getters para obtener todas las tareas y filtros
  List<Task> get allTasks => List.unmodifiable(_tasks);
  TaskCategory? get selectedCategory => _selectedCategory;
  TaskStatus? get selectedStatus => _selectedStatus;

  // Filtrado reactivo de tareas
  List<Task> get filteredTasks {
    return _tasks.where((task) {
      final matchCategory = _selectedCategory == null || task.category == _selectedCategory;
      final matchStatus = _selectedStatus == null || task.status == _selectedStatus;
      return matchCategory && matchStatus;
    }).toList()
      ..sort((a, b) {
        // Ordenar primero por completadas (las completadas al final)
        if (a.status != b.status) {
          return a.status == TaskStatus.completed ? 1 : -1;
        }
        // Luego ordenar por prioridad (alta -> media -> baja)
        if (a.priority != b.priority) {
          return b.priority.index.compareTo(a.priority.index);
        }
        // Y por último por fecha límite
        return a.dueDate.compareTo(b.dueDate);
      });
  }

  // Métodos para cambiar filtros
  void setCategoryFilter(TaskCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setStatusFilter(TaskStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedStatus = null;
    notifyListeners();
  }

  // Lógica CRUD de Tareas
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _lastDeletedTask = _tasks[index];
      _lastDeletedIndex = index;
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  // Deshacer eliminación de tarea
  void undoDelete() {
    if (_lastDeletedTask != null && _lastDeletedIndex != null) {
      _tasks.insert(_lastDeletedIndex!, _lastDeletedTask!);
      _lastDeletedTask = null;
      _lastDeletedIndex = null;
      notifyListeners();
    }
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final newStatus = task.status == TaskStatus.pending 
          ? TaskStatus.completed 
          : TaskStatus.pending;
      _tasks[index] = task.copyWith(status: newStatus);
      notifyListeners();
    }
  }

  // Obtener una sola tarea por ID
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  // Métodos de estadísticas y reportes
  int get totalTasksCount => _tasks.length;
  int get completedTasksCount => _tasks.where((t) => t.status == TaskStatus.completed).length;
  int get pendingTasksCount => _tasks.where((t) => t.status == TaskStatus.pending).length;
  
  double get completionRate {
    if (_tasks.isEmpty) return 0.0;
    return completedTasksCount / totalTasksCount;
  }

  int getTasksCountByCategory(TaskCategory category) {
    return _tasks.where((t) => t.category == category).length;
  }

  int getCompletedTasksCountByCategory(TaskCategory category) {
    return _tasks.where((t) => t.category == category && t.status == TaskStatus.completed).length;
  }

  double getCompletionRateByCategory(TaskCategory category) {
    final total = getTasksCountByCategory(category);
    if (total == 0) return 0.0;
    return getCompletedTasksCountByCategory(category) / total;
  }

  int getTasksCountByPriority(TaskPriority priority) {
    return _tasks.where((t) => t.priority == priority).length;
  }
}
