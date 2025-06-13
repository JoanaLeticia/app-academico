class DisciplinaCursada {
  final int id;
  final int alunoId;
  final int disciplinaId;

  DisciplinaCursada({
    required this.id,
    required this.alunoId,
    required this.disciplinaId,
  });

  factory DisciplinaCursada.fromJson(Map<String, dynamic> json) {
    return DisciplinaCursada(
      id: json['id'],
      alunoId: json['alunoId'],
      disciplinaId: json['disciplinaId'],
    );
  }
}
