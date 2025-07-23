import 'package:flutter/material.dart';

import 'drawer.dart';
import 'app_bar.dart';
import 'bottom_app_bar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: "Gestión Académica"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMenuCard(
              icon: Icons.calendar_today,
              title: 'Periodos Académicos',
              subtitle: 'Gestión de Periodos Académicos',
              color: Colors.deepPurple,
              onTap: () {
                Navigator.pushNamed(context, '/gestionPeriodosAcademicos');
              },
            ),
            _buildMenuCard(
              icon: Icons.menu_book,
              title: 'Materias',
              subtitle: 'Gestión de Materias',
              color: Colors.indigo,
              onTap: () {
                Navigator.pushNamed(context, '/gestionMaterias');
              },
            ),
            _buildMenuCard(
              icon: Icons.task,
              title: 'Tareas',
              subtitle: 'Gestión de Tareas',
              color: Colors.teal,
              onTap: () {
                Navigator.pushNamed(context, '/gestionTareas');
              },
            ),
            _buildMenuCard(
              icon: Icons.notifications,
              title: 'Notificaciones',
              subtitle: 'Gestión de Notificacionesss',
              color: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, '/gestionNotificaciones');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomFooter(),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(icon, size: 38, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
