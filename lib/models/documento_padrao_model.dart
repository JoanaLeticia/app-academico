class DocumentoPadrao {
  final int id;
  final String nome;
  final bool obrigatorio;

  DocumentoPadrao({
    required this.id,
    required this.nome,
    required this.obrigatorio,
  });

  factory DocumentoPadrao.fromJson(Map<String, dynamic> json) {
    return DocumentoPadrao(
      id: json['id'],
      nome: json['nome'],
      obrigatorio: json['obrigatorio'],
    );
  }
}
