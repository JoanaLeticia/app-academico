import 'package:flutter/material.dart';
import '../models/aluno_model.dart';
import '../models/curso_model.dart';
import '../models/documento_model.dart';
import '../services/curso_service.dart';
import '../services/documento_service.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/rodape_widget.dart';

class SituacaoAcademicaScreen extends StatefulWidget {
  final AlunoModel aluno;

  const SituacaoAcademicaScreen({super.key, required this.aluno});

  @override
  State<SituacaoAcademicaScreen> createState() => _SituacaoAcademicaScreenState();
}

class _SituacaoAcademicaScreenState extends State<SituacaoAcademicaScreen> {
  List<Documento> _documentos = [];
  Curso? _curso;
  final DocumentoService _docService = DocumentoService();
  final CursoService _cursoService = CursoService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final documentos = await _docService.getDocumentosPorAluno(widget.aluno.id);
    final cursos = await _cursoService.getCursosDoAluno(widget.aluno);
    setState(() {
      _documentos = documentos;
      _curso = cursos.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final temPendencias = _documentos.any((doc) => !doc.entregue);
    final documentosEsquerda = _documentos.take(5).toList();
    final documentosDireita = _documentos.skip(5).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppTopBar(nomeUsuario: widget.aluno.name),
      body: SingleChildScrollView( // Adicionado SingleChildScrollView
        child: Column(
          children: [
            // Cabeçalho azul
            Container(
              color: const Color(0xFF004092),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  "Situação Acadêmica",
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
                  const Text("Informações", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Card com barra azul e foto
                  // Card com barra azul e foto - bordas arredondadas
                  Container(
                    width: double.infinity,
                    height: 165,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Row(
                      children: [
                        // Barra azul com bordas arredondadas
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
                        const SizedBox(width: 16),
                        ClipOval(
                          child: Container(
                            width: 101,
                            height: 101,
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.aluno.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Matrícula: ${widget.aluno.matricula}", style: const TextStyle(fontSize: 16)),
                            Text("Curso: ${_curso?.nome ?? 'Carregando...'}", style: const TextStyle(fontSize: 16)),
                            const Text("Situação: Matriculado", style: TextStyle(fontSize: 16)),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text("Documentos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Lista de documentos em uma SingleChildScrollView aninhada
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4, // Altura fixa para a lista
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: documentosEsquerda.map((doc) => _buildDocumentoCard(doc)).toList(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: documentosDireita.map((doc) => _buildDocumentoCard(doc)).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 0),
                  if (temPendencias)
                    Container(
                      width: 500,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Pendência(s)!\nVocê possui pendência de documento(s), favor procurar a secretaria.",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),

                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
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

  Widget _buildDocumentoCard(Documento doc) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              doc.entregue ? Icons.check : Icons.close,
              color: doc.entregue ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              doc.nome,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}