import 'package:flutter/material.dart';
import '../../entities/materia_entity.dart';
import '../../repositories/materia_repository.dart';
import '../app_bar.dart';
import '../bottom_app_bar.dart';
import '../drawer.dart';

class MateriaListScreen extends StatefulWidget {
  const MateriaListScreen({super.key});

  @override
  State<MateriaListScreen> createState() => _MateriaListScreenState();
}

class _MateriaListScreenState extends State<MateriaListScreen> {
  late Future<List<MateriaEntity>> _listMaterias;
  int? _periodoId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recibir el ID del periodo desde la navegación
    _periodoId = ModalRoute.of(context)?.settings.arguments as int?;

    if (_periodoId != null) {
      _loadMaterias();
    }
  }

  void _loadMaterias() {
    _listMaterias = MateriaRepository.getByPeriodoId(_periodoId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: "Materias"),
      bottomNavigationBar: const BottomFooter(),
      body:
          _periodoId == null
              ? Center(child: Text("No se recibió ID del periodo."))
              : FutureBuilder<List<MateriaEntity>>(
                future: _listMaterias,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No existen materias registradas para este periodo.",
                      ),
                    );
                  } else {
                    final materias = snapshot.data!;
                    return ListView.builder(
                      itemCount: materias.length,
                      itemBuilder: (context, index) {
                        final materia = materias[index];
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
                                '/gestionTareas',
                                arguments: materia.id,
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
                                          materia.nombre,
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
                                          "Código: ${materia.codigo}",
                                          style: TextStyle(
                                            color: Colors.indigo.shade400,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Semestre: ${materia.semestre}",
                                          style: TextStyle(
                                            color: Colors.indigo.shade400,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Horas: ${materia.horas}",
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
                                              "/materias/form",
                                              arguments:
                                                  materia, // <-- pasas la entidad completa
                                            ).then((_) {
                                              setState(() {
                                                _loadMaterias();
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
                                          onPressed: () => eliminar(materia),
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
          if (_periodoId != null) {
            Navigator.pushNamed(
              context,
              "/materias/form",
              arguments: _periodoId,
            ).then((_) {
              setState(() {
                _loadMaterias();
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
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> eliminar(MateriaEntity materia) async {
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
