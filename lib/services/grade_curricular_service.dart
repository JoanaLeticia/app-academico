import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/disciplina_model.dart';
import '../models/grade_model.dart';

class GradeCurricularService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<GradeCurricular>> getGradesPorCurso(int cursoId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/gradesCurriculares?cursoId=$cursoId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => GradeCurricular.fromJson(e)).toList();
      } else {
        throw Exception('Falha ao carregar grades. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}