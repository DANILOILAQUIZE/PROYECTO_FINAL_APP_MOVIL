import 'package:flutter/material.dart';
import 'screens/materia/materia_list_screen.dart';
import 'screens/materia/materia_form_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/notificaciones/notif_form.dart';
import 'screens/notificaciones/notif_list_screen.dart';
import 'screens/perfil/ver_perfil.dart';
import 'screens/periodos_academicos/lista_periodos.dart';
import 'screens/periodos_academicos/agregar_periodo.dart';
import 'screens/tareas/tareas_form_screen.dart';
import 'screens/tareas/tareas_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Académica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MenuScreen(),
        '/gestionPeriodosAcademicos': (context) => PeriodosScreen(),
        '/agregarPeriodo': (context) => AgregarPeriodoScreen(),
        '/verPerfil': (context) => VerPerfilScreen(),
        '/gestionNotificaciones': (context) => NotificacionListScreen(),
        '/notif_form': (context) => NotificacionFormScreen(),
        '/gestionMaterias': (context) => MateriaListScreen(),
        '/materias/form': (context) => MateriasFormScreen(),
        '/gestionPerfil': (context) => VerPerfilScreen(),
        '/gestionTareas': (context) => TareaListScreen(),
        '/tareas/form': (context) => TareaFormScreen(),
      },
    );
  }
}