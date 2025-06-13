import 'package:app_academico/models/nota_model.dart';

class Boletim {
  final int id;
  final int alunoId;
  final String periodo;
  final List<Nota> disciplinas;

  Boletim({
    required this.id,
    required this.alunoId,
    required this.periodo,
    required this.disciplinas,
  });

  factory Boletim.fromJson(Map<String, dynamic> json) {
    var lista = json['disciplinas'] as List;
    List<Nota> disciplinas = lista.map((e) => Nota.fromJson(e)).toList();

    return Boletim(
      id: json['id'],
      alunoId: json['alunoId'],
      periodo: json['periodo'],
      disciplinas: disciplinas,
    );
  }
}
