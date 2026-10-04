import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pata/core/widgets/app_snackbar.dart';
import 'package:pata/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

/// Tela de recuperação de senha: o usuário informa o e-mail e recebe,
/// pelo Firebase, um link para redefinir a senha.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _requestSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final AuthProvider provider = context.read<AuthProvider>();
    final bool success = await provider.sendPasswordResetEmail(
      email: _emailController.text,
    );

    if (!mounted) return;

    if (success) {
      setState(() => _requestSent = true);
      AppSnackbar.showSuccess(
        context,
        'Se esse e-mail estiver cadastrado, você vai receber um link '
        'para redefinir a senha.',
      );
    } else {
      AppSnackbar.showError(
        context,
        provider.errorMessage ?? 'Não foi possível enviar a solicitação.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<AuthProvider>().isLoading;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.lock_reset, size: 56, color: colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Informe o e-mail da sua conta. Vamos enviar um link para '
                  'você redefinir a senha.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const <String>[AutofillHints.email],
                  enabled: !_requestSent,
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
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: (isLoading || _requestSent) ? null : _submit,
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_outlined),
                  label: Text(
                    _requestSent
                        ? 'Solicitação enviada'
                        : (isLoading ? 'Enviando...' : 'Enviar'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Voltar ao login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
