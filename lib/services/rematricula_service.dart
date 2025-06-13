import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_academico/models/disciplina_model.dart';

class RematriculaService {
  final String baseUrl = "http://localhost:3000";

  Future<List<int>> buscarDisciplinasCursadas(int alunoId) async {
    final response = await http.get(Uri.parse('$baseUrl/disciplinasCursadas?alunoId=$alunoId'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<int>((json) => json['disciplinaId'] as int).toList();
    } else {
      throw Exception('Erro ao buscar disciplinas cursadas');
    }
  }

  Future<List<Disciplina>> buscarDisciplinasParaRematricula(
      int cursoId, int periodoAtual, List<int> disciplinasCursadasIds) async {
    final response = await http.get(Uri.parse('$baseUrl/disciplinas?cursoId=$cursoId'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Disciplina.fromJson(json)).where((disciplina) {
        final eProximoPeriodo = disciplina.periodo == (periodoAtual + 1);
        final eAnteriorNaoCursada = disciplina.periodo < (periodoAtual + 1) &&
            !disciplinasCursadasIds.contains(disciplina.id);
        return eProximoPeriodo || eAnteriorNaoCursada;
      }).toList();
    } else {
      throw Exception('Erro ao buscar disciplinas');
    }
  }
}