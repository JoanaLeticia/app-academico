class Nota {
  final String codigo;
  final String nome;
  final int faltas;
  final double a1;
  final double a2;
  final double exameFinal;
  final double mediaSemestral;
  final double mediaFinal;
  final String situacao;

  Nota({
    required this.codigo,
    required this.nome,
    required this.faltas,
    required this.a1,
    required this.a2,
    required this.exameFinal,
    required this.mediaSemestral,
    required this.mediaFinal,
    required this.situacao,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      codigo: json['codigo'],
      nome: json['nome'],
      faltas: json['faltas'],
      a1: (json['a1'] as num).toDouble(),
      a2: (json['a2'] as num).toDouble(),
      exameFinal: (json['exameFinal'] as num).toDouble(),
      mediaSemestral: (json['mediaSemestral'] as num).toDouble(),
      mediaFinal: (json['mediaFinal'] as num).toDouble(),
      situacao: json['situacao'],
    );
  }
}
