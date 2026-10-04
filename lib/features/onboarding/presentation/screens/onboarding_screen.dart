import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pata/features/onboarding/presentation/models/onboarding_page_data.dart';

/// Tela de boas-vindas exibida na abertura do app.
///
/// Reúne 3 "telas" de introdução em uma única rota, usando um
/// [PageView] deslizável — assim o fluxo de navegação do app continua
/// enxuto. É um [StatefulWidget] porque precisa acompanhar qual página
/// está visível (para os indicadores e para trocar "Próximo" por
/// "Começar").
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const List<OnboardingPageData> _pages = <OnboardingPageData>[
    OnboardingPageData(
      icon: Icons.pets,
      title: 'Bem-vindo ao Pata!',
      description:
          'Cadastre e acompanhe cães e gatos disponíveis para adoção: raça, '
          'idade, peso e muito mais.',
    ),
    OnboardingPageData(
      icon: Icons.favorite_rounded,
      title: 'Cuide de cada detalhe',
      description: 'Registre a situação de vacinação e observações importantes '
          'sobre a saúde e a rotina de cada animal.',
    ),
    OnboardingPageData(
      icon: Icons.checklist_rounded,
      title: 'Tudo na palma da mão',
      description:
          'Consulte rapidamente as informações de cada animal sempre que '
          'precisar, direto do seu celular.',
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

  /// Encerra o onboarding. Usa `context.go` (não `push`) para que esta
  /// tela saia da pilha — o app decide, via redirect do go_router, se
  /// quem chega deve ver a área interna ou o login.
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
