# E-Maid - Plataforma de Serviços Domésticos

## 📱 Sobre o Projeto

E-Maid é uma plataforma Flutter que conecta clientes a profissionais de serviços domésticos, oferecendo uma interface moderna e intuitiva para agendamento de serviços como limpeza, jardinagem, cozinha, e muito mais.

**🔥 Agora com Firebase integrado para produção!**

## Funcionalidades

### ✅ Implementadas
- **Tela de Splash**: Apresentação inicial do aplicativo com logo e botão para começar
- **Sistema de Login**: Autenticação de usuários com validação de campos
- **Cadastro de Usuários**: Registro para clientes e profissionais
- **Página Principal**: Interface com navegação por abas
- **Catálogo de Serviços**: Lista de serviços disponíveis com preços
- **Agendamentos**: Visualização de serviços agendados
- **Perfil do Usuário**: Gerenciamento de dados pessoais

### 🔄 Em Desenvolvimento
- Edição de perfil
- Histórico de serviços
- Configurações do aplicativo
- Sistema de pagamento
- Avaliações e comentários
- Notificações push

## 🚀 Tecnologias Utilizadas

- **Frontend**: Flutter 3.16.0
- **Backend**: Firebase (Authentication, Firestore, Storage, Hosting)
- **Estado**: Provider
- **UI**: Material Design 3
- **Deploy**: Firebase Hosting
- **Banco de Dados**: Cloud Firestore
- **Autenticação**: Firebase Auth
- **Storage**: Firebase Storage

## Estrutura do Projeto
```
lib/
└── main.dart          # Arquivo principal com todas as telas

assets/
├── logo.png           # Logo do aplicativo
└── fonts/             # Fontes personalizadas (Quicksand)
    └── static/
        ├── Quicksand-Regular.ttf
        └── Quicksand-Bold.ttf
```

## 📋 Pré-requisitos

- Flutter SDK 3.16.0+
- Dart 3.2.0+
- Node.js 18+ (para Firebase CLI)
- Conta no Firebase

## 🛠️ Instalação e Configuração

### 1. Clone o Repositório

```bash
git clone <repository-url>
cd e_maid
```

### 2. Instale as Dependências

```bash
flutter pub get
```

### 3. Configure o Firebase

Siga as instruções detalhadas no arquivo [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md).

### 4. Execute o Projeto

```bash
# Para desenvolvimento web
flutter run -d chrome

# Para Android
flutter run -d android

# Para iOS
flutter run -d ios
```

### Plataformas Suportadas
- ✅ Web (Chrome)
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Telas do Aplicativo

### 1. Splash Screen
- Logo do E-Maid
- Mensagem de boas-vindas
- Botão "Começar"

### 2. Login
- Campos de e-mail e senha
- Validação de formulário
- Link para cadastro

### 3. Cadastro
- Nome completo
- E-mail
- Telefone
- Senha
- Tipo de usuário (Cliente/Profissional)

### 4. Página Principal
Navegação por abas:
- **Serviços**: Catálogo de serviços disponíveis
- **Agendamentos**: Lista de serviços agendados
- **Perfil**: Dados do usuário e configurações

## Serviços Disponíveis
- Limpeza Residencial - R$ 80,00
- Limpeza Comercial - R$ 120,00
- Limpeza Pós-Obra - R$ 150,00
- Limpeza de Escritório - R$ 100,00

## Design
- **Cor Principal**: Teal (Verde-azulado)
- **Fonte**: Quicksand
- **Estilo**: Material Design
- **Interface**: Limpa e intuitiva

## 🔧 Scripts Disponíveis

### Deploy Automatizado

```bash
# Windows
.\deploy.bat
```

### População Inicial do Firestore

```bash
cd scripts
npm install
node populate_firestore.js
```

## 🚀 Deploy

### Deploy Automático

Use o script `deploy.bat` que executa:
1. Limpeza do cache
2. Instalação de dependências
3. Execução de testes
4. Build para web
5. Deploy no Firebase Hosting

### Deploy Manual

```bash
# Build
flutter build web --release

# Deploy
firebase deploy --only hosting
```

## 📱 Builds para Mobile

### Android

```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
# Requer macOS e Xcode
flutter build ios --release
```

## 🔐 Configurações de Segurança

### Firestore Rules
As regras de segurança estão definidas em `firestore.rules` e incluem:
- Usuários só podem acessar seus próprios dados
- Profissionais podem ser lidos por todos, mas só editados pelo próprio
- Agendamentos só são acessíveis pelas partes envolvidas

### Storage Rules
As regras do Storage em `storage.rules` garantem:
- Usuários só podem fazer upload de suas próprias imagens
- Limite de 5MB por arquivo
- Apenas imagens são permitidas

## 📝 Dados Iniciais

Antes do primeiro uso em produção:

1. Execute o script de população: `node scripts/populate_firestore.js`
2. Remova ou substitua dados mock em `lib/data/`
3. Configure variáveis de ambiente de produção

## 🐛 Troubleshooting

### Problemas Comuns

1. **Erro de CORS**: Configure domínios autorizados no Firebase Auth
2. **Build falha**: Execute `flutter clean && flutter pub get`
3. **Firebase não conecta**: Verifique `firebase_options.dart`

## 📞 Suporte

- **Email**: suporte@emaid.com.br
- **Telefone**: +55 11 99999-9999
- **Documentação**: [Firebase Setup](FIREBASE_SETUP.md)

## 🎯 Roadmap

- [ ] Integração com pagamentos (Stripe/PagSeguro)
- [ ] Chat em tempo real
- [ ] Geolocalização avançada
- [ ] Notificações push
- [ ] App mobile nativo
- [ ] Dashboard administrativo
- [ ] API REST para integrações

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

---

**Desenvolvido com ❤️ pela equipe E-Maid**
