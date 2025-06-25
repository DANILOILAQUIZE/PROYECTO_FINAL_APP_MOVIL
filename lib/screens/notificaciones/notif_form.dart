import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../entities/notificacion_entity.dart';
import '../../repositories/notificacion_repository.dart';

class NotificacionFormScreen extends StatefulWidget {
  const NotificacionFormScreen({super.key});

  @override
  State<NotificacionFormScreen> createState() => _NotificacionFormScreenState();
}

class _NotificacionFormScreenState extends State<NotificacionFormScreen> {
  final formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final tipoNotificacionController = TextEditingController();
  final asignaturaController = TextEditingController();
  final fechaHoraController = TextEditingController();
  
  Notificacion? notificacion;
  bool esEdicion = false;
  DateTime fechaSeleccionada = DateTime.now();
  TimeOfDay horaSeleccionada = TimeOfDay.now();

  final tipoController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Notificacion) {
      notificacion = args;
      esEdicion = true;
      
      tituloController.text = notificacion!.titulo;
      descripcionController.text = notificacion!.descripcion;
      tipoNotificacionController.text = notificacion!.tipo;
      asignaturaController.text = notificacion!.asignatura;
      
      fechaSeleccionada = notificacion!.fechaHora;
      horaSeleccionada = TimeOfDay.fromDateTime(notificacion!.fechaHora);
      
      _actualizarFechaHoraController();
    } else {
      // Inicializar sin valores por defecto
      _actualizarFechaHoraController();
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    descripcionController.dispose();
    tipoNotificacionController.dispose();
    asignaturaController.dispose();
    fechaHoraController.dispose();
    super.dispose();
  }

  void _actualizarFechaHoraController() {
    final fecha = DateTime(
      fechaSeleccionada.year,
      fechaSeleccionada.month,
      fechaSeleccionada.day,
    );
    fechaHoraController.text = DateFormat('dd/MM/yyyy').format(fecha);
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (fecha != null) {
      setState(() {
        fechaSeleccionada = fecha;
        _actualizarFechaHoraController();
      });
    }
  }

  // No necesitamos el selector de hora

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          notificacion == null
              ? "Nueva Notificación"
              : "Editar Notificación",
        ),
        backgroundColor: const Color.fromARGB(255, 36, 92, 197),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: tituloController,
                validator: (value) => 
                    value == null || value.isEmpty 
                        ? 'Campo requerido' 
                        : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title, color: Colors.blue),
                  labelText: "Título de la Notificación",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              TextFormField(
                controller: descripcionController,
                maxLines: 4,
                validator: (value) => 
                    value == null || value.isEmpty 
                        ? 'Campo requerido' 
                        : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description, color: Colors.blue),
                  labelText: "Descripción",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              TextFormField(
                controller: asignaturaController,
                validator: (value) => 
                    value == null || value.isEmpty 
                        ? 'Campo requerido' 
                        : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.school, color: Colors.blue),
                  labelText: "Asignatura",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              TextFormField(
                controller: tipoNotificacionController,
                validator: (value) => 
                    value == null || value.isEmpty 
                        ? 'Campo requerido' 
                        : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category, color: Colors.blue),
                  labelText: "Tipo de Notificación",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Ej: Tarea, Examen, Recordatorio",
                ),
              ),
              SizedBox(height: 20),
              
              TextFormField(
                controller: fechaHoraController,
                readOnly: true,
                onTap: () async {
                  await _seleccionarFecha(context);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                  labelText: "Fecha y Hora",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final fechaHora = DateTime(
                      fechaSeleccionada.year,
                      fechaSeleccionada.month,
                      fechaSeleccionada.day,
                      horaSeleccionada.hour,
                      horaSeleccionada.minute,
                    );
                    
                    final nuevaNotificacion = Notificacion(
                      id: esEdicion ? notificacion!.id : null,
                      titulo: tituloController.text,
                      descripcion: descripcionController.text,
                      tipo: tipoNotificacionController.text,
                      asignatura: asignaturaController.text,
                      fechaHora: fechaHora,
                    );
                    
                    try {
                      if (esEdicion) {
                        await NotificacionRepository.update(nuevaNotificacion);
                      } else {
                        await NotificacionRepository.insert(nuevaNotificacion);
                      }
                      
                      if (mounted) {
                        Navigator.pop(context, true);
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al guardar: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 36, 92, 197),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  esEdicion ? 'Actualizar' : 'Guardar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
