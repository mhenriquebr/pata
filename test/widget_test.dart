import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pata/features/onboarding/presentation/screens/onboarding_screen.dart';

// Este teste cobre a tela de onboarding isoladamente (sem inicializar o
// Firebase), já que o app completo (PataApp) depende de
// Firebase.initializeApp em main.dart — testar o fluxo de autenticação
// de ponta a ponta exigiria mocks do Firebase, fora do escopo desta
// etapa. O onboarding, por não depender de nenhum provider, é o
// candidato natural para um teste de widget simples e confiável.
void main() {
  testWidgets('Onboarding mostra a primeira página e o botão Pular',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: OnboardingScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo ao Pata!'), findsOneWidget);
    expect(find.text('Pular'), findsOneWidget);
    expect(find.text('Próximo'), findsOneWidget);
  });
}
