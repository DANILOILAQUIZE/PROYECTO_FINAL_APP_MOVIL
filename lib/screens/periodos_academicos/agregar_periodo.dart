import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../entities/periodo_entity.dart';
import '../../repositories/periodo_repository.dart';
import '../bottom_app_bar.dart';

class AgregarPeriodoScreen extends StatefulWidget {
  const AgregarPeriodoScreen({super.key});

  @override
  State<AgregarPeriodoScreen> createState() => _AgregarPeriodoScreenState();
}

class _AgregarPeriodoScreenState extends State<AgregarPeriodoScreen> {
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final fechaInicioController = TextEditingController();
  final fechaFinController = TextEditingController();
  final descripcionController = TextEditingController();

  PeriodoEntity? periodo;
  bool activo = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is PeriodoEntity) {
      periodo = args;
      nombreController.text = periodo!.nombre;
      fechaInicioController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(periodo!.fechaInicio));
      fechaFinController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(periodo!.fechaFin));
      descripcionController.text = periodo!.descripcion ?? '';
      activo = periodo!.activo;
    }
    super.didChangeDependencies();
  }

  Future<void> savePeriodo() async {
    if (formKey.currentState!.validate()) {
      final formato = DateFormat('dd/MM/yyyy');
      try {
        final fechaInicio = formato.parse(fechaInicioController.text);
        final fechaFin = formato.parse(fechaFinController.text);

        final periodo = PeriodoEntity(
          id: this.periodo?.id,
          nombre: nombreController.text,
          fechaInicio: fechaInicio.millisecondsSinceEpoch,
          fechaFin: fechaFin.millisecondsSinceEpoch,
          activo: activo,
          descripcion: descripcionController.text,
        );

        if (periodo.id == null) {
          await PeriodoRepository.insert(periodo);
        } else {
          await PeriodoRepository.update(periodo);
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingrese fechas válidas')),
        );
      }
    }
  }
    InputDecoration customInputDecoration(IconData icon, String label) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.deepPurple.shade400),
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.deepPurple,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.deepPurple.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.deepPurple.shade100, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2.5),
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
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,  // Move onTap here
      decoration: customInputDecoration(icon, label),
      style: TextStyle(
        color: Colors.deepPurple,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      readOnly: onTap != null,  // Keep this to prevent keyboard from showing
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(periodo == null ? 'Crear Periodo' : 'Editar Periodo'),
        backgroundColor: Colors.blue,
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
                Icons.calendar_today,
                "Nombre del Periodo",
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              buildTextField(
                fechaInicioController,
                Icons.date_range,
                "Fecha de Inicio (dd/MM/yyyy)",
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
                      fechaInicioController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(picked);
                    });
                  }
                },
              ),
              buildTextField(
                fechaFinController,
                Icons.date_range,
                "Fecha de Fin (dd/MM/yyyy)",
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
                      fechaFinController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(picked);
                    });
                  }
                },
              ),
              buildTextField(
                descripcionController,
                Icons.description,
                "Descripción",
              ),
              CheckboxListTile(
                title: const Text('¿Es el periodo actual?'),
                value: activo,
                onChanged: (bool? value) {
                  setState(() {
                    activo = value ?? false;
                  });
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: savePeriodo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                  shadowColor: Colors.indigo.shade200,
                ),
                child: Text(
                  periodo == null ? 'Guardar' : 'Actualizar',
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
