import 'package:flutter/material.dart';

/// Conteúdo estático de um "slide" do onboarding.
///
/// Não é uma entidade de domínio (não representa dados de negócio nem
/// vem de um repositório) — por isso fica na camada de apresentação,
/// como um simples modelo de UI.
@immutable
class OnboardingPageData {
  const OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
