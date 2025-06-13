import 'package:flutter/material.dart';

class RodapeWidget extends StatelessWidget {
  const RodapeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      width: double.infinity,
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            "2025 - Unitins - Todos os direitos reservados.",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            "App desenvolvido para a disciplina de Prog. para Dispositivos Móveis",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
