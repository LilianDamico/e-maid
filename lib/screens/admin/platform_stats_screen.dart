import 'package:flutter/material.dart';
import '../../services/commission_service.dart';

class PlatformStatsScreen extends StatefulWidget {
  const PlatformStatsScreen({super.key});

  @override
  State<PlatformStatsScreen> createState() => _PlatformStatsScreenState();
}

class _PlatformStatsScreenState extends State<PlatformStatsScreen> {
  final CommissionService _commissionService = CommissionService();
  
  Map<String, dynamic>? _platformStats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPlatformStats();
  }

  Future<void> _loadPlatformStats() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final stats = await _commissionService.getPlatformStats();
      
      setState(() {
        _platformStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas da Plataforma'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPlatformStats,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPlatformStats,
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPlatformStats,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRevenueOverview(),
                        const SizedBox(height: 24),
                        _buildCommissionInfo(),
                        const SizedBox(height: 24),
                        _buildMetricsCards(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildRevenueOverview() {
    if (_platformStats == null) return const SizedBox.shrink();

    final totalRevenue = _platformStats!['totalRevenue'] ?? 0.0;
    final totalTransactions = _platformStats!['totalTransactions'] ?? 0;
    final commissionRate = _platformStats!['commissionRate'] ?? 0.0;

    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.teal.shade600, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Receita Total da Plataforma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'R\$ ${totalRevenue.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Baseado em ${(commissionRate * 100).toStringAsFixed(0)}% de comissão',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$totalTransactions transações processadas',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionInfo() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Modelo de Monetização',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'A plataforma E-Maid utiliza um modelo de comissão de 8% sobre cada trabalho concluído.',
              style: TextStyle(color: Colors.blue.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Como funciona:',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '• Cliente paga o valor total do serviço',
              style: TextStyle(color: Colors.blue.shade600),
            ),
            Text(
              '• Plataforma retém 8% como comissão',
              style: TextStyle(color: Colors.blue.shade600),
            ),
            Text(
              '• Profissional recebe 92% do valor',
              style: TextStyle(color: Colors.blue.shade600),
            ),
            Text(
              '• Processamento automático após conclusão',
              style: TextStyle(color: Colors.blue.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCards() {
    if (_platformStats == null) return const SizedBox.shrink();

    final totalRevenue = _platformStats!['totalRevenue'] ?? 0.0;
    final totalTransactions = _platformStats!['totalTransactions'] ?? 0;
    final lastTransactionDate = _platformStats!['lastTransactionDate'];
    
    // Calcular valor médio por transação
    final averageTransaction = totalTransactions > 0 
        ? (totalRevenue / CommissionService.PLATFORM_COMMISSION_RATE) / totalTransactions
        : 0.0;
    
    String lastTransactionText = 'Nenhuma transação';
    if (lastTransactionDate != null) {
      final date = lastTransactionDate.toDate();
      lastTransactionText = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Métricas Detalhadas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total de Transações',
                totalTransactions.toString(),
                Icons.receipt_long,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Valor Médio',
                'R\$ ${averageTransaction.toStringAsFixed(2)}',
                Icons.trending_up,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Taxa de Comissão',
                '${(CommissionService.PLATFORM_COMMISSION_RATE * 100).toStringAsFixed(0)}%',
                Icons.percent,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Última Transação',
                lastTransactionText,
                Icons.access_time,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}