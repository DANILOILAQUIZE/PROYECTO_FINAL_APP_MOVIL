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

  InputDecoration customInputDecoration(IconData icon, String label) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.orange.shade400),
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.orange.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.orange.shade100, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.orange.shade300, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    IconData icon,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLines = 1,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        onTap: onTap,
        decoration: customInputDecoration(icon, label),
        style: TextStyle(
          color: Colors.orange,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        readOnly: onTap != null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notificacion == null ? 'Crear Notificación' : 'Editar Notificación'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              buildTextField(
                tituloController,
                Icons.title,
                "Título de la Notificación",
                validator: (value) => 
                    value == null || value.isEmpty 
                        ? 'Campo requerido' 
                        : null,
              ),
              
              buildTextField(
                descripcionController,
                Icons.description,
                "Descripción",
                maxLines: 4,
                validator: (value) => 
                    value == null || value.isEmpty 
                        ? 'Campo requerido' 
                        : null,
              ),
              
              buildTextField(
                asignaturaController,
                Icons.school,
                "Asignatura",
                validator: (value) => 
                    value == null || value.isEmpty 
                        ? 'Campo requerido' 
                        : null,
              ),
              
              buildTextField(
                tipoNotificacionController,
                Icons.category,
                "Tipo de Notificación",
                validator: (value) => 
                    value == null || value.isEmpty 
                        ? 'Campo requerido' 
                        : null,
              ),
              
              buildTextField(
                fechaHoraController,
                Icons.calendar_today,
                "Fecha (dd/MM/yyyy)",
                validator: (value) => 
                    value == null || value.isEmpty 
                        ? 'Campo requerido' 
                        : null,
                onTap: () => _seleccionarFecha(context),
              ),
              
              const SizedBox(height: 30),
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
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                  shadowColor: Colors.orange.shade200,
                ),
                child: Text(
                  esEdicion ? 'Actualizar' : 'Guardar',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}