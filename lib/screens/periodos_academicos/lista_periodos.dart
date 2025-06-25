import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../entities/periodo_entity.dart';
import '../../repositories/periodo_repository.dart';

class PeriodosScreen extends StatefulWidget {
  const PeriodosScreen({super.key});

  @override
  State<PeriodosScreen> createState() => _PeriodosScreenState();
}

class _PeriodosScreenState extends State<PeriodosScreen> {
  late Future<List<PeriodoEntity>> listPeriodos;
  @override
  void initState() {
    super.initState();
    _loadPeriodos();
  }

  void _loadPeriodos() {
    listPeriodos = PeriodoRepository.list();
  }

  Future<void> eliminarPeriodo(PeriodoEntity periodo) async {
    final respuesta = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de eliminar el periodo ${periodo.nombre}?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    if (respuesta == true) {
      await PeriodoRepository.delete(periodo);
      setState(() {
        _loadPeriodos();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Productos')),
      body: FutureBuilder<List<PeriodoEntity>>(
        future: listPeriodos,
        builder: (context, snapshot) {
          // validar si esta aun consultando los datos
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // validar si hubo un error
          else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los periodos. ${snapshot.error}'),
            );
          }
          // validar si consulta OK pero no hay datos
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos'));
          }
          // validar si consulta OK y hay datos
          else {
            final periodos = snapshot.data!;
            return ListView.builder(
              itemCount: periodos.length,
              itemBuilder: (context, index) {
                final periodo = periodos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(periodo.nombre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Fecha Inicio: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(periodo.fechaInicio))}"),
                        Text("Fecha Fin: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(periodo.fechaFin))}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.pushNamed(context, '/agregarPeriodo', arguments: periodo)
                            .then((_) => setState(() {
                              _loadPeriodos();
                            }));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            eliminarPeriodo(periodo);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushNamed(context, '/agregarPeriodo')
          .then((_) => setState(() {
            _loadPeriodos();
          }));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
