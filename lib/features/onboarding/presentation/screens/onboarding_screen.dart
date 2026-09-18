import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pata/features/onboarding/presentation/models/onboarding_page_data.dart';

/// Tela de boas-vindas exibida na abertura do app.
///
/// Reúne o que, em outras referências, costuma vir em 3 telas separadas
/// dentro de uma única rota, usando um [PageView] deslizável — assim o
/// fluxo de navegação do app continua enxuto (a tela em si é só uma).
///
/// É um [StatefulWidget] porque precisa acompanhar qual página está
/// visível (para os indicadores e para trocar "Próximo" por "Começar").
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const List<OnboardingPageData> _pages = <OnboardingPageData>[
    OnboardingPageData(
      icon: Icons.pets,
      title: 'Bem-vindo ao Pata!',
      description: 'Encontre um novo amigo e dê a ele um lar cheio de amor.',
    ),
    OnboardingPageData(
      icon: Icons.favorite_rounded,
      title: 'Encontre seu novo amigo',
      description:
          'Descubra pets disponíveis para adoção e encontre o companheiro ideal para você.',
    ),
    OnboardingPageData(
      icon: Icons.checklist_rounded,
      title: 'Adotar transforma vidas',
      description:
          'Dê uma nova chance a um pet e faça parte de uma história de amor e cuidado.',
    ),
  ];

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == OnboardingScreen._pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Encerra o onboarding e vai para a listagem de pets.
  ///
  /// Usa `context.go` (em vez de `context.push`) para que a tela de
  /// onboarding saia da pilha de navegação — o botão "voltar" do
  /// dispositivo não deve trazer o usuário de volta para cá.
  void _finishOnboarding() => context.go('/');

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: OnboardingScreen._pages.length,
                onPageChanged: (int index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (BuildContext context, int index) {
                  final OnboardingPageData page =
                      OnboardingScreen._pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 88,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge
                              ?.copyWith(color: colorScheme.outline),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 72,
                    child: _isLastPage
                        ? null
                        : TextButton(
                            onPressed: _finishOnboarding,
                            child: const Text('Pular'),
                          ),
                  ),
                  Row(
                    children: List<Widget>.generate(
                      OnboardingScreen._pages.length,
                      (int index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: _isLastPage ? _finishOnboarding : _goToNextPage,
                    child: Text(_isLastPage ? 'Começar' : 'Próximo'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
