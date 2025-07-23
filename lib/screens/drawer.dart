import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Usuario', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blue),
            title: const Text('Ajustes'),
            onTap: () {
              Navigator.pop(context);
              // Implementa la función de ajustes aquí
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
          Container(
            padding: EdgeInsets.all(10), // Espacio blanco alrededor
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), // Esquinas redondeadas
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 243, 33, 33), // Fondo rojo
                borderRadius: BorderRadius.circular(
                  15,
                ), // Esquinas redondeadas internas
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ), // Icono blanco
                title: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white),
                ), // Texto blanco
                onTap: () {
                  Navigator.pop(context);
                  // Implementa la función de cierre de sesión aquí
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
