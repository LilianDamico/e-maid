import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();
  final _db = FirestoreService();
  final _fs = FirebaseFirestore.instance;

  bool _saving = false;
  Map<String, dynamic>? _userData;
  String _userType = 'cliente';
  late final String _uid;

  // Avatar pendente (preview + upload cross-plataforma)
  Uint8List? _pendingAvatarBytes;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.splash, (_) => false);
      });
      return;
    }
    _uid = user.uid;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream() {
    return _fs.collection('users').doc(_uid).snapshots();
  }

  Future<void> _refresh() async {
    final snap = await _fs.collection('users').doc(_uid).get();
    if (!mounted) return;
    setState(() {
      _userData = snap.data();
      _userType = (_userData?['userType'] as String?)?.toLowerCase().trim() ?? 'cliente';
    });
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource?>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Câmera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            if (_userData?['photoUrl'] != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remover foto', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context, null),
              ),
          ],
        ),
      ),
    );

    // Remover foto atual
    if (source == null && _userData?['photoUrl'] != null) {
      setState(() => _saving = true);
      try {
        await _fs.collection('users').doc(_uid).update({
          'photoUrl': FieldValue.delete(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        _snack('Foto removida com sucesso.', success: true);
      } catch (e) {
        _snack('Erro ao remover foto: $e');
      } finally {
        if (mounted) setState(() => _saving = false);
      }
      return;
    }
    if (source == null) return;

    final img = await picker.pickImage(source: source, imageQuality: 80);
    if (img == null) return;

    // Lê bytes para funcionar no Web e no mobile
    final bytes = await img.readAsBytes();
    setState(() {
      _pendingAvatarBytes = bytes;
    });

    final currentName = _userData?['name'] ?? _auth.currentUser?.displayName ?? 'Usuário';
    await _saveProfile(name: currentName);
  }

  Future<void> _saveProfile({required String name}) async {
    if (name.trim().isEmpty) {
      _snack('Informe um nome válido.');
      return;
    }

    setState(() => _saving = true);
    try {
      String? photoUrl = _userData?['photoUrl'];

      // Upload de nova foto (se selecionada)
      if (_pendingAvatarBytes != null) {
        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child(_uid)
              .child('avatar.jpg');

          await storageRef.putData(
            _pendingAvatarBytes!,
            SettableMetadata(contentType: 'image/jpeg'),
          );
          photoUrl = await storageRef.getDownloadURL();
        } catch (e) {
          _snack('Erro ao fazer upload da imagem: $e');
          return;
        }
      }

      await _fs.collection('users').doc(_uid).update({
        'name': name.trim(),
        if (photoUrl != null) 'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _auth.currentUser?.updateDisplayName(name.trim());

      _snack('Perfil atualizado com sucesso.', success: true);
      setState(() {
        _pendingAvatarBytes = null;
      });
    } catch (e) {
      _snack('Erro ao salvar perfil: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.splash, (_) => false);
    } catch (e) {
      _snack('Erro ao sair: $e');
    }
  }

  Future<void> _deleteAccount() async {
    final ok = await _confirm(
      title: 'Excluir conta',
      message:
          'Tem certeza que deseja excluir sua conta? Essa ação é irreversível e TODOS os seus dados serão apagados.',
      confirmText: 'Excluir',
      confirmColor: Colors.red,
    );
    if (ok != true) return;

    setState(() => _saving = true);
    try {
      await _auth.deleteAccount();
      if (!mounted) return;
      _snack('Conta excluída com sucesso.', success: true);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.splash, (_) => false);
    } catch (e) {
      _snack('Não foi possível excluir: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool?> _confirm({
    required String title,
    required String message,
    String cancelText = 'Cancelar',
    String confirmText = 'Confirmar',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelText)),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: success ? Colors.green : Colors.red),
    );
  }

  void _goOrToast({required String? routeName, required String fallbackMsg}) {
    if (routeName == null || routeName.isEmpty) {
      _snack(fallbackMsg);
      return;
    }
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _userStream(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(
            appBar: _appBar(),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Erro ao carregar perfil: ${snap.error}'),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _refresh, child: const Text('Tentar novamente')),
                ],
              ),
            ),
          );
        }

        _userData = snap.data?.data() ?? {};
        final name = (_userData?['name'] as String?)?.trim();
        final email = _auth.currentUser?.email ?? _userData?['email'] ?? '';
        final photoUrl = _userData?['photoUrl'] as String?;
        _userType = (_userData?['userType'] as String?)?.toLowerCase().trim() ?? 'cliente';

        return Scaffold(
          appBar: _appBar(),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _header(
                    name: name ?? _auth.currentUser?.displayName ?? 'Usuário',
                    email: email,
                    photoUrl: photoUrl,
                    onChangePhoto: _pickAvatar,
                  ),

                  // ... (restante da sua UI: stats, seções, botões, etc.)
                  // Mantive exatamente como você tinha abaixo:

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _stat('Serviços', (_userData?['servicesCount'] ?? 0).toString(),
                            Icons.cleaning_services, Colors.blue),
                        const SizedBox(width: 12),
                        _stat('Avaliação',
                            ((_userData?['rating'] ?? 0.0) as num).toStringAsFixed(1), Icons.star, Colors.amber),
                        const SizedBox(width: 12),
                        _stat('Gastos', 'R\$ ${(_userData?['spent'] ?? 0).toString()}', Icons.savings, Colors.green),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _section('Conta', [
                          _item(Icons.person, 'Editar perfil', () => _showEditNameSheet(name ?? '')),
                          _item(Icons.security, 'Segurança', () {
                            _goOrToast(
                              routeName: AppRoutes.accountSecurity,
                              fallbackMsg: 'Tela de segurança não configurada.',
                            );
                          }),
                          _item(Icons.payment, 'Métodos de pagamento', () {
                            _goOrToast(
                              routeName: AppRoutes.paymentMethods,
                              fallbackMsg: 'Tela de métodos de pagamento não configurada.',
                            );
                          }),
                          _item(Icons.location_on, 'Endereços salvos', () {
                            _goOrToast(
                              routeName: AppRoutes.savedAddresses,
                              fallbackMsg: 'Tela de endereços não configurada.',
                            );
                          }),
                        ]),

                        const SizedBox(height: 16),

                        if (_userType == 'profissional')
                          _section('Área do Profissional', [
                            _item(Icons.account_balance_wallet, 'Meus ganhos', () {
                              _goOrToast(
                                routeName: AppRoutes.earnings,
                                fallbackMsg: 'Tela de ganhos não configurada.',
                              );
                            }),
                            _item(Icons.work_outline, 'Meus trabalhos', () {
                              _goOrToast(
                                routeName: AppRoutes.professionalJobs,
                                fallbackMsg: 'Tela de trabalhos não configurada.',
                              );
                            }),
                            _item(Icons.schedule, 'Disponibilidade', () {
                              _goOrToast(
                                routeName: AppRoutes.availability,
                                fallbackMsg: 'Tela de disponibilidade não configurada.',
                              );
                            }),
                          ]),

                        const SizedBox(height: 16),

                        _section('Preferências', [
                          _item(Icons.notifications, 'Notificações', () {
                            _goOrToast(
                              routeName: AppRoutes.notificationsSettings,
                              fallbackMsg: 'Tela de notificações não configurada.',
                            );
                          }),
                          _item(Icons.language, 'Idioma', () {
                            _goOrToast(
                              routeName: AppRoutes.language,
                              fallbackMsg: 'Tela de idioma não configurada.',
                            );
                          }),
                          _item(Icons.dark_mode, 'Tema', () {
                            _goOrToast(
                              routeName: AppRoutes.theme,
                              fallbackMsg: 'Tela de tema não configurada.',
                            );
                          }),
                        ]),

                        const SizedBox(height: 16),

                        if (_userType == 'admin')
                          _section('Administração', [
                            _item(Icons.analytics, 'Estatísticas da plataforma', () {
                              _goOrToast(
                                routeName: AppRoutes.platformStats,
                                fallbackMsg: 'Tela de estatísticas não configurada.',
                              );
                            }),
                            _item(Icons.account_balance, 'Gerenciar comissões', () {
                              _goOrToast(
                                routeName: AppRoutes.manageCommissions,
                                fallbackMsg: 'Tela de comissões não configurada.',
                              );
                            }),
                          ]),

                        const SizedBox(height: 16),

                        _section('Suporte', [
                          _item(Icons.help, 'Central de ajuda', () {
                            _goOrToast(
                              routeName: AppRoutes.helpCenter,
                              fallbackMsg: 'Tela de ajuda não configurada.',
                            );
                          }),
                          _item(Icons.chat, 'Fale conosco', () {
                            _goOrToast(
                              routeName: AppRoutes.contactUs,
                              fallbackMsg: 'Tela de contato não configurada.',
                            );
                          }),
                          _item(Icons.star_rate, 'Avaliar app', () {
                            _goOrToast(
                              routeName: AppRoutes.rateApp,
                              fallbackMsg: 'Ação de avaliar app não configurada.',
                            );
                          }),
                          _item(Icons.share, 'Indicar amigos', () {
                            _goOrToast(
                              routeName: AppRoutes.inviteFriends,
                              fallbackMsg: 'Ação de indicação não configurada.',
                            );
                          }),
                        ]),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _saving ? null : () async {
                              final ok = await _confirm(
                                title: 'Sair da conta',
                                message: 'Deseja encerrar sua sessão?',
                                confirmText: 'Sair',
                              );
                              if (ok == true) _logout();
                            },
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text('Sair da conta', style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _saving ? null : _deleteAccount,
                            icon: const Icon(Icons.delete_forever, color: Colors.red),
                            label: const Text('Excluir conta', style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: _saving
              ? FloatingActionButton.extended(
                  onPressed: () {},
                  label: const Text('Salvando...'),
                  icon: const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                )
              : null,
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('Meu Perfil'),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
    );
  }

  Widget _header({
    required String name,
    required String email,
    required String? photoUrl,
    required VoidCallback onChangePhoto,
  }) {
    ImageProvider avatarProvider;
    if (_pendingAvatarBytes != null) {
      avatarProvider = MemoryImage(_pendingAvatarBytes!);
    } else if (photoUrl != null && photoUrl.isNotEmpty) {
      avatarProvider = NetworkImage(photoUrl);
    } else {
      avatarProvider = const NetworkImage(
        'https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal, Colors.teal.shade300],
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: avatarProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _saving ? null : onChangePhoto,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.edit, size: 18, color: Colors.teal),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(email, style: const TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text(
              _userType == 'profissional'
                  ? 'Conta Profissional'
                  : _userType == 'admin'
                      ? 'Administrador'
                      : 'Cliente',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.07), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.teal, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showEditNameSheet(String currentName) {
    final controller = TextEditingController(text: currentName);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Editar nome', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                onSubmitted: (_) {
                  Navigator.pop(ctx);
                  _saveProfile(name: controller.text);
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : () {
                    Navigator.pop(ctx);
                    _saveProfile(name: controller.text);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Salvar'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
