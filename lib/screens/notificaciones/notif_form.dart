import 'package:flutter/material.dart';
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

  Notificacion? notificacion;
  bool esEdicion = false;
  DateTime fechaSeleccionada = DateTime.now();

  // Campos para prioridad y categoría
  String prioridadSeleccionada = 'media';
  String categoriaSeleccionada = 'trabajo';

  final List<String> prioridades = ['alta', 'importante', 'media', 'baja'];
  final List<String> categorias = ['trabajo', 'personal', 'estudio'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    
    // Verificar si viene una fecha seleccionada del calendario
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey('selectedDate')) {
        fechaSeleccionada = args['selectedDate'] as DateTime;
      }
    }
    // Verificar si es edición de una notificación existente
    else if (args != null && args is Notificacion) {
      notificacion = args;
      esEdicion = true;

      tituloController.text = notificacion!.titulo;
      descripcionController.text = notificacion!.descripcion;
      prioridadSeleccionada = notificacion!.prioridad;
      categoriaSeleccionada = notificacion!.categoria;
      fechaSeleccionada = notificacion!.fecha;
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  InputDecoration customInputDecoration(IconData icon, String label) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blue),
      labelText: label,
      labelStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
      filled: true,
      fillColor: Colors.blue.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.blue, width: 2.5),
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
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        readOnly: onTap != null,
      ),
    );
  }

  Widget buildDropdownField(
    String valorSeleccionado,
    List<String> opciones,
    IconData icon,
    String label,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: DropdownButtonFormField<String>(
        decoration: customInputDecoration(icon, label),
        value: valorSeleccionado,
        onChanged: onChanged,
        items:
            opciones
                .map(
                  (opcion) => DropdownMenuItem<String>(
                    child: Text(opcion),
                    value: opcion,
                  ),
                )
                .toList(),
      ),
    );
  }

  Color _getPrioridadColor(String prioridad) {
    switch (prioridad) {
      case 'alta':
        return Colors.red;
      case 'importante':
        return Colors.orange;
      case 'media':
        return Colors.yellow;
      case 'baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoriaColor(String categoria) {
    switch (categoria) {
      case 'trabajo':
        return Colors.blue;
      case 'personal':
        return Colors.purple;
      case 'estudio':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          notificacion == null ? 'Crear Notificación' : 'Editar Notificación',
        ),
        backgroundColor: Colors.blue,
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
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),

              buildTextField(
                descripcionController,
                Icons.description,
                "Descripción",
                maxLines: 4,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),

              buildDropdownField(
                prioridadSeleccionada,
                prioridades,
                Icons.priority_high,
                "Prioridad",
                (String? newValue) {
                  setState(() {
                    prioridadSeleccionada = newValue!;
                  });
                },
              ),

              buildDropdownField(
                categoriaSeleccionada,
                categorias,
                Icons.category,
                "Categoría",
                (String? newValue) {
                  setState(() {
                    categoriaSeleccionada = newValue!;
                  });
                },
              ),

              // Vista previa de la notificación
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vista Previa:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getPrioridadColor(prioridadSeleccionada),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            prioridadSeleccionada.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoriaColor(categoriaSeleccionada),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            categoriaSeleccionada.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tituloController.text.isEmpty
                          ? 'Título de la notificación'
                          : tituloController.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descripcionController.text.isEmpty
                          ? 'Descripción de la notificación'
                          : descripcionController.text,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // Mostrar información de depuración
                    print('=== DEBUG: Creando nueva notificación ===');
                    print('Título: ${tituloController.text}');
                    print('Fecha seleccionada: $fechaSeleccionada');
                    print('Tipo de fecha: ${fechaSeleccionada.runtimeType}');
                    
                    final nuevaNotificacion = Notificacion(
                      id: esEdicion ? notificacion!.id : null,
                      titulo: tituloController.text,
                      descripcion: descripcionController.text,
                      prioridad: prioridadSeleccionada,
                      categoria: categoriaSeleccionada,
                      fecha: fechaSeleccionada,
                    );
                    
                    print('Notificación a guardar: ${nuevaNotificacion.toMap()}');

                    try {
                      if (esEdicion) {
                        await NotificacionRepository.update(nuevaNotificacion);
                      } else {
                        await NotificacionRepository.insert(nuevaNotificacion);
                      }

                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al guardar la notificación: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                  shadowColor: Colors.blue.shade200,
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
