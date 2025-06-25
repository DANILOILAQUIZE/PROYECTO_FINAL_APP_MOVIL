import 'package:flutter/material.dart';

import '../../entities/tareas_entity.dart';
import '../../repositories/tareas_repository.dart';


class TareaListScreen extends StatefulWidget {
  const TareaListScreen({super.key});

  @override
  State<TareaListScreen> createState() => _TareaListScreen();
}

class _TareaListScreen extends State<TareaListScreen> {
  late Future<List<Tareas>> _listTareas;
  //llamar un estado inical de carga
  @override
  void initState() {
    super.initState();
    _loadTareas();
  }

  //cargar datos
  void _loadTareas() {
    _listTareas = TareaRepository.list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listado de Tareas")),
      body: FutureBuilder<List<Tareas>>(
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
                return ListTile(
                  title: Text(tarea.materiaid),
                  subtitle: Text(
                    "Tema: ${tarea.tema} -> Descripción: ${tarea.descripcion} -> Fecha Entrega: ${tarea.fechaentrega} -> Estado: ${tarea.estado.toStringAsFixed(0)}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/tareas/form",
                            arguments: tarea,
                          ).then(
                            (_) => setState(() {
                              _loadTareas();
                            }),
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.orange),
                      ),
                      IconButton(
                        onPressed: () => eliminar(tarea),
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/tareas/form").then(
            (_) => setState(() {
              _loadTareas();
            }),
          );
        },
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
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
