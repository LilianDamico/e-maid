import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _auth = AuthService();
  final _passwordCtrl = TextEditingController();
  bool _confirmChecked = false;
  bool _isDeleting = false;
  String? _error;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    if (!_confirmChecked) {
      setState(() => _error = 'Confirme que deseja excluir permanentemente sua conta.');
      return;
    }
    setState(() {
      _error = null;
      _isDeleting = true;
    });

    try {
      await _auth.deleteAccount();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta excluída com sucesso.')),
      );

      // Leva para a tela inicial de auth / login
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    } catch (e) {
      // Se precisar de reautenticação e usuário for email/senha, pede senha
      if (e == 'requires-recent-login' && _auth.isEmailPasswordUser) {
        final ok = await _askPasswordAndReauth();
        if (ok == true) {
          // tente novamente
          await _retryDeleteAfterReauth();
        }
      } else if (e == 'requires-recent-login') {
        // Para Google/Apple/etc, orienta o usuário
        setState(() => _error =
            'Por segurança, faça login novamente e retorne a esta tela para concluir a exclusão.');
      } else {
        setState(() => _error = '$e');
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Future<void> _retryDeleteAfterReauth() async {
    try {
      await _auth.deleteAccount();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta excluída com sucesso.')),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    } catch (e) {
      setState(() => _error = '$e');
    }
  }

  Future<bool?> _askPasswordAndReauth() async {
    _passwordCtrl.clear();
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirme sua senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Por segurança, confirme sua senha para concluir a exclusão.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await _auth.reauthenticateWithPassword(_passwordCtrl.text.trim());
                if (context.mounted) Navigator.pop(ctx, true);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$e')),
                  );
                }
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = _auth.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluir conta'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Header(email: email),
          const SizedBox(height: 16),
          const _WarningList(),
          const SizedBox(height: 16),

          // Se login for e-mail/senha, avisa que pode pedir senha
          if (_auth.isEmailPasswordUser)
            const Text(
              'Observação: por segurança, você poderá precisar confirmar sua senha.',
              style: TextStyle(color: Colors.black54),
            )
          else
            const Text(
              'Observação: se aparecer um aviso de segurança, faça login novamente com seu provedor (ex.: Google) e retorne aqui.',
              style: TextStyle(color: Colors.black54),
            ),

          const SizedBox(height: 20),
          CheckboxListTile(
            value: _confirmChecked,
            onChanged: (v) => setState(() => _confirmChecked = v ?? false),
            title: const Text(
              'Estou ciente de que esta ação é permanente e não pode ser desfeita.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),

          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],

          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _isDeleting ? null : () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          const SizedBox(height: 10),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            onPressed: _isDeleting ? null : _handleDelete,
            child: _isDeleting
                ? const SizedBox(
                    height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                : const Text('Excluir minha conta'),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String email;
  const _Header({required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.warning_rounded, color: Colors.red, size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'Você está prestes a excluir sua conta',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              children: [
                if (email.isNotEmpty)
                  TextSpan(
                    text: '\n$email',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WarningList extends StatelessWidget {
  const _WarningList();

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      'Seu perfil e dados pessoais serão removidos.',
      'Se você for profissional, seus dados de serviços também serão excluídos.',
      'Avaliações feitas por você podem deixar de aparecer associadas à sua conta.',
      'Esta ação é permanente e não pode ser desfeita.',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('O que acontece após excluir?', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...items.map((t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(child: Text(t)),
                ],
              ),
            )),
      ],
    );
  }
}
