import 'dart:convert';
import 'package:app_academico/models/documento_padrao_model.dart';
import 'package:app_academico/models/entrega_documento_model.dart';
import 'package:app_academico/models/documento_model.dart';
import 'package:http/http.dart' as http;

class DocumentoService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Documento>> getDocumentosPorAluno(int alunoId) async {
    final responseDocs = await http.get(Uri.parse('$baseUrl/documentosPadrao'));
    final responseEntregas = await http.get(Uri.parse('$baseUrl/entregasDocumentos?alunoId=$alunoId'));

    if (responseDocs.statusCode == 200 && responseEntregas.statusCode == 200) {
      final docsPadraoJson = jsonDecode(responseDocs.body) as List;
      final entregasJson = jsonDecode(responseEntregas.body) as List;

      final docsPadrao = docsPadraoJson.map((e) => DocumentoPadrao.fromJson(e)).toList();
      final entregas = entregasJson.map((e) => EntregaDocumentoAluno.fromJson(e)).toList();

      return docsPadrao.map((doc) {
        final entrega = entregas.firstWhere(
              (e) => e.documentoId == doc.id,
          orElse: () => EntregaDocumentoAluno(documentoId: doc.id, alunoId: alunoId, entregue: false),
        );

        return Documento(
          id: doc.id,
          nome: doc.nome,
          entregue: entrega.entregue,
        );
      }).toList();
    } else {
      throw Exception('Erro ao carregar documentos ou entregas');
    }
  }
}
