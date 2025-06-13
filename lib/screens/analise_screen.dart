import 'package:app_academico/models/curso_model.dart';
import 'package:app_academico/services/analise_service.dart';
import 'package:app_academico/services/curso_service.dart';
import 'package:app_academico/widgets/app_top_bar.dart';
import 'package:app_academico/widgets/rodape_widget.dart';
import 'package:flutter/material.dart';
import '../models/aluno_model.dart';
import '../models/disciplina_model.dart';
import '../models/boletim_model.dart';
import '../models/nota_model.dart';

class AnaliseCurricularScreen extends StatefulWidget {
  final AlunoModel aluno;

  const AnaliseCurricularScreen({super.key, required this.aluno});

  @override
  State<AnaliseCurricularScreen> createState() => _AnaliseCurricularScreenState();
}

class _AnaliseCurricularScreenState extends State<AnaliseCurricularScreen> {
  final _service = AnaliseCurricularService();
  final _cursoService = CursoService();

  List<Disciplina> _todas = [];
  Boletim? _boletim;
  Curso? _curso;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final todas = await _service.getDisciplinasCurso(widget.aluno.cursoId);
    final boletim = await _service.getBoletimComNotas(widget.aluno.id);
    final cursos = await _cursoService.getCursosDoAluno(widget.aluno);

    setState(() {
      _todas = todas;
      _boletim = boletim;
      _curso = cursos.isNotEmpty ? cursos.first : null;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando || _boletim == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Análise Curricular')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final disciplinasComNotas = _todas.map((disc) {
      Nota? nota;
      try {
        nota = _boletim!.disciplinas.firstWhere((n) => n.codigo == disc.codigo);
      } catch (e) {
        nota = null;
      }
      return {
        'disciplina': disc,
        'nota': nota,
      };
    }).toList();

    final total = disciplinasComNotas.length;
    final concluidas = disciplinasComNotas.where((e) => e['nota'] != null).toList();
    final pendentes = disciplinasComNotas.where((e) => e['nota'] == null).toList();
    final porcentagem = total > 0 ? (concluidas.length / total) : 0;

    final disciplinasPorPeriodo = <int, List<Map<String, dynamic>>>{};
    for (var item in disciplinasComNotas) {
      final Disciplina disc = item['disciplina'] as Disciplina;
      disciplinasPorPeriodo.putIfAbsent(disc.periodo, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppTopBar(nomeUsuario: widget.aluno.name),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Barra azul com título - estilo igual ao situacao_screen
            Container(
              color: const Color(0xFF004092),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'Análise Curricular',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título com barra azul ao lado - estilo igual ao situacao_screen
                  Text(
                    "Progresso",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Card A - Progresso
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 167,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Barra azul lateral
                              Container(
                                width: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF004092),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Nome do curso alinhado no topo
                                      Text(
                                        _curso?.nome ?? 'Curso não encontrado',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Espaço restante com conteúdo centralizado
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${(porcentagem * 100).toStringAsFixed(1)}%"),
                                                Text("${pendentes.length} Disciplinas restantes"),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            LinearProgressIndicator(
                                              value: porcentagem.toDouble(),
                                              backgroundColor: Colors.grey[200],
                                              color: Colors.green,
                                              minHeight: 8,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              porcentagem >= 1.0 ? "Concluído" : "Em andamento",
                                              style: TextStyle(
                                                color: porcentagem >= 1.0 ? Colors.green : Colors.orange,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Card B - Pendentes
                      Expanded(
                        child: Container(
                          height: 167, // Altura fixa
                          decoration: BoxDecoration(
                            color: Colors.yellow[50],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch, // Para a barra azul ocupar toda a altura
                            children: [
                              Container(
                                width: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF004092),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento à esquerda
                                    children: [
                                      Icon(Icons.access_time, size: 42, color: Colors.orange),
                                      const SizedBox(height: 15),
                                      Text(
                                        pendentes.length.toString(),
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Disciplinas Pendentes",
                                        style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Card C - Concluídas
                      Expanded(
                        child: Container(
                          height: 167, // Altura fixa
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch, // Para a barra azul ocupar toda a altura
                            children: [
                              Container(
                                width: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF004092),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento à esquerda
                                    children: [
                                      Icon(Icons.check_circle, size: 42, color: Colors.green),
                                      const SizedBox(height: 15),
                                      Text(
                                        concluidas.length.toString(),
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Disciplinas Concluídas",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Título com barra azul ao lado
                  Row(
                    children: [
                      Text(
                        "Lista de Disciplinas",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (var entry in disciplinasPorPeriodo.entries)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${entry.key}º Período",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                            ),
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(Colors.grey[300]),
                              columns: const [
                                DataColumn(label: Text("Código")),
                                DataColumn(label: Text("Disciplina")),
                                DataColumn(label: Text("Situação")),
                                DataColumn(label: Text("A1")),
                                DataColumn(label: Text("A2")),
                                DataColumn(label: Text("EF")),
                                DataColumn(label: Text("M. Final")),
                                DataColumn(label: Text("Faltas")),
                                DataColumn(label: Text("Créditos")),
                              ],
                              rows: entry.value.map((item) {
                                final Disciplina disc = item['disciplina'];
                                final Nota? nota = item['nota'];
                                return DataRow(cells: [
                                  DataCell(Text(disc.codigo)),
                                  DataCell(Text(disc.nome)),
                                  DataCell(Text(nota?.situacao ?? 'Pendente')),
                                  DataCell(Text(nota != null ? nota.a1.toStringAsFixed(1) : '-')),
                                  DataCell(Text(nota != null ? nota.a2.toStringAsFixed(1) : '-')),
                                  DataCell(Text(nota != null ? nota.exameFinal.toStringAsFixed(1) : '-')),
                                  DataCell(Text(nota != null ? nota.mediaFinal.toStringAsFixed(1) : '-')),
                                  DataCell(Text(nota != null ? nota.faltas.toString() : '-')),
                                  DataCell(Text(disc.cargaHoraria.toString())),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text("Voltar"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Implementar funcionalidade de impressão
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF004092),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text("Imprimir"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const RodapeWidget(),
          ],
        ),
      ),
    );
  }
}