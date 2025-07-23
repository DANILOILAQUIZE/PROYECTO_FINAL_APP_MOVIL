import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../entities/tareas_entity.dart';
import '../../repositories/tareas_repository.dart';

class TareaFormScreen extends StatefulWidget {
  const TareaFormScreen({super.key});

  @override
  State<TareaFormScreen> createState() => _TareaFormScreenState();
}

class _TareaFormScreenState extends State<TareaFormScreen> {
  final formKey = GlobalKey<FormState>();
  final temaController = TextEditingController();
  final descripcionController = TextEditingController();
  final fechaentregaController = TextEditingController();
  final horaentregaController = TextEditingController();
  final estadoController = TextEditingController();
  int? fkMateriaId;
  Tareas? t;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); // heredas las configuraciones
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Tareas) {
      // llenar las cajas de texto
      t = args;
      temaController.text = t!.tema;
      descripcionController.text = t!.descripcion;
      horaentregaController.text = t!.horaentrega;
      estadoController.text = t!.estado;
      fechaentregaController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(t!.fechaentrega));

      fkMateriaId = t!.fkMateriaId;
    } else if (args is int) {
      fkMateriaId = args;
    }
  }

  InputDecoration customInputDecoration(IconData icon, String label) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.indigo.shade400),
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.indigo.shade400,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.indigo.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.indigo.shade100, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.indigo.shade300, width: 2.5),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade600,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          t == null ? "Insertar tarea" : "Actualizar ${t!.tema}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
          reverse: true,
          child: Form(
            key: formKey,
            child: Expanded(
              child: Column(
                children: [
                  TextFormField(
                    controller: temaController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'campo requerido'
                                : null,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.title),
                      suffixIconColor: Colors.indigo.shade600,
                      labelText: "Tema",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 25),
                  TextFormField(
                    controller: descripcionController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'campo requerido'
                                : null,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.description),
                      suffixIconColor: Colors.indigo.shade600,
                      labelText: "Descripción",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 25),

                  TextFormField(
                    controller: fechaentregaController,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido';
                      }
                      try {
                        DateFormat('dd/MM/yyyy').parse(value);
                        return null;
                      } catch (e) {
                        return 'Formato inválido. Use dd/MM/yyyy';
                      }
                    },
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          fechaentregaController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(picked);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                      suffixIconColor: Colors.indigo.shade600,
                      labelText: "Fecha de entrega",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 25),
                  TextFormField(
                    controller: horaentregaController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'campo requerido'
                                : null,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.access_time),
                      suffixIconColor: Colors.indigo.shade600,
                      labelText: "Hora de entrega",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 25),
                  DropdownButtonFormField<String>(
                    value:
                        estadoController.text.isEmpty
                            ? null
                            : estadoController.text,
                    items: const [
                      DropdownMenuItem(
                        value: 'Pendiente',
                        child: Text('Pendiente'),
                      ),
                      DropdownMenuItem(
                        value: 'Finalizado',
                        child: Text('Finalizado'),
                      ),
                      DropdownMenuItem(
                        value: 'En proceso',
                        child: Text('En proceso'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        estadoController.text = value ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleccione un estado';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIconColor: Colors.indigo.shade600,
                      labelText: "Estado",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 30),

                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: saveTarea,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                        shadowColor: Colors.indigo.shade200,
                      ),
                      child: const Text(
                        "Guardar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveTarea() async {
    //valida las cajas de texto  dentro del formulario
    if (formKey.currentState!.validate()) {
      final formato = DateFormat('dd/MM/yyyy');
      try {
        final fechaentrega = formato.parse(fechaentregaController.text);
        final tarea = Tareas(
          id: t?.id,
          tema: temaController.text,
          descripcion: descripcionController.text,
          fechaentrega: fechaentrega.millisecondsSinceEpoch,
          horaentrega: horaentregaController.text,
          estado: estadoController.text,
          fkMateriaId: fkMateriaId!,
        );
        if (tarea.id != null) {
          await TareaRepository.update(tarea);
        } else {
          await TareaRepository.insert(tarea);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingrese fechas válidas')),
        );
      }
    }
  }
}
