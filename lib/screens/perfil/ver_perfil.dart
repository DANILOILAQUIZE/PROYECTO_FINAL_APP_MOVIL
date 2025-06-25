import 'package:flutter/material.dart';

class VerPerfilScreen extends StatelessWidget {
  const VerPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Foto de perfil
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),

            // Título Información Personal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: const Text(
                'Información Personal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            // Tarjeta de información personal
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Nombres', 'Juan Carlos'),
                  _buildInfoRow('Apellidos', 'Pérez Gómez'),
                  _buildInfoRow('Correo', 'juan.perez@email.com'),
                  _buildInfoRow('Teléfono', '+51 987 654 321'),
                ],
              ),
            ),

            // Título Información Académica
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: const Text(
                'Información Académica',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            // Tarjeta de información académica
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Código', 'U20201F123'),
                  _buildInfoRow('Facultad', 'Ingeniería de Sistemas'),
                  _buildInfoRow('Escuela', 'Ingeniería de Software'),
                  _buildInfoRow('Ciclo', '5to'),
                ],
              ),
            ),

            // Botón de editar perfil
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navegación a pantalla de edición
                },
                child: const Text('Editar Perfil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
