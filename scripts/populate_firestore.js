// Script para popular o Firestore com dados iniciais
// Execute: node populate_firestore.js

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json'); // Baixe do Firebase Console

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Dados dos serviços
const services = [
  {
    id: 'limpeza-residencial',
    name: 'Limpeza Residencial',
    category: 'Limpeza',
    icon: 'home',
    basePrice: 25.0,
    description: 'Limpeza completa da residência incluindo todos os cômodos',
    duration: 120, // minutos
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'limpeza-comercial',
    name: 'Limpeza Comercial',
    category: 'Limpeza',
    icon: 'business',
    basePrice: 35.0,
    description: 'Limpeza de escritórios e estabelecimentos comerciais',
    duration: 180,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'limpeza-pos-obra',
    name: 'Limpeza Pós-Obra',
    category: 'Limpeza',
    icon: 'construction',
    basePrice: 45.0,
    description: 'Limpeza especializada após reformas e construções',
    duration: 240,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'jardinagem',
    name: 'Jardinagem',
    category: 'Jardim',
    icon: 'local_florist',
    basePrice: 30.0,
    description: 'Cuidados com jardim, poda e manutenção de plantas',
    duration: 150,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'cozinha',
    name: 'Serviços de Cozinha',
    category: 'Culinária',
    icon: 'restaurant',
    basePrice: 40.0,
    description: 'Preparo de refeições e organização da cozinha',
    duration: 180,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'lavanderia',
    name: 'Lavanderia',
    category: 'Limpeza',
    icon: 'local_laundry_service',
    basePrice: 20.0,
    description: 'Lavagem, secagem e passagem de roupas',
    duration: 120,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'organizacao',
    name: 'Organização',
    category: 'Organização',
    icon: 'inventory_2',
    basePrice: 35.0,
    description: 'Organização de ambientes e objetos pessoais',
    duration: 180,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'cuidado-idosos',
    name: 'Cuidado com Idosos',
    category: 'Cuidados',
    icon: 'elderly',
    basePrice: 50.0,
    description: 'Acompanhamento e cuidados básicos com idosos',
    duration: 240,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'pet-care',
    name: 'Cuidado com Pets',
    category: 'Pets',
    icon: 'pets',
    basePrice: 25.0,
    description: 'Cuidados básicos com animais de estimação',
    duration: 90,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'manutencao-basica',
    name: 'Manutenção Básica',
    category: 'Manutenção',
    icon: 'build',
    basePrice: 40.0,
    description: 'Pequenos reparos e manutenções domésticas',
    duration: 120,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  }
];

async function populateServices() {
  console.log('Populando serviços...');
  
  const batch = db.batch();
  
  services.forEach(service => {
    const docRef = db.collection('services').doc(service.id);
    batch.set(docRef, service);
  });
  
  try {
    await batch.commit();
    console.log(`✅ ${services.length} serviços adicionados com sucesso!`);
  } catch (error) {
    console.error('❌ Erro ao adicionar serviços:', error);
  }
}

// Dados de configuração do app
const appConfig = {
  id: 'app-config',
  appName: 'E-Maid',
  version: '1.0.0',
  supportEmail: 'suporte@emaid.com.br',
  supportPhone: '+55 11 99999-9999',
  termsUrl: 'https://emaid.com.br/termos',
  privacyUrl: 'https://emaid.com.br/privacidade',
  minBookingHours: 2,
  maxBookingHours: 8,
  cancellationHours: 24,
  serviceFeePercentage: 10,
  createdAt: admin.firestore.FieldValue.serverTimestamp(),
  updatedAt: admin.firestore.FieldValue.serverTimestamp()
};

async function populateConfig() {
  console.log('Adicionando configurações do app...');
  
  try {
    await db.collection('config').doc('app-config').set(appConfig);
    console.log('✅ Configurações adicionadas com sucesso!');
  } catch (error) {
    console.error('❌ Erro ao adicionar configurações:', error);
  }
}

// Executar população
async function main() {
  console.log('🚀 Iniciando população do Firestore...');
  console.log('=====================================');
  
  await populateServices();
  await populateConfig();
  
  console.log('=====================================');
  console.log('✅ População concluída!');
  console.log('\nPróximos passos:');
  console.log('1. Verifique os dados no Firebase Console');
  console.log('2. Configure as regras de segurança');
  console.log('3. Teste a aplicação');
  
  process.exit(0);
}

main().catch(console.error);