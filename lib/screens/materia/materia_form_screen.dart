import 'package:flutter/material.dart';

import '../../entities/materia_entity.dart';
import '../../repositories/materia_repository.dart';

class MateriasFormScreen extends StatefulWidget {
  const MateriasFormScreen({super.key});

  @override
  State<MateriasFormScreen> createState() => _MateriasFormScreenState();
}

class _MateriasFormScreenState extends State<MateriasFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final codigoController = TextEditingController();
  final descripcionController = TextEditingController();
  final horaController = TextEditingController();
  final semestreController = TextEditingController();

  Materia? materia;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Materia) {
      materia = args;
      nombreController.text = materia!.nombre;
      codigoController.text = materia!.codigo.toString();
      descripcionController.text = materia!.descripcion;
      horaController.text = materia!.horas.toString();
      semestreController.text = materia!.semestre;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          materia == null
              ? "Insertar Materia"
              : "Actualizar ${materia!.nombre}",
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
                controller: nombreController,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.school, color: Colors.blue),
                  labelText: "Nombre de la Materia",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: codigoController,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.numbers, color: Colors.blue),
                  labelText: "Código de la Materia",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: descripcionController,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description, color: Colors.blue),
                  labelText: "Descripción de la Materia",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // texto
              TextFormField(
                controller: horaController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final hora = int.tryParse(value ?? "");
                  if (hora == null || hora <= 0) {
                    return "Horas incorrectas";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.access_time, color: Colors.blue),
                  labelText: "Horas semanales",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 25),
              // Campo Semestre
              TextFormField(
                controller: semestreController,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                  labelText: "Semestre",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // boton guardar
              ElevatedButton(onPressed: saveMateria, child: Text("Guardar")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveMateria() async {
    if (formKey.currentState!.validate()) {
      final nuevaMateria = Materia(
        id: materia?.id,
        nombre: nombreController.text,
        codigo: int.tryParse(codigoController.text) ?? 0,
        descripcion: descripcionController.text,
        horas: int.tryParse(horaController.text) ?? 0,
        semestre: semestreController.text,
      );

      if (materia == null) {
        await MateriaRepository.insert(nuevaMateria);
      } else {
        await MateriaRepository.update(nuevaMateria);
      }

      Navigator.pop(context);
    }
  }
}
