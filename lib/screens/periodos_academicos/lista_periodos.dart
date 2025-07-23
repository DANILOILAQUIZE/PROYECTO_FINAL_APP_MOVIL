import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../entities/periodo_entity.dart';
import '../../repositories/periodo_repository.dart';
import '../app_bar.dart';
import '../bottom_app_bar.dart';
import '../drawer.dart';

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
          content: Text(
            '¿Estás seguro de eliminar el periodo ${periodo.nombre}?',
          ),
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
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: "Periodos Académicos"),
      bottomNavigationBar: const BottomFooter(),
      body: FutureBuilder<List<PeriodoEntity>>(
        future: listPeriodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los periodos. ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos'));
          } else {
            final periodos = snapshot.data!;
            return ListView.builder(
              itemCount: periodos.length,
              itemBuilder: (context, index) {
                final periodo = periodos[index];
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.indigo.shade50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/gestionMaterias',
                        arguments: periodo.id,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.indigo.withOpacity(0.15),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.date_range,
                                  color: Colors.indigo.shade700,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  periodo.nombre,
                                  style: TextStyle(
                                    color: Colors.indigo.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Inicio: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(periodo.fechaInicio))}",
                                  style: TextStyle(
                                    color: Colors.indigo.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Fin: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(periodo.fechaFin))}",
                                  style: TextStyle(
                                    color: Colors.indigo.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/agregarPeriodo',
                                      arguments: periodo,
                                    ).then((_) {
                                      setState(() {
                                        _loadPeriodos();
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.green.shade700,
                                  ),
                                  tooltip: 'Editar',
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: () => eliminarPeriodo(periodo),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade700,
                                  ),
                                  tooltip: 'Eliminar',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushNamed(context, '/agregarPeriodo').then(
            (_) => setState(() {
              _loadPeriodos();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
