import 'dart:convert';
import 'package:app_academico/models/boletim_model.dart';
import 'package:http/http.dart' as http;
import '../models/disciplina_model.dart';
import '../models/disciplina_cursada_model.dart';

class AnaliseCurricularService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Disciplina>> getDisciplinasCurso(int cursoId) async {
    final response = await http.get(Uri.parse('$baseUrl/disciplinas?cursoId=$cursoId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Disciplina.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar disciplinas do curso');
    }
  }

  Future<List<DisciplinaCursada>> getDisciplinasCursadas(int alunoId) async {
    final response = await http.get(Uri.parse('$baseUrl/disciplinasCursadas?alunoId=$alunoId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => DisciplinaCursada.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar disciplinas cursadas');
    }
  }

  Future<Boletim> getBoletimComNotas(int alunoId) async {
    final response = await http.get(Uri.parse('$baseUrl/boletins?alunoId=$alunoId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      if (data.isNotEmpty) {
        return Boletim.fromJson(data.first); // Assume que só há um boletim por aluno
      } else {
        throw Exception('Nenhum boletim encontrado para o aluno');
      }
    } else {
      throw Exception('Erro ao carregar boletim');
    }
  }
}
