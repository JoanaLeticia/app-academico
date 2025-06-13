class Disciplina {
  final int id;
  final String codigo;
  final String nome;
  final int periodo;
  final int cargaHoraria;
  final int cursoId;

  Disciplina({
    required this.id,
    required this.codigo,
    required this.nome,
    required this.periodo,
    required this.cargaHoraria,
    required this.cursoId,
  });

  factory Disciplina.fromJson(Map<String, dynamic> json) {
    return Disciplina(
      id: json['id'],
      codigo: json['codigo'],
      nome: json['nome'],
      periodo: json['periodo'],
      cargaHoraria: json['cargaHoraria'],
      cursoId: json['cursoId'],
    );
  }

  factory Disciplina.erro() {
    return Disciplina(id: 0, codigo: '-', nome: 'Não encontrada', periodo: 0, cargaHoraria: 0, cursoId: 0);
  }
}
