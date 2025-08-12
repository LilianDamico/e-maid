class ApiConfig {
  // Produção
  static const baseUrl = 'https://e-maid-api.onrender.com';

  // Endpoints do seu backend
  static const createPreference = '$baseUrl/mp/create-preference';
  static const createPix = '$baseUrl/mp/create-pix';
  // (opcional) status etc:
  // static const paymentStatus = '$baseUrl/mp/payment-status';
}

class ReturnUrls {
  // Esses 3 devem bater com os que você usa ao criar a preferência no backend
  static const success = 'https://e-maid.app/pay/success';
  static const failure = 'https://e-maid.app/pay/failure';
  static const pending = 'https://e-maid.app/pay/pending';
}
