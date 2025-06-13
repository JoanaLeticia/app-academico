import 'package:flutter/material.dart';

class CardFuncionalidade extends StatelessWidget {
  final String titulo;
  final String descricao;
  final VoidCallback onPressed;

  const CardFuncionalidade({
    required this.titulo,
    required this.descricao,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 393, // Largura máxima
          maxHeight: 186, // Altura máxima
        ),
        child: Row(
          children: [
            // Barrinha azul lateral
            Container(
              width: 12,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF004093),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            // Conteúdo do card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        descricao,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF5B5B5B)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 100, // Largura fixa para o botão
                        height: 42,  // Altura fixa para o botão
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.grey, // Borda cinza
                              width: 1.0,         // Espessura da borda
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7), // Bordas arredondadas (10px)
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            backgroundColor: Colors.white, // Fundo branco (opcional)
                          ),
                          onPressed: onPressed,
                          child: const Text(
                            'Acessar',
                            style: TextStyle(
                              color: Colors.black, // Cor do texto azul
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}