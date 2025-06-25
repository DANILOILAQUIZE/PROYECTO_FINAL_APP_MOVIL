import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../entities/periodo_entity.dart';
import '../../repositories/periodo_repository.dart';

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
      fechaInicioController.text = DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(periodo!.fechaInicio));
      fechaFinController.text = DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(periodo!.fechaFin));
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(periodo == null ? 'Crear Periodo' : 'Editar Periodo'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  validator: (value) => value == null || value.isEmpty ? 'El nombre es requerido' : null,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    prefixIconColor: Colors.green,
                    labelText: 'Nombre del Periodo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: fechaInicioController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fecha de inicio es requerida';
                    }
                    try {
                      DateFormat('dd/MM/yyyy').parse(value);
                      return null;
                    } catch (e) {
                      return 'Formato de fecha inválido. Use dd/MM/yyyy';
                    }
                  },
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.date_range),
                    prefixIconColor: Colors.green,
                    labelText: 'Fecha de Inicio',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        fechaInicioController.text = DateFormat('dd/MM/yyyy').format(picked);
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: fechaFinController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fecha de fin es requerida';
                    }
                    try {
                      DateFormat('dd/MM/yyyy').parse(value);
                      return null;
                    } catch (e) {
                      return 'Formato de fecha inválido. Use dd/MM/yyyy';
                    }
                  },
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.date_range),
                    prefixIconColor: Colors.green,
                    labelText: 'Fecha de Fin',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        fechaFinController.text = DateFormat('dd/MM/yyyy').format(picked);
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descripcionController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    prefixIconColor: Colors.green,
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text('¿Es el periodo actual?'),
                  value: activo,
                  onChanged: (bool? value) {
                    setState(() {
                      activo = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: savePeriodo,
                  child: Text(periodo == null ? 'Guardar' : 'Actualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
