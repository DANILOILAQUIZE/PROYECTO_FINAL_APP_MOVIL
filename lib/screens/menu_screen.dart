import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.blue[700], size: 38),
                  ),
                  const SizedBox(height: 12),
                  const Text('Bienvenido', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('Usuario', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search, color: Colors.blue),
              title: const Text('Buscar'),
              onTap: () {
                Navigator.pop(context);
                // Implementa la función de búsqueda aquí
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_none, color: Colors.blue),
              title: const Text('Notificaciones'),
              onTap: () {
                Navigator.pop(context);
                // Implementa la función de notificaciones aquí
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/gestionPerfil');
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Text(
            "Gestión Académica",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {}, // Implementa búsqueda
            ),
          ],
        ),
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
