import 'package:flutter/material.dart';
import '../../entities/tareas_entity.dart';
import '../../repositories/tareas_repository.dart';
import '../app_bar.dart';
import '../bottom_app_bar.dart';
import '../drawer.dart';
import 'package:intl/intl.dart';

class TareaListScreen extends StatefulWidget {
  const TareaListScreen({super.key});

  @override
  State<TareaListScreen> createState() => _TareaListScreen();
}

class _TareaListScreen extends State<TareaListScreen> {
  late Future<List<Tareas>> _listTareas;
  int? _materiaId;

  //llamar un estado inical de carga
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recibir el ID del periodo desde la navegación
    _materiaId = ModalRoute.of(context)?.settings.arguments as int?;

    if (_materiaId != null) {
      _loadTareas();
    }
  }

  void _loadTareas() {
    _listTareas = TareaRepository.getByMateriaId(_materiaId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: "Tareas"),
      bottomNavigationBar: const BottomFooter(),
      body:
          _materiaId == null
              ? Center(child: Text("No se recibio el Id de la Materia"))
              : FutureBuilder<List<Tareas>>(
                future: _listTareas,
                builder: (context, snapshot) {
                  //validar si aun esta consultando los datos
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  //validar si existe un error
                  else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  // validar si la consulta fue OK pero no tiene datod
                  else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No existe registros"));
                  }
                  //validar la opcion de carga de datos completa
                  else {
                    final tareas = snapshot.data!;
                    return ListView.builder(
                      itemCount: tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = tareas[index];
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
                            onTap: () {},

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
                                              color: Colors.indigo.withOpacity(
                                                0.15,
                                              ),
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.school,
                                          color: Colors.indigo.shade700,
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          tarea.tema,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Tema: ${tarea.tema}",
                                          style: TextStyle(
                                            color: Colors.indigo.shade400,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Descripcion: ${tarea.descripcion}",
                                          style: TextStyle(
                                            color: Colors.indigo.shade400,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),

                                        Text(
                                          "Estado: ${tarea.estado}",
                                          style: TextStyle(
                                            color: Colors.indigo.shade400,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Fecha Entrega: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(tarea.fechaentrega))}",
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              "/tareas/form",
                                              arguments:
                                                  tarea, // <-- pasas la entidad completa
                                            ).then((_) {
                                              setState(() {
                                                _loadTareas();
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () => eliminar(tarea),
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
        onPressed: () {
          if (_materiaId != null) {
            Navigator.pushNamed(
              context,
              "/tareas/form",
              arguments: _materiaId,
            ).then((_) {
              setState(() {
                _loadTareas();
              });
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("No se pudo obtener el periodo académico."),
              ),
            );
          }
        },
        shape: CircleBorder(),
        backgroundColor: Colors.indigo.shade600,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> eliminar(Tareas tarea) async {
    final respuesta = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Eliminar tarea?"),
            content: Text(
              "Estas seguro que deseas eliminar la tarea ${tarea.tema}?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Aceptar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("Cancelar"),
              ),
            ],
          ),
    );
    if (respuesta == true) {
      //eliminar
      await TareaRepository.delete(tarea);
      setState(() {
        _loadTareas();
      });
    }
  }
}
