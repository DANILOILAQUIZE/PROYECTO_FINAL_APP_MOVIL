import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menú Principal"),
        backgroundColor: Colors.blue,
      ),
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
            _buildMenuCard(
              icon: Icons.person,
              title: 'Perfil',
              subtitle: 'Gestión de Perfil',
              color: Colors.pink,
              onTap: () {
                Navigator.pushNamed(context, '/gestionPerfil');
              },
            ),
          ],
        ),
      ),
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
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 40, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        onTap: onTap,
      ),
    );
  }
}
