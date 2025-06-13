import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/aluno_model.dart';

class AuthService {
  final String baseUrl = "http://localhost:3000";

  Future<AlunoModel?> login(String ra, String senha) async {
    final response = await http.get(Uri.parse('$baseUrl/alunos?email=$ra&senha=$senha'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.length > 0) {
        return AlunoModel.fromJson(data[0]);
      }
    }
    return null;
  }
}
