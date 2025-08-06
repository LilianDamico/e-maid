import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/mercado_pago_service.dart';
import '../../services/auth_service.dart';
import 'payment_webview_screen.dart';
import 'pix_payment_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final double totalAmount;
  
  const PaymentMethodScreen({
    super.key,
    required this.bookingData,
    required this.totalAmount,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final MercadoPagoService _mpService = MercadoPagoService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forma de Pagamento'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo do pedido
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumo do Pedido',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Serviço: ${widget.bookingData['serviceName']}'),
                    Text('Profissional: ${widget.bookingData['professionalName']}'),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${widget.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Métodos de pagamento
            const Text(
              'Escolha a forma de pagamento:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // PIX
            _buildPaymentOption(
              icon: Icons.pix,
              title: 'PIX',
              subtitle: 'Pagamento instantâneo',
              onTap: () => _handlePixPayment(),
            ),
            
            // Cartão de Crédito
            _buildPaymentOption(
              icon: Icons.credit_card,
              title: 'Cartão de Crédito',
              subtitle: 'Parcelamento em até 12x',
              onTap: () => _handleCreditCardPayment(),
            ),
            
            // Cartão de Débito
            _buildPaymentOption(
              icon: Icons.payment,
              title: 'Cartão de Débito',
              subtitle: 'Débito à vista',
              onTap: () => _handleDebitCardPayment(),
            ),
            
            const Spacer(),
            
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          size: 32,
          color: Colors.teal,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Future<void> _handlePixPayment() async {
    setState(() => _isLoading = true);
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final pixData = await _mpService.createPixPayment(
        amount: widget.totalAmount,
        userEmail: user.email ?? '',
        bookingId: widget.bookingData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        description: 'Pagamento E-Maid - ${widget.bookingData['serviceName']}',
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PixPaymentScreen(
              pixData: pixData,
              bookingData: widget.bookingData,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar PIX: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCreditCardPayment() async {
    await _createPaymentPreference('credit_card');
  }

  Future<void> _handleDebitCardPayment() async {
    await _createPaymentPreference('debit_card');
  }

  Future<void> _createPaymentPreference(String paymentType) async {
    setState(() => _isLoading = true);
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final preference = await _mpService.createPaymentPreference(
        title: 'E-Maid - ${widget.bookingData['serviceName']}',
        amount: widget.totalAmount,
        userEmail: user.email ?? '',
        bookingId: widget.bookingData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebViewScreen(
              checkoutUrl: preference['init_point'],
              bookingData: widget.bookingData,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar pagamento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}