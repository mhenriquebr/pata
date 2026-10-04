import 'package:flutter/material.dart';

/// Tela exibida enquanto o app ainda está determinando se existe uma
/// sessão autenticada em andamento (primeira resposta do Firebase Auth).
///
/// Fica visível por muito pouco tempo — evita o "flash" de mostrar a
/// tela de login para depois redirecionar quem já estava logado.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.pets, size: 64, color: colorScheme.primary),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
