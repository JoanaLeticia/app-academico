import 'package:app_academico/services/rematricula_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/disciplina_model.dart';
import '../models/aluno_model.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/rodape_widget.dart';

class RematriculaScreen extends StatefulWidget {
  final AlunoModel aluno;

  const RematriculaScreen({super.key, required this.aluno});

  @override
  State<RematriculaScreen> createState() => _RematriculaScreenState();
}

class _RematriculaScreenState extends State<RematriculaScreen> {
  List<Disciplina> todasDisciplinas = [];
  List<Disciplina> disciplinasDisponiveis = [];
  List<Disciplina> disciplinasPendentes = [];
  List<int> disciplinasSelecionadas = [];
  List<int> disciplinasCursadasIds = []; // Exemplo

  final String baseUrl = 'http://localhost:3000';
  bool _carregando = true;
  final RematriculaService _rematriculaService = RematriculaService();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      // Busca disciplinas cursadas primeiro
      disciplinasCursadasIds = await _rematriculaService.buscarDisciplinasCursadas(widget.aluno.id);

      // Depois busca todas as disciplinas do curso
      final response = await http.get(Uri.parse('$baseUrl/disciplinas?cursoId=${widget.aluno.cursoId}'));

      if (response.statusCode == 200) {
        final List jsonData = jsonDecode(response.body);
        final disciplinas = jsonData.map((d) => Disciplina.fromJson(d)).toList();

        setState(() {
          todasDisciplinas = disciplinas.cast<Disciplina>();
          disciplinasDisponiveis = _filtrarDisciplinasDisponiveis();
          disciplinasPendentes = _filtrarDisciplinasPendentes();
          _carregando = false;
        });
      } else {
        throw Exception('Erro ao carregar disciplinas');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: ${e.toString()}')),
      );
      setState(() {
        _carregando = false;
      });
    }
  }

  List<Disciplina> _filtrarDisciplinasDisponiveis() {
    final proxPeriodo = widget.aluno.periodoAtual + 1;

    return todasDisciplinas.where((disc) {
      final jaCursada = disciplinasCursadasIds.contains(disc.id);
      final ehDoProxPeriodo = disc.periodo == proxPeriodo;
      final ehAnteriorNaoCursada = disc.periodo < proxPeriodo && !jaCursada;

      return ehDoProxPeriodo || ehAnteriorNaoCursada;
    }).toList();
  }

  List<Disciplina> _filtrarDisciplinasPendentes() {
    final proxPeriodo = widget.aluno.periodoAtual + 1;
    return todasDisciplinas.where((disc) => disc.periodo > proxPeriodo).toList();
  }

  void _confirmarMatricula() {
    final selecionadas = disciplinasDisponiveis
        .where((disc) => disciplinasSelecionadas.contains(disc.id))
        .toList();

    // Aqui você pode enviar um POST ou salvar localmente
    print("Disciplinas matriculadas:");
    for (var d in selecionadas) {
      print("- ${d.nome}");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Matrícula confirmada com sucesso!')),
    );

    setState(() {
      disciplinasSelecionadas.clear();
    });
  }

  Widget _buildTabelaDisciplinas(List<Disciplina> disciplinas, {bool habilitado = true}) {
    final disciplinasPorPeriodo = <int, List<Disciplina>>{};
    for (var disc in disciplinas) {
      disciplinasPorPeriodo.putIfAbsent(disc.periodo, () => []).add(disc);
    }

    return Column(
      children: disciplinasPorPeriodo.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9), // Cor cinza para o cabeçalho
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              child: Text(
                "${entry.key}º Período",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Cor mais escura para melhor contraste
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: habilitado ? Colors.white : Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border(
                  left: BorderSide(color: Colors.grey.shade300),
                  right: BorderSide(color: Colors.grey.shade300),
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entry.value.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final disc = entry.value[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        '${disc.codigo} - ${disc.nome}',
                        style: TextStyle(
                          fontSize: 16,
                          color: habilitado ? Colors.black : Colors.grey[600],
                        ),
                      ),
                      value: habilitado ? disciplinasSelecionadas.contains(disc.id) : false,
                      onChanged: habilitado
                          ? (bool? value) {
                        setState(() {
                          if (value == true) {
                            disciplinasSelecionadas.add(disc.id);
                          } else {
                            disciplinasSelecionadas.remove(disc.id);
                          }
                        });
                      }
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF0F0F0),
    appBar: AppTopBar(nomeUsuario: widget.aluno.name),
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Barra azul com título
                Container(
                  color: const Color(0xFF004092),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'Rematrícula',
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
                      // Seção Disciplinas Disponíveis
                      Text(
                        "Disciplinas Disponíveis",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildTabelaDisciplinas(disciplinasDisponiveis),

                      // Seção Disciplinas Pendentes
                      SizedBox(height: 32),
                      Text(
                        "Disciplinas Pendentes Não Disponíveis",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildTabelaDisciplinas(
                          disciplinasPendentes, habilitado: false),

                      // Botões
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: Text("Voltar"),
                          ),
                          ElevatedButton(
                            onPressed: disciplinasSelecionadas.isEmpty
                                ? null
                                : _confirmarMatricula,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004093),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: Text("Confirmar Matrícula"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Rodapé fixo
        const RodapeWidget(),
      ],
    ),
  );
}
}