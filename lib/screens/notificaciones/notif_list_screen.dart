import 'package:flutter/material.dart';
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
  String _filtroCategoria = 'todas';
  String _filtroPrioridad = 'todas';
  DateTime? _fechaSeleccionada;
  bool _mostrarSoloFecha = false;

  final List<String> categorias = ['todas', 'trabajo', 'personal', 'estudio'];
  final List<String> prioridades = [
    'todas',
    'alta',
    'importante',
    'media',
    'baja',
  ];

  @override
  void initState() {
    super.initState();
    // No cargar aquí, esperar a didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Obtener argumentos de navegación
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _fechaSeleccionada = args['selectedDate'] as DateTime?;
      _mostrarSoloFecha = args['showOnlyDate'] as bool? ?? false;
    }
    
    _loadNotificaciones();
  }

  void _loadNotificaciones() {
    if (_mostrarSoloFecha && _fechaSeleccionada != null) {
      // Cargar solo notificaciones de la fecha seleccionada
      _listNotificaciones = NotificacionRepository.getPorFecha(_fechaSeleccionada!);
    } else {
      // Cargar todas las notificaciones
      _listNotificaciones = NotificacionRepository.list();
    }
  }

  List<Notificacion> _filtrarNotificaciones(List<Notificacion> notificaciones) {
    // Si estamos viendo una fecha específica, no aplicar filtros adicionales
    if (_mostrarSoloFecha) {
      return notificaciones;
    }
    
    // Aplicar filtros normales
    return notificaciones.where((notificacion) {
      bool categoriaCoincide =
          _filtroCategoria == 'todas' ||
          notificacion.categoria == _filtroCategoria;
      bool prioridadCoincide =
          _filtroPrioridad == 'todas' ||
          notificacion.prioridad == _filtroPrioridad;
      return categoriaCoincide && prioridadCoincide;
    }).toList();
  }

  Color _getPrioridadColor(String prioridad) {
    switch (prioridad.toLowerCase()) {
      case 'alta':
        return Colors.red;
      case 'importante':
        return Colors.deepPurple;
      case 'media':
        return Colors.orange;
      case 'baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoriaColor(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'trabajo':
        return Colors.blue;
      case 'personal':
        return Colors.teal;
      case 'estudio':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoriaIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'trabajo':
        return Icons.work;
      case 'personal':
        return Icons.person;
      case 'estudio':
        return Icons.school;
      default:
        return Icons.event_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    String titulo = "Notificaciones";
    if (_mostrarSoloFecha && _fechaSeleccionada != null) {
      titulo = "Notificaciones - ${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}";
    }
    
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: titulo),
      bottomNavigationBar: const BottomFooter(),
      body: Column(
        children: [
          // Filtros (solo mostrar si no es una fecha específica)
          if (!_mostrarSoloFecha)
            Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filtroCategoria,
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: Icon(Icons.category, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items:
                        categorias.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria.toUpperCase()),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filtroCategoria = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filtroPrioridad,
                    decoration: InputDecoration(
                      labelText: 'Prioridad',
                      prefixIcon: Icon(Icons.priority_high, color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items:
                        prioridades.map((prioridad) {
                          return DropdownMenuItem(
                            value: prioridad,
                            child: Text(prioridad.toUpperCase()),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filtroPrioridad = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Lista de notificaciones
          Expanded(
            child: FutureBuilder<List<Notificacion>>(
              future: _listNotificaciones,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No existen notificaciones",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                } else {
                  final notificacionesFiltradas = _filtrarNotificaciones(
                    snapshot.data!,
                  );

                  if (notificacionesFiltradas.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_list_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No hay notificaciones con estos filtros",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: notificacionesFiltradas.length,
                    itemBuilder: (context, index) {
                      final notificacion = notificacionesFiltradas[index];
                      final prioridadColor = _getPrioridadColor(
                        notificacion.prioridad,
                      );
                      final categoriaColor = _getCategoriaColor(
                        notificacion.categoria,
                      );
                      final categoriaIcon = _getCategoriaIcon(
                        notificacion.categoria,
                      );

                      return Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                prioridadColor.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header con prioridad y categoría
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: categoriaColor.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        categoriaIcon,
                                        color: categoriaColor,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notificacion.titulo,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: prioridadColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  notificacion.prioridad
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: categoriaColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  notificacion.categoria
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Botones de acción
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                              size: 20,
                                            ),
                                            tooltip: 'Editar',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed:
                                                () => eliminar(notificacion),
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red.shade700,
                                              size: 20,
                                            ),
                                            tooltip: 'Eliminar',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Descripción
                                Text(
                                  notificacion.descripcion,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> eliminar(Notificacion notificacion) async {
    final respuesta = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("¿Eliminar Notificación?"),
            content: Text(
              "¿Estás seguro que deseas eliminar la notificación '${notificacion.titulo}'?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Eliminar"),
              ),
            ],
          ),
    );

    if (respuesta == true) {
      try {
        await NotificacionRepository.delete(notificacion);
        setState(() {
          _loadNotificaciones();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notificación eliminada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
