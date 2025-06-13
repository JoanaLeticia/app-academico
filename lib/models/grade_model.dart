class GradeCurricular {
  final int id;
  final int cursoId;
  final int periodo;
  final List<int> disciplinaIds;

  GradeCurricular({
    required this.id,
    required this.cursoId,
    required this.periodo,
    required this.disciplinaIds,
  });

  factory GradeCurricular.fromJson(Map<String, dynamic> json) {
    return GradeCurricular(
      id: json['id'],
      cursoId: json['cursoId'],
      periodo: json['periodo'],
      disciplinaIds: List<int>.from(json['disciplinas']),
    );
  }
}