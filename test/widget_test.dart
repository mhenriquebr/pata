import 'package:flutter_test/flutter_test.dart';
import 'package:pata/app/app.dart';

void main() {
  testWidgets(
    'App inicia no onboarding e, ao pular, mostra a listagem de pets',
    (WidgetTester tester) async {
      await tester.pumpWidget(const PataApp());
      await tester.pumpAndSettle();

      // Tela de onboarding é a primeira a aparecer.
      expect(find.text('Bem-vindo ao Pata!'), findsOneWidget);
      expect(find.text('Pular'), findsOneWidget);

      // Pular deve levar direto para a listagem de pets.
      await tester.tap(find.text('Pular'));
      await tester.pumpAndSettle();

      expect(find.text('Pata'), findsWidgets);
      expect(find.text('Novo pet'), findsOneWidget);
    },
  );
}
