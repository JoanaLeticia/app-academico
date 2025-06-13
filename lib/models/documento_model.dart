class Documento {
  final int id;
  final String nome;
  final bool entregue;

  Documento({
    required this.id,
    required this.nome,
    required this.entregue,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'],
      nome: json['nome'],
      entregue: json['entregue'],
    );
  }
}
