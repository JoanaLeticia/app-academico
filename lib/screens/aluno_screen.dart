import 'package:flutter/material.dart';
import '../models/aluno_model.dart';
import '../services/aluno_service.dart';

class AlunoScreen extends StatefulWidget {
  @override
  _AlunoScreenState createState() => _AlunoScreenState();
}

class _AlunoScreenState extends State<AlunoScreen> {
  final AlunoService _service = AlunoService();
  late Future<List<AlunoModel>> _alunos;

  @override
  void initState() {
    super.initState();
    _alunos = _service.fetchAlunos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Alunos')),
      body: FutureBuilder<List<AlunoModel>>(
        future: _alunos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final alunos = snapshot.data!;
            return ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(alunos[index].name),
                  subtitle: Text(alunos[index].email),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
