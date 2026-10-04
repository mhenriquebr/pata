import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pata/core/widgets/app_snackbar.dart';
import 'package:pata/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

/// Tela de login com e-mail e senha.
///
/// Não navega manualmente após o sucesso: assim que [AuthProvider]
/// detecta o usuário autenticado, o redirect do go_router
/// (`app/router.dart`) já leva para a área interna.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final AuthProvider provider = context.read<AuthProvider>();
    final bool success = await provider.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted || success) return;
    AppSnackbar.showError(
      context,
      provider.errorMessage ?? 'Não foi possível entrar.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<AuthProvider>().isLoading;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.pets, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Entrar no Pata',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Acesso para responsáveis do órgão Pata.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: colorScheme.outline),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const <String>[AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (String? value) {
                      final String text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Informe seu e-mail.';
                      if (!text.contains('@') || !text.contains('.')) {
                        return 'Informe um e-mail válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    autofillHints: const <String>[AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe sua senha.';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.push('/forgot-password'),
                      child: const Text('Esqueci minha senha'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _submit,
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.login),
                    label: Text(isLoading ? 'Entrando...' : 'Entrar'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed:
                        isLoading ? null : () => context.push('/register'),
                    child: const Text('Não tem conta? Criar conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
