import 'package:flutter/material.dart';
import '../../entities/materia_entity.dart';
import '../../repositories/materia_repository.dart';

class MateriaListScreen extends StatefulWidget {
  const MateriaListScreen({super.key});

  @override
  State<MateriaListScreen> createState() => _MateriaListScreenState();
}

class _MateriaListScreenState extends State<MateriaListScreen> {
  late Future<List<Materia>> _listMaterias;

  @override
  void initState() {
    super.initState();
    _loadMaterias();
  }

  void _loadMaterias() {
    _listMaterias = MateriaRepository.list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listado de Materias")),
      body: FutureBuilder<List<Materia>>(
        future: _listMaterias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No existen registros"));
          } else {
            final materias = snapshot.data!;
            return ListView.builder(
              itemCount: materias.length,
              itemBuilder: (context, index) {
                final materia = materias[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.school, color: Colors.deepPurple),
                    title: Text(materia.nombre),
                    subtitle: Text(
                      "Código: ${materia.codigo} |  Semestre: ${materia.semestre}  |  Horas: ${materia.horas}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/materias/form",
                              arguments: materia,
                            ).then((_) {
                              setState(() {
                                _loadMaterias();
                              });
                            });
                          },
                          icon: Icon(Icons.edit, color: Colors.green),
                        ),
                        IconButton(
                          onPressed: () => eliminar(materia),
                          icon: Icon(Icons.delete, color: Colors.red),
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
        onPressed: () {
          Navigator.pushNamed(context, "/materias/form").then((_) {
            setState(() {
              _loadMaterias();
            });
          });
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 31, 64, 155),
      ),
    );
  }

  Future<void> eliminar(Materia materia) async {
    final respuesta = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("¿Eliminar Materia?"),
            content: Text(
              "¿Estás seguro que deseas eliminar la materia '${materia.nombre}'?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Aceptar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancelar"),
              ),
            ],
          ),
    );

    if (respuesta == true) {
      await MateriaRepository.delete(materia);
      setState(() {
        _loadMaterias();
      });
    }
  }
}
