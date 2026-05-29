import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Colores principales obligatorios
  static const Color primary = Color(0xFF2563EB); // Azul principal
  static const Color secondary = Color(0xFF60A5FA); // Azul secundario
  static const Color background = Color(0xFFF8FAFC); // Fondo
  static const Color textDark = Color(0xFF334155); // Gris texto principal
  static const Color success = Color(0xFF22C55E); // Éxito
  static const Color priorityHigh = Color(0xFFEF4444); // Prioridad alta (Rojo)

  // Colores adicionales para mejorar la estética premium (M3 y semántica)
  static const Color textLight = Color(0xFF64748B); // Gris texto secundario (Slate 500)
  static const Color surface = Color(0xFFFFFFFF); // Blanco puro para tarjetas
  static const Color border = Color(0xFFE2E8F0); // Gris borde suave (Slate 200)
  
  // Colores de prioridades
  static const Color priorityMedium = Color(0xFFF59E0B); // Prioridad media (Ámbar)
  static const Color priorityLow = Color(0xFF10B981); // Prioridad baja (Esmeralda)

  // Degradados premium para estadísticas y elementos destacados
  static const List<Color> primaryGradient = [
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
  ];

  static const List<Color> statsGradient1 = [
    Color(0xFF2563EB),
    Color(0xFF60A5FA),
  ];

  static const List<Color> statsGradient2 = [
    Color(0xFF10B981),
    Color(0xFF34D399),
  ];

  static const List<Color> statsGradient3 = [
    Color(0xFFF59E0B),
    Color(0xFFFBBF24),
  ];

  static const List<Color> statsGradient4 = [
    Color(0xFFEF4444),
    Color(0xFFF87171),
  ];
}
