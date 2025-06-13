class EntregaDocumentoAluno {
  final int documentoId;
  final int alunoId;
  final bool entregue;

  EntregaDocumentoAluno({
    required this.documentoId,
    required this.alunoId,
    required this.entregue,
  });

  factory EntregaDocumentoAluno.fromJson(Map<String, dynamic> json) {
    return EntregaDocumentoAluno(
      documentoId: json['documentoId'],
      alunoId: json['alunoId'],
      entregue: json['entregue'],
    );
  }
}
