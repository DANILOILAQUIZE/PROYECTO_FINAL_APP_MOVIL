import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../entities/notificacion_entity.dart';
import '../../repositories/notificacion_repository.dart';
import '../app_bar.dart';
import '../bottom_app_bar.dart';
import '../drawer.dart';

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
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: "Notificaciones"),
      bottomNavigationBar: const BottomFooter(),
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
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.indigo.shade50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.notifications,
                                color: Colors.indigo.shade700,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 70,
                              child: Text(
                                notificacion.tipo,
                                style: TextStyle(
                                  color: Colors.indigo.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                notificacion.titulo,
                                style: TextStyle(
                                  color: Colors.indigo.shade800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notificacion.descripcion,
                                style: TextStyle(
                                  color: Colors.indigo.shade600,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Asignatura: ${notificacion.asignatura}",
                                style: TextStyle(
                                  color: Colors.indigo.shade400,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(notificacion.fechaHora)}",
                                style: TextStyle(
                                  color: Colors.indigo.shade400,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
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
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green.shade700,
                                ),
                                tooltip: 'Editar',
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () => eliminar(notificacion),
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade700,
                                ),
                                tooltip: 'Eliminar',
                              ),
                            ),
                          ],
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
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
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