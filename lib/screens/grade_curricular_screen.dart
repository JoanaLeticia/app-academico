import 'package:app_academico/widgets/app_top_bar.dart';
import 'package:app_academico/widgets/rodape_widget.dart'; // Importe o RodapeWidget
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/aluno_model.dart';
import '../models/curso_model.dart';
import '../models/disciplina_model.dart';

class GradeCurricularScreen extends StatefulWidget {
  final AlunoModel aluno;

  const GradeCurricularScreen({super.key, required this.aluno});

  @override
  State<GradeCurricularScreen> createState() => _GradeCurricularScreenState();
}

class _GradeCurricularScreenState extends State<GradeCurricularScreen> {
  final String baseUrl = 'http://localhost:3000';

  List<Curso> _cursos = [];
  List<Disciplina> _disciplinas = [];
  Curso? _cursoSelecionado;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarCursosEDisciplinas();
  }

  Future<void> _carregarCursosEDisciplinas() async {
    final cursosResponse = await http.get(Uri.parse('$baseUrl/cursos'));
    final disciplinasResponse = await http.get(Uri.parse('$baseUrl/disciplinas'));

    if (cursosResponse.statusCode == 200 && disciplinasResponse.statusCode == 200) {
      final cursosJson = jsonDecode(cursosResponse.body) as List;
      final disciplinasJson = jsonDecode(disciplinasResponse.body) as List;

      setState(() {
        _cursos = cursosJson.map((e) => Curso.fromJson(e)).toList();
        _disciplinas = disciplinasJson.map((e) => Disciplina.fromJson(e)).toList();
        _cursoSelecionado = _cursos.firstWhere((c) => c.id == widget.aluno.cursoId, orElse: () => _cursos.first);
        _carregando = false;
      });
    } else {
      throw Exception('Erro ao carregar cursos ou disciplinas');
    }
  }

  Map<int, List<Disciplina>> _disciplinasPorPeriodo(int cursoId) {
    final List<Disciplina> doCurso = _disciplinas.where((d) => d.cursoId == cursoId).toList();
    final Map<int, List<Disciplina>> agrupadas = {};

    for (var disc in doCurso) {
      agrupadas.putIfAbsent(disc.periodo, () => []).add(disc);
    }

    final sorted = Map.fromEntries(
      agrupadas.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(
        appBar: AppTopBar(nomeUsuario: widget.aluno.name),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final disciplinasPorPeriodo = _disciplinasPorPeriodo(_cursoSelecionado!.id);

    return Scaffold(
      appBar: AppTopBar(nomeUsuario: widget.aluno.name),
      body: Column(
        children: [
          // Cabeçalho azul com título "Grade Curricular"
          Container(
            color: const Color(0xFF004092),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                "Grade Curricular",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coluna principal com tabelas
                  Expanded(
                    flex: 3,
                    child: ListView(
                      children: [
                        const Text(
                          'Matriz Curricular',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        for (var periodo in disciplinasPorPeriodo.entries) ...[
                          Text('${periodo.key}º Período', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          _buildTabela(periodo.value),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Coluna lateral com curso + botões
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero, // Remove margens padrão
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7), // Cantos retos
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Fundo branco
                              border: Border(
                                left: BorderSide(
                                  color: Color(0xFF004092), // Barra azul na esquerda
                                  width: 6,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(7)
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Curso', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 15),
                                DropdownButtonFormField<Curso>(
                                  isExpanded: true,
                                  value: _cursoSelecionado,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue[800]!),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  items: _cursos.map((curso) {
                                    return DropdownMenuItem(
                                      value: curso,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                                        child: Text(curso.nome),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (curso) {
                                    setState(() {
                                      _cursoSelecionado = curso;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text('Voltar'),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // lógica de exportação/impressão
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF004092),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text('Imprimir'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // Rodapé usando o RodapeWidget
          const RodapeWidget(),
        ],
      ),
    );
  }

  Widget _buildTabela(List<Disciplina> disciplinas) {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.grey[300]),
      dataRowColor: MaterialStateProperty.all(Colors.white), // Linhas brancas
      columns: const [
        DataColumn(label: Text("Código")),
        DataColumn(label: Text("Disciplina")),
        DataColumn(label: Text("Carga Horária")),
      ],
      rows: disciplinas.map((disc) {
        return DataRow(cells: [
          DataCell(Text(disc.codigo)),
          DataCell(Text(disc.nome)),
          DataCell(Text("${disc.cargaHoraria}")),
        ]);
      }).toList(),
    );
  }
}