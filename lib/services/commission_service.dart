import 'package:cloud_firestore/cloud_firestore.dart';

class CommissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Taxa de comissão da plataforma (8%)
  // ignore: constant_identifier_names
  static const double PLATFORM_COMMISSION_RATE = 0.08;

  // Calcular comissão da plataforma
  double calculatePlatformCommission(double totalAmount) {
    return totalAmount * PLATFORM_COMMISSION_RATE;
  }

  // Calcular valor líquido para o profissional
  double calculateProfessionalEarnings(double totalAmount) {
    return totalAmount - calculatePlatformCommission(totalAmount);
  }

  // Processar pagamento e comissão quando booking é completado
  Future<void> processBookingPayment(String bookingId) async {
    try {
      // Buscar dados do booking
      DocumentSnapshot bookingDoc = await _firestore
          .collection('bookings')
          .doc(bookingId)
          .get();

      if (!bookingDoc.exists) {
        throw 'Booking não encontrado';
      }

      Map<String, dynamic> bookingData =
          bookingDoc.data() as Map<String, dynamic>;
      double totalAmount = bookingData['price'].toDouble();
      String professionalId = bookingData['professionalId'];
      String clientId = bookingData['clientId'];

      double platformCommission = calculatePlatformCommission(totalAmount);
      double professionalEarnings = calculateProfessionalEarnings(totalAmount);

      // Criar registro de transação
      await _firestore.collection('transactions').add({
        'bookingId': bookingId,
        'professionalId': professionalId,
        'clientId': clientId,
        'totalAmount': totalAmount,
        'platformCommission': platformCommission,
        'professionalEarnings': professionalEarnings,
        'status': 'completed',
        'type': 'booking_payment',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Atualizar earnings do profissional
      await _updateProfessionalEarnings(professionalId, professionalEarnings);

      // Atualizar revenue da plataforma
      await _updatePlatformRevenue(platformCommission);
    } catch (e) {
      throw 'Erro ao processar pagamento: $e';
    }
  }

  // Atualizar ganhos acumulados do profissional
  Future<void> _updateProfessionalEarnings(
    String professionalId,
    double earnings,
  ) async {
    try {
      DocumentReference professionalRef = _firestore
          .collection('professionals')
          .doc(professionalId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot professionalDoc = await transaction.get(
          professionalRef,
        );

        if (professionalDoc.exists) {
          Map<String, dynamic> data =
              professionalDoc.data() as Map<String, dynamic>;
          double currentEarnings = (data['totalEarnings'] ?? 0.0).toDouble();
          int completedJobs = (data['completedJobs'] ?? 0);

          transaction.update(professionalRef, {
            'totalEarnings': currentEarnings + earnings,
            'completedJobs': completedJobs + 1,
            'lastEarningDate': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      throw 'Erro ao atualizar ganhos do profissional: $e';
    }
  }

  // Atualizar receita da plataforma
  Future<void> _updatePlatformRevenue(double commission) async {
    try {
      DocumentReference revenueRef = _firestore
          .collection('platform_stats')
          .doc('revenue');

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot revenueDoc = await transaction.get(revenueRef);

        if (revenueDoc.exists) {
          Map<String, dynamic> data = revenueDoc.data() as Map<String, dynamic>;
          double currentRevenue = (data['totalRevenue'] ?? 0.0).toDouble();
          int totalTransactions = (data['totalTransactions'] ?? 0);

          transaction.update(revenueRef, {
            'totalRevenue': currentRevenue + commission,
            'totalTransactions': totalTransactions + 1,
            'lastTransactionDate': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          transaction.set(revenueRef, {
            'totalRevenue': commission,
            'totalTransactions': 1,
            'lastTransactionDate': FieldValue.serverTimestamp(),
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      throw 'Erro ao atualizar receita da plataforma: $e';
    }
  }

  // Obter histórico de transações do profissional
  Stream<List<Map<String, dynamic>>> getProfessionalTransactions(
    String professionalId,
  ) {
    return _firestore
        .collection('transactions')
        .where('professionalId', isEqualTo: professionalId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList(),
        );
  }

  // Obter estatísticas de ganhos do profissional
  Future<Map<String, dynamic>> getProfessionalEarningsStats(
    String professionalId,
  ) async {
    try {
      // Buscar dados do profissional
      DocumentSnapshot professionalDoc = await _firestore
          .collection('professionals')
          .doc(professionalId)
          .get();

      if (!professionalDoc.exists) {
        throw 'Profissional não encontrado';
      }

      Map<String, dynamic> professionalData =
          professionalDoc.data() as Map<String, dynamic>;

      // Buscar transações do mês atual
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      QuerySnapshot monthlyTransactions = await _firestore
          .collection('transactions')
          .where('professionalId', isEqualTo: professionalId)
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
          )
          .where(
            'createdAt',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth),
          )
          .get();

      double monthlyEarnings = 0;
      for (var doc in monthlyTransactions.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        monthlyEarnings += (data['professionalEarnings'] ?? 0.0).toDouble();
      }

      return {
        'totalEarnings': (professionalData['totalEarnings'] ?? 0.0).toDouble(),
        'monthlyEarnings': monthlyEarnings,
        'completedJobs': professionalData['completedJobs'] ?? 0,
        'monthlyJobs': monthlyTransactions.docs.length,
        'commissionRate': PLATFORM_COMMISSION_RATE,
      };
    } catch (e) {
      throw 'Erro ao buscar estatísticas de ganhos: $e';
    }
  }

  // Obter estatísticas da plataforma (admin)
  Future<Map<String, dynamic>> getPlatformStats() async {
    try {
      DocumentSnapshot revenueDoc = await _firestore
          .collection('platform_stats')
          .doc('revenue')
          .get();

      if (!revenueDoc.exists) {
        return {
          'totalRevenue': 0.0,
          'totalTransactions': 0,
          'commissionRate': PLATFORM_COMMISSION_RATE,
        };
      }

      Map<String, dynamic> data = revenueDoc.data() as Map<String, dynamic>;

      return {
        'totalRevenue': (data['totalRevenue'] ?? 0.0).toDouble(),
        'totalTransactions': data['totalTransactions'] ?? 0,
        'commissionRate': PLATFORM_COMMISSION_RATE,
        'lastTransactionDate': data['lastTransactionDate'],
      };
    } catch (e) {
      throw 'Erro ao buscar estatísticas da plataforma: $e';
    }
  }

  /// Obtém o histórico de transações da plataforma
  static Future<List<Map<String, dynamic>>>
  getPlatformTransactionHistory() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('platform_transactions')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      print('Erro ao obter histórico de transações da plataforma: $e');
      return [];
    }
  }

  // Calcular breakdown de preço para exibir ao cliente
  Map<String, dynamic> getPriceBreakdown(double totalAmount) {
    double platformCommission = calculatePlatformCommission(totalAmount);
    double professionalEarnings = calculateProfessionalEarnings(totalAmount);

    return {
      'totalAmount': totalAmount,
      'professionalEarnings': professionalEarnings,
      'platformCommission': platformCommission,
      'commissionRate': PLATFORM_COMMISSION_RATE,
      'commissionPercentage':
          '${(PLATFORM_COMMISSION_RATE * 100).toStringAsFixed(0)}%',
    };
  }
}
