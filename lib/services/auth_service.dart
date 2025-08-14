import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream de mudanças de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Retorna true se o login atual é com e-mail/senha.
  bool get isEmailPasswordUser {
    final u = _auth.currentUser;
    if (u == null) return false;
    return u.providerData.any((p) => p.providerId == 'password');
  }

  /// Reautentica o usuário atual usando e-mail/senha (necessário para exclusão em alguns casos).
  Future<void> reauthenticateWithPassword(String password) async {
    final u = _auth.currentUser;
    if (u == null || u.email == null) {
      throw 'Nenhum usuário autenticado.';
    }
    final cred = EmailAuthProvider.credential(email: u.email!, password: password);
    await u.reauthenticateWithCredential(cred);
  }

  /// Login e-mail/senha
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  /// Cadastro usuário comum
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String userType, // "cliente" | "profissional"
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await cred.user?.updateDisplayName(name);
      await _createUserDocument(
        uid: cred.user!.uid,
        email: email.trim(),
        name: name,
        phone: phone,
        userType: userType,
      );

      return cred;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  /// Cadastro de profissional
  Future<UserCredential> registerProfessional({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String cpf,
    required String address,
    required int experience,
    required double pricePerHour,
    required String description,
    required List<String> specialties,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await cred.user?.updateDisplayName(name);

      // Documento do profissional
      await _firestore.collection('professionals').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': email.trim(),
        'name': name,
        'phone': phone,
        'cpf': cpf,
        'address': address,
        'experience': experience,
        'pricePerHour': pricePerHour,
        'description': description,
        'specialties': specialties,
        'rating': 0.0,
        'totalRatings': 0,
        'isActive': true,
        'isVerified': false,
        'profileImageUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Também cria em users
      await _createUserDocument(
        uid: cred.user!.uid,
        email: email.trim(),
        name: name,
        phone: phone,
        userType: 'profissional',
      );

      return cred;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  // Firestore helpers
  Future<void> _createUserDocument({
    required String uid,
    required String email,
    required String name,
    required String phone,
    required String userType,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'userType': userType,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<Map<String, dynamic>?> getProfessionalData(String uid) async {
    final doc = await _firestore.collection('professionals').doc(uid).get();
    return doc.data();
  }

  /// Exclusão **do próprio usuário** (Auth + dados básicos no Firestore).
  /// Lança o sentinela 'requires-recent-login' quando o Firebase exigir reautenticação.
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw 'Nenhum usuário autenticado.';

    // Remove dados básicos — ignore se não existir
    try { await _firestore.collection('users').doc(user.uid).delete(); } catch (_) {}
    try { await _firestore.collection('professionals').doc(user.uid).delete(); } catch (_) {}

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Deixe a UI decidir (pedir senha para reautenticar, ou orientar relogar no provedor)
        throw 'requires-recent-login';
      }
      throw _mapAuthError(e);
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'E-mail já está em uso.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      default:
        return 'Erro de autenticação: ${e.message ?? e.code}';
    }
  }
}
