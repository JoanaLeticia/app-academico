import 'package:flutter/material.dart';
import '../models/aluno_model.dart';
import '../models/boletim_model.dart';
import '../services/boletim_service.dart';
import '../widgets/app_top_bar.dart'; // Importe o AppTopBar
import '../widgets/rodape_widget.dart'; // Importe o RodapeWidget

class BoletimScreen extends StatefulWidget {
  final AlunoModel aluno;

  const BoletimScreen({required this.aluno});

  @override
  State<BoletimScreen> createState() => _BoletimScreenState();
}

class _BoletimScreenState extends State<BoletimScreen> {
  final BoletimService _boletimService = BoletimService();
  Boletim? _boletim;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarBoletim();
  }

  Future<void> _carregarBoletim() async {
    final boletim = await _boletimService.getBoletimDoAluno(widget.aluno.id);
    setState(() {
      _boletim = boletim;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppTopBar(nomeUsuario: widget.aluno.name), // Usando AppTopBar
      body: Column(
        children: [
          Container(
            color: const Color(0xFF004092),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                "Boletim Acadêmico",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _boletim == null
                ? Center(child: Text("Boletim não encontrado"))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Disciplinas do Semestre Letivo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    DataTable(
                      columnSpacing: 20,
                      horizontalMargin: 0,
                      columns: [
                        DataColumn(label: Text("Período Letivo")),
                        DataColumn(label: Text("Código")),
                        DataColumn(label: Text("Disciplina")),
                        DataColumn(label: Text("Faltas")),
                        DataColumn(label: Text("A1")),
                        DataColumn(label: Text("A2")),
                        DataColumn(label: Text("Exame Final")),
                        DataColumn(label: Text("Média Semestral")),
                        DataColumn(label: Text("Média Final")),
                        DataColumn(label: Text("Situação")),
                      ],
                      rows: _boletim!.disciplinas.map((disciplina) {
                        return DataRow(cells: [
                          DataCell(Text(_boletim!.periodo)),
                          DataCell(Text(disciplina.codigo)),
                          DataCell(Text(disciplina.nome)),
                          DataCell(Text(disciplina.faltas.toString())),
                          DataCell(Text(disciplina.a1.toString())),
                          DataCell(Text(disciplina.a2.toString())),
                          DataCell(Text(disciplina.exameFinal?.toString() ?? "-")),
                          DataCell(Text(disciplina.mediaSemestral.toString())),
                          DataCell(Text(disciplina.mediaFinal.toString())),
                          DataCell(
                            Text(
                              disciplina.situacao,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: disciplina.situacao == "Aprovado"
                                    ? Colors.green
                                    : disciplina.situacao == "Reprovado"
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "* Situação passiva de alteração no decorrer do período letivo.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    Text(
                      "- Documento sem valor legal.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    Text(
                      "+ Clique para ver os detalhes da nota.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 12,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          const RodapeWidget(), // Usando RodapeWidget
        ],
      ),
    );
  }
}