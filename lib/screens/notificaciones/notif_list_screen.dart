import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../entities/notificacion_entity.dart';
import '../../repositories/notificacion_repository.dart';

class NotificacionListScreen extends StatefulWidget {
  const NotificacionListScreen({super.key});

  @override
  State<NotificacionListScreen> createState() => _NotificacionListScreenState();
}

class _NotificacionListScreenState extends State<NotificacionListScreen> {
  late Future<List<Notificacion>> _listNotificaciones;

  @override
  void initState() {
    super.initState();
    _loadNotificaciones();
  }

  void _loadNotificaciones() {
    _listNotificaciones = NotificacionRepository.list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Notificaciones"),
        backgroundColor: const Color.fromARGB(255, 36, 92, 197),
      ),
      body: FutureBuilder<List<Notificacion>>(
        future: _listNotificaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No existen notificaciones"));
          } else {
            final notificaciones = snapshot.data!;
            return ListView.builder(
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                final notificacion = notificaciones[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.notifications, color: Colors.blue),
                    title: Text(
                      notificacion.titulo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notificacion.descripcion),
                        SizedBox(height: 4),
                        Text(
                          "Asignatura: ${notificacion.asignatura} | Tipo: ${notificacion.tipo}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          "Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(notificacion.fechaHora)}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/notif_form",
                              arguments: notificacion,
                            ).then((_) {
                              setState(() {
                                _loadNotificaciones();
                              });
                            });
                          },
                          icon: Icon(Icons.edit, color: Colors.green),
                        ),
                        IconButton(
                          onPressed: () => eliminar(notificacion),
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/notif_form").then((_) {
            setState(() {
              _loadNotificaciones();
            });
          });
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 36, 92, 197),
      ),
    );
  }

  Future<void> eliminar(Notificacion notificacion) async {
    final respuesta = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¿Eliminar Notificación?"),
        content: Text(
          "¿Estás seguro que deseas eliminar la notificación '${notificacion.titulo}'?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Aceptar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
        ],
      ),
    );

    if (respuesta == true) {
      await NotificacionRepository.delete(notificacion);
      setState(() {
        _loadNotificaciones();
      });
    }
  }
}