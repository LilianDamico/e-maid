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

  // Se o provedor primário é email/senha (útil para UI e reautenticação)
  bool get isEmailPasswordUser {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'password');
  }

  /// --- LOGIN / CADASTRO ---

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

      // Doc do profissional
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

      // espelho simplificado em users
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

  /// --- EXCLUSÃO DE CONTA + DADOS ---

  /// Reautentica usuário de email/senha (chamado pela sua tela quando necessário)
  Future<void> reauthenticateWithPassword(String password) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Nenhum usuário autenticado.';
    final email = user.email;
    if (email == null) throw 'Conta não possui e-mail.';

    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    }
  }

  /// Exclui dados básicos do usuário no Firestore e a conta no Auth.
  /// Se o Firebase exigir reautenticação, lança 'requires-recent-login'
  /// (sua tela já trata esse texto).
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw 'Nenhum usuário autenticado.';
    final uid = user.uid;

    // 1) Apagar dados do Firestore (coleções principais)
    await _deleteFirestoreUserData(uid);

    // 2) Excluir a conta no Auth
    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Sinal claro para a UI pedir reautenticação
        throw 'requires-recent-login';
      }
      throw _mapAuthError(e);
    }
  }

  /// Remove os documentos principais do usuário.
  /// Obs.: se você tiver subcoleções (ex.: bookings, addresses, etc.),
  /// delete-as aqui também (via batch/paginado).
  Future<void> _deleteFirestoreUserData(String uid) async {
    // users/{uid}
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (_) {
      // ignora se não existir
    }

    // professionals/{uid}
    try {
      await _firestore.collection('professionals').doc(uid).delete();
    } catch (_) {}

    // EXEMPLO para subcoleção paginada (descomente/adapte se precisar):
    // await _deleteCollectionPaged(
    //   _firestore.collection('users').doc(uid).collection('addresses'),
    //   pageSize: 50,
    // );
  }

  /// Deleção paginada de uma coleção (para evitar estouro de memória).
  Future<void> _deleteCollectionPaged(
    Query collection, {
    int pageSize = 50,
  }) async {
    while (true) {
      final snap = await collection.limit(pageSize).get();
      if (snap.docs.isEmpty) break;

      final batch = _firestore.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
      if (snap.docs.length < pageSize) break;
    }
  }

  /// --- HELPERS FIRESTORE ---

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

  /// --- MAPA DE ERROS ---

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
