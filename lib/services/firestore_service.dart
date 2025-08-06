import 'package:cloud_firestore/cloud_firestore.dart';
import 'commission_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // PROFESSIONALS
  
  // Get all verified professionals
  Stream<List<Map<String, dynamic>>> getProfessionals() {
    return _firestore
        .collection('professionals')
        .where('isVerified', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList());
  }

  // Get professionals by service
  Stream<List<Map<String, dynamic>>> getProfessionalsByService(String service) {
    return _firestore
        .collection('professionals')
        .where('specialties', arrayContains: service)
        .where('isVerified', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList());
  }

  // Get professional by ID
  Future<Map<String, dynamic>?> getProfessionalById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('professionals').doc(id).get();
      if (doc.exists) {
        return {...doc.data() as Map<String, dynamic>, 'id': doc.id};
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar profissional: $e';
    }
  }

  // Update professional profile
  Future<void> updateProfessionalProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('professionals').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao atualizar perfil: $e';
    }
  }

  // SERVICES
  
  // Get all services
  Future<List<Map<String, dynamic>>> getServices() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('services').get();
      return snapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();
    } catch (e) {
      throw 'Erro ao buscar serviços: $e';
    }
  }

  // Add service (admin only)
  Future<void> addService(Map<String, dynamic> serviceData) async {
    try {
      await _firestore.collection('services').add({
        ...serviceData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao adicionar serviço: $e';
    }
  }

  // BOOKINGS
  
  // Create booking
  Future<String> createBooking({
    required String clientId,
    required String professionalId,
    required String serviceId,
    required String serviceName,
    required DateTime date,
    required String time,
    required int duration,
    required String frequency,
    required String address,
    required String observations,
    required double price,
  }) async {
    try {
      DocumentReference docRef = await _firestore.collection('bookings').add({
        'clientId': clientId,
        'professionalId': professionalId,
        'serviceId': serviceId,
        'serviceName': serviceName,
        'date': Timestamp.fromDate(date),
        'time': time,
        'duration': duration,
        'frequency': frequency,
        'address': address,
        'observations': observations,
        'price': price,
        'status': 'pending', // pending, confirmed, in_progress, completed, cancelled
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw 'Erro ao criar agendamento: $e';
    }
  }

  // Get user bookings
  Stream<List<Map<String, dynamic>>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('clientId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList());
  }

  // Get professional bookings
  Stream<List<Map<String, dynamic>>> getProfessionalBookings(String professionalId) {
    return _firestore
        .collection('bookings')
        .where('professionalId', isEqualTo: professionalId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList());
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Se o booking foi completado, processar pagamento e comissão
      if (status == 'completed') {
        final commissionService = CommissionService();
        await commissionService.processBookingPayment(bookingId);
      }
    } catch (e) {
      throw 'Erro ao atualizar status do agendamento: $e';
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'cancelled',
        'cancellationReason': reason,
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao cancelar agendamento: $e';
    }
  }

  // REVIEWS
  
  // Add review
  Future<void> addReview({
    required String bookingId,
    required String clientId,
    required String professionalId,
    required double rating,
    required String comment,
  }) async {
    try {
      // Add review
      await _firestore.collection('reviews').add({
        'bookingId': bookingId,
        'clientId': clientId,
        'professionalId': professionalId,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update professional rating
      await _updateProfessionalRating(professionalId);
    } catch (e) {
      throw 'Erro ao adicionar avaliação: $e';
    }
  }

  // Get professional reviews
  Stream<List<Map<String, dynamic>>> getProfessionalReviews(String professionalId) {
    return _firestore
        .collection('reviews')
        .where('professionalId', isEqualTo: professionalId)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList());
  }

  // Update professional rating
  Future<void> _updateProfessionalRating(String professionalId) async {
    try {
      QuerySnapshot reviews = await _firestore
          .collection('reviews')
          .where('professionalId', isEqualTo: professionalId)
          .get();

      if (reviews.docs.isNotEmpty) {
        double totalRating = 0;
        for (var doc in reviews.docs) {
          totalRating += (doc.data() as Map<String, dynamic>)['rating'] ?? 0;
        }
        double averageRating = totalRating / reviews.docs.length;

        await _firestore.collection('professionals').doc(professionalId).update({
          'rating': averageRating,
          'totalRatings': reviews.docs.length,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw 'Erro ao atualizar avaliação do profissional: $e';
    }
  }

  // NOTIFICATIONS
  
  // Add notification
  Future<void> addNotification({
    required String userId,
    required String title,
    required String message,
    required String type, // booking, review, system
    String? relatedId,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'relatedId': relatedId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao adicionar notificação: $e';
    }
  }

  // Get user notifications
  Stream<List<Map<String, dynamic>>> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList());
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao marcar notificação como lida: $e';
    }
  }
}