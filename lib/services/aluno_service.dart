import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/aluno_model.dart';

class AlunoService {
  final String baseUrl = "http://localhost:3000"; // ou seu IP local + porta da API

  Future<List<AlunoModel>> fetchAlunos() async {
    final response = await http.get(Uri.parse('$baseUrl/alunos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AlunoModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar alunos');
    }
  }
}
