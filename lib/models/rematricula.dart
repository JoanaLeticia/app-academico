class Rematricula {
  final String id;
  final String alunoId;
  final List<String> disciplinasSelecionadas;
  final DateTime dataSolicitacao;
  final String semestre;
  final String status;

  Rematricula({
    required this.id,
    required this.alunoId,
    required this.disciplinasSelecionadas,
    required this.dataSolicitacao,
    required this.semestre,
    required this.status,
  });
}