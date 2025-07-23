import 'package:flutter/material.dart';

import '../../entities/materia_entity.dart';
import '../../repositories/materia_repository.dart';
import '../bottom_app_bar.dart';

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

  MateriaEntity? materia;
  int? periodoId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is MateriaEntity) {
      materia = args;
      periodoId = materia!.fkPeriodoId;
      nombreController.text = materia!.nombre;
      codigoController.text = materia!.codigo.toString();
      descripcionController.text = materia!.descripcion;
      horaController.text = materia!.horas.toString();
      semestreController.text = materia!.semestre;
    } else if (args != null && args is int) {
      periodoId = args;
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

  Widget buildTextField(
    TextEditingController controller,
    IconData icon,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: customInputDecoration(icon, label),
        style: TextStyle(
          color: Colors.indigo.shade900,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
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
          materia == null ? "Insertar Materia" : "Editar ${materia!.nombre}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomFooter(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              buildTextField(
                nombreController,
                Icons.school,
                "Nombre de la Materia",
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              buildTextField(
                codigoController,
                Icons.confirmation_number,
                "Código de la Materia",
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              buildTextField(
                descripcionController,
                Icons.description,
                "Descripción de la Materia",
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              buildTextField(
                horaController,
                Icons.access_time,
                "Horas semanales",
                keyboardType: TextInputType.number,
                validator: (value) {
                  final hora = int.tryParse(value ?? "");
                  if (hora == null || hora <= 0) return "Horas incorrectas";
                  return null;
                },
              ),
              buildTextField(
                semestreController,
                Icons.calendar_today,
                "Semestre",
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveMateria,
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveMateria() async {
    if (formKey.currentState!.validate()) {
      if (periodoId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: No se asignó un periodo.")),
        );
        return;
      }

      final nuevaMateria = MateriaEntity(
        id: materia?.id,
        nombre: nombreController.text,
        codigo: int.tryParse(codigoController.text) ?? 0,
        descripcion: descripcionController.text,
        horas: int.tryParse(horaController.text) ?? 0,
        semestre: semestreController.text,
        fkPeriodoId: periodoId!,
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
