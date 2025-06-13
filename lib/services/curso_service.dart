import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/aluno_model.dart';
import '../models/curso_model.dart';

class CursoService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Curso>> getCursosDoAluno(AlunoModel aluno) async {
    final response = await http.get(Uri.parse('$baseUrl/cursos'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data
          .where((curso) => curso['id'] == aluno.cursoId)
          .map((e) => Curso.fromJson(e))
          .toList();
    } else {
      throw Exception('Erro ao buscar cursos');
    }
  }
}
