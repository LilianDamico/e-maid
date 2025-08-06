import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String userType,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await result.user?.updateDisplayName(name);

      // Create user document in Firestore
      await _createUserDocument(
        uid: result.user!.uid,
        email: email,
        name: name,
        phone: phone,
        userType: userType,
      );

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register professional with complete data
  Future<UserCredential?> registerProfessional({
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
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await result.user?.updateDisplayName(name);

      // Create professional document in Firestore
      await _createProfessionalDocument(
        uid: result.user!.uid,
        email: email,
        name: name,
        phone: phone,
        cpf: cpf,
        address: address,
        experience: experience,
        pricePerHour: pricePerHour,
        description: description,
        specialties: specialties,
      );

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Erro ao fazer logout: $e';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Create user document in Firestore
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

  // Create professional document in Firestore
  Future<void> _createProfessionalDocument({
    required String uid,
    required String email,
    required String name,
    required String phone,
    required String cpf,
    required String address,
    required int experience,
    required double pricePerHour,
    required String description,
    required List<String> specialties,
  }) async {
    await _firestore.collection('professionals').doc(uid).set({
      'uid': uid,
      'email': email,
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
      'isVerified': false, // Needs admin approval
      'profileImageUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Also create in users collection
    await _createUserDocument(
      uid: uid,
      email: email,
      name: name,
      phone: phone,
      userType: 'profissional',
    );
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Erro ao buscar dados do usuário: $e';
    }
  }

  // Get professional data
  Future<Map<String, dynamic>?> getProfessionalData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('professionals').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Erro ao buscar dados do profissional: $e';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail já está em uso.';
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
        return 'Erro de autenticação: ${e.message}';
    }
  }
}