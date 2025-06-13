import 'package:app_academico/models/aluno_model.dart';
import 'package:app_academico/screens/analise_screen.dart';
import 'package:app_academico/screens/boletim_screen.dart';
import 'package:app_academico/screens/grade_curricular_screen.dart';
import 'package:app_academico/screens/rematricula_screen.dart';
import 'package:app_academico/screens/situacao_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/card_funcionalidade.dart';
import '../widgets/rodape_widget.dart';

// ... (imports permanecem os mesmos)

class HomeScreen extends StatelessWidget {
  final AlunoModel aluno;

  const HomeScreen({required this.aluno});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(nomeUsuario: aluno.name),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF004092),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                "Dashboard",
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
              color: const Color(0xFFF0F0F0),
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth ~/ 350; // Aproximadamente 400px por card
                  return GridView.count(
                    crossAxisCount: crossAxisCount.clamp(1, 3), // Mínimo 1, máximo 3
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 2, // Ajuste este valor conforme necessário
                    children: [
                      CardFuncionalidade(
                        titulo: 'BOLETIM (SEMESTRE ATUAL)',
                        descricao: 'Desempenho nas disciplinas do semestre atual',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BoletimScreen(aluno: aluno)),
                          );
                        },
                      ),
                      CardFuncionalidade(
                        titulo: 'GRADE CURRICULAR',
                        descricao: 'Selecione um curso e veja as disciplinas distribuídas por período.',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => GradeCurricularScreen(aluno: aluno)),
                          );
                        },
                      ),
                      CardFuncionalidade(
                        titulo: 'REMATRÍCULA ONLINE',
                        descricao: 'Fazer a rematrícula conforme calendário acadêmico. Emissão de declaração de vínculo.',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RematriculaScreen(aluno: aluno)),
                          );
                        },
                      ),
                      CardFuncionalidade(
                        titulo: 'SITUAÇÃO ACADÊMICA',
                        descricao: 'Veja a sua situação junto à secretaria e departamentos.',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SituacaoAcademicaScreen(aluno: aluno)),
                          );
                        },
                      ),
                      CardFuncionalidade(
                        titulo: 'ANÁLISE CURRICULAR',
                        descricao: 'Análise curricular completa.',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AnaliseCurricularScreen(aluno: aluno)),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const RodapeWidget(),
        ],
      ),
    );
  }
}
