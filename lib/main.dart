import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'providers/task_provider.dart';
import 'routes/app_router.dart';

void main() async {
  // Asegurar inicialización de bindings en Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar formatos locales en español para mostrar "Hoy", "Mañana" y fechas correctamente
  await initializeDateFormatting('es', null);

  runApp(const TaskAIApp());
}

class TaskAIApp extends StatelessWidget {
  const TaskAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp.router(
        title: 'TaskAI v1.0',
        debugShowCheckedModeBanner: false,
        
        // Tema global premium basado en Material Design 3
        theme: AppTheme.lightTheme,
        
        // Configuración de navegación moderna con go_router
        routerConfig: AppRouter.router,
      ),
    );
  }
}
