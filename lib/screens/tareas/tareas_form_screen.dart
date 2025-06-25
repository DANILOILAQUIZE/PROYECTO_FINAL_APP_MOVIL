import 'package:flutter/material.dart';

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
  final materiaController = TextEditingController();
  final descripcionController = TextEditingController();
  final fechaentregaController = TextEditingController();
  final horaentregaController = TextEditingController();
  final estadoController = TextEditingController();

  Tareas? t;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); // heredas las configuraciones
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Tareas) {
      // llenar las cajas de texto
      t = args;
      temaController.text = t!.tema;
      materiaController.text = t!.materiaid;
      descripcionController.text = t!.descripcion;
      fechaentregaController.text = t!.fechaentrega;
      horaentregaController.text = t!.horaentrega;
      estadoController.text = t!.estado.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t == null ? "Insertar tarea" : "Actualizar ${t!.tema}"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    suffixIcon: Icon(Icons.badge),
                    suffixIconColor: Colors.green,
                    labelText: "Tema",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: materiaController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'campo requerido'
                              : null,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    suffixIconColor: Colors.green,
                    labelText: "Materia",
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
                    suffixIcon: Icon(Icons.person),
                    suffixIconColor: Colors.green,
                    labelText: "Descripción",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: fechaentregaController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'campo requerido'
                              : null,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.school),
                    suffixIconColor: Colors.green,
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
                    suffixIcon: Icon(Icons.school),
                    suffixIconColor: Colors.green,
                    labelText: "Hora de entrega",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: estadoController,
                  validator: (value) {
                    //validar si es un numero correcto
                    final edad = int.tryParse(value ?? "");
                    if (edad == null || edad <= 0) {
                      return "Estado incorrecta";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.cake),
                    suffixIconColor: Colors.green,
                    labelText: "Estado",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 25),
                ElevatedButton(onPressed: saveTarea, child: Text("Guardar")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveTarea() async {
    //valida las cajas de texto  dentro del formulario
    if (formKey.currentState!.validate()) {
      //si no hay problemas al validar, realiza la ejecucion
      final tarea = Tareas(
        id: t?.id,
        tema: temaController.text,
        materiaid: materiaController.text,
        descripcion: descripcionController.text,
        fechaentrega: fechaentregaController.text,
        horaentrega: horaentregaController.text,
        estado: int.tryParse(estadoController.text) ?? 0,
      );
      if (tarea.id != null) {
        await TareaRepository.update(tarea);
      } else {
        await TareaRepository.insert(tarea);
      }
      Navigator.pop(context);
    }
  }
}
