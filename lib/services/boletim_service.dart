import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/boletim_model.dart';

class BoletimService {
  final String baseUrl = "http://localhost:3000";

  Future<Boletim?> getBoletimDoAluno(int alunoId) async {
    final response = await http.get(Uri.parse('$baseUrl/boletins?alunoId=$alunoId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.length > 0) {
        return Boletim.fromJson(data[0]);
      }
    }
    return null;
  }
}
