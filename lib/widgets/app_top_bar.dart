import 'package:app_academico/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String nomeUsuario; // Adicionado parâmetro para o nome do usuário

  const AppTopBar({super.key, required this.nomeUsuario}); // Construtor atualizado

  @override
  Size get preferredSize => const Size.fromHeight(93); // Aumente a altura total

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Retângulo amarelo
        Container(
          height: 5,
          width: double.infinity,
          color: const Color(0xFFFDB813), // Amarelo
        ),
        // AppBar original
        AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          toolbarHeight: 88,
          title: Container(
            height: preferredSize.height - 12, // Ajuste para a altura do retângulo
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Parte esquerda (mantida igual)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 12),
                    const Text(
                      "Portal do Aluno",
                      style: TextStyle(
                        color: Color(0xFF404040),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Logo no centro (mantida igual)
                Center(
                  child: Image.asset(
                    '../../assets/logo-unitins.jpg',
                    height: 60,
                  ),
                ),

                // Parte direita (atualizada para usar nomeUsuario)
                PopupMenuButton<String>(
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.person_alt_circle_fill,
                          color: Color(0xFF404040),
                          size: 35),
                      const SizedBox(width: 9),
                      Text( // Alterado para Text dinâmico
                        nomeUsuario, // Usa o nome do usuário passado como parâmetro
                        style: const TextStyle(
                            color: Color(0xFF404040),
                            fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down,
                          color: Color(0xFF404040)),
                    ],
                  ),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'sair',
                      child: Text('Sair'),
                    ),
                  ],
                  onSelected: (String value) {
                    if (value == 'sair') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}