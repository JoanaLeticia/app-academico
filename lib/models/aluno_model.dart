class AlunoModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final int cursoId;
  final String matricula;
  final int periodoAtual;

  AlunoModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.cursoId,
    required this.matricula,
    required this.periodoAtual,
  });

  factory AlunoModel.fromJson(Map<String, dynamic> json) {
    return AlunoModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      cursoId: json['cursoId'], // já é int no JSON
      matricula: json['matricula'],
      periodoAtual: json['periodoAtual'], // também é int
    );
  }
}
