# 🔧 Configurações do Projeto E-Maid

## 📱 Informações Básicas

### Aplicativo
- **Nome:** E-Maid
- **Package:** com.example.e_maid
- **Versão:** 1.0.0+1
- **Flutter SDK:** 3.16.0+
- **Dart SDK:** >=3.2.0 <4.0.0

### Plataformas Suportadas
- ✅ Android (API 21+)
- ✅ iOS (em desenvolvimento)
- ✅ Web (Firebase Hosting)

---

## 🔐 Configurações de Segurança

### Keystore Android
- **Arquivo:** `android/upload-keystore.jks`
- **Alias:** upload
- **Algoritmo:** RSA 2048 bits
- **Validade:** 10.000 dias
- **Organização:** E-Maid Services

### Credenciais (key.properties)
```properties
storePassword=emaid2024
keyPassword=emaid2024
keyAlias=upload
storeFile=../upload-keystore.jks
```

⚠️ **IMPORTANTE:** Nunca commitar o arquivo `key.properties` ou `upload-keystore.jks`

---

## 🔥 Configurações Firebase

### Projeto Firebase
- **Project ID:** e-maid-production
- **Nome:** E-Maid Production
- **Região:** southamerica-east1 (São Paulo)

### Serviços Habilitados
- ✅ Authentication (Email/Password)
- ✅ Firestore Database
- ✅ Storage
- ✅ Hosting
- ✅ Analytics
- ✅ Crashlytics

### Configurações por Plataforma

#### Android
- **App ID:** 1:123456789012:android:abcdef123456789012345678
- **Package:** com.example.e_maid
- **SHA-1:** (Gerado automaticamente pelo keystore)

#### iOS
- **App ID:** 1:123456789012:ios:abcdef123456789012345678
- **Bundle ID:** com.example.eMaid

#### Web
- **App ID:** 1:123456789012:web:abcdef123456789012345678
- **Auth Domain:** e-maid-production.firebaseapp.com

---

## 📦 Dependências Principais

### Core
```yaml
flutter:
  sdk: flutter
cupertino_icons: ^1.0.2
```

### Firebase
```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
cloud_firestore: ^4.13.6
firebase_storage: ^11.5.6
```

### Estado e Navegação
```yaml
provider: ^6.1.1
```

### Utilitários
```yaml
intl: ^0.18.1
image_picker: ^1.0.4
```

---

## 🏗️ Estrutura do Projeto

```
e_maid/
├── lib/
│   ├── main.dart                 # Ponto de entrada
│   ├── firebase_options.dart     # Configurações Firebase
│   ├── models/                   # Modelos de dados
│   ├── services/                 # Serviços (Firebase, API)
│   ├── providers/                # Gerenciamento de estado
│   ├── screens/                  # Telas do aplicativo
│   ├── widgets/                  # Componentes reutilizáveis
│   └── utils/                    # Utilitários e helpers
├── android/
│   ├── app/
│   │   ├── build.gradle.kts      # Configurações Android
│   │   ├── google-services.json  # Firebase Android
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── res/              # Recursos (ícones, etc.)
│   ├── key.properties           # Credenciais de assinatura
│   └── upload-keystore.jks      # Keystore de produção
├── assets/
│   ├── images/                  # Imagens do app
│   ├── fonts/                   # Fontes customizadas
│   ├── ic_launcher_512.svg      # Ícone 512x512
│   └── feature_banner_1024x500.svg # Banner da loja
└── build/
    └── app/outputs/
        ├── flutter-apk/
        │   └── app-release.apk   # APK de produção
        └── bundle/release/
            └── app-release.aab   # App Bundle
```

---

## 🎨 Design System

### Cores Principais
```dart
// Cores do tema
Primary: #2196F3 (Azul)
Secondary: #4CAF50 (Verde)
Accent: #FF9800 (Laranja)
Background: #FAFAFA (Cinza claro)
Surface: #FFFFFF (Branco)
Error: #F44336 (Vermelho)
```

### Tipografia
- **Fonte principal:** Roboto
- **Fonte secundária:** Material Icons
- **Tamanhos:** 12, 14, 16, 18, 20, 24, 32sp

### Componentes
- **Material Design 3**
- **Adaptive widgets** para iOS
- **Custom widgets** para funcionalidades específicas

---

## 🚀 Scripts de Build

### Desenvolvimento
```bash
# Executar em modo debug
flutter run

# Hot reload ativo
flutter run --hot

# Executar em dispositivo específico
flutter run -d <device_id>
```

### Produção
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recomendado)
flutter build appbundle --release

# Build para iOS
flutter build ios --release

# Build para Web
flutter build web --release
```

### Script Automatizado
```bash
# Windows
.\build_release.bat

# Linux/Mac
./build_release.sh
```

---

## 🔍 Testes

### Estrutura de Testes
```
test/
├── unit/                    # Testes unitários
│   ├── models/
│   ├── services/
│   └── providers/
├── widget/                  # Testes de widgets
│   └── screens/
└── integration/             # Testes de integração
    └── app_test.dart
```

### Comandos
```bash
# Executar todos os testes
flutter test

# Testes com coverage
flutter test --coverage

# Testes de integração
flutter drive --target=test_driver/app.dart
```

---

## 📊 Monitoramento

### Firebase Analytics
- **Eventos customizados:** Login, cadastro, agendamento
- **Conversões:** Registro → Primeiro agendamento
- **Audiência:** Segmentação por tipo de usuário

### Crashlytics
- **Crash reports** automáticos
- **Custom logs** para debug
- **User identification** para suporte

### Performance Monitoring
- **App startup time**
- **Screen rendering**
- **Network requests**

---

## 🌐 Internacionalização

### Idiomas Suportados
- 🇧🇷 Português (Brasil) - Principal
- 🇺🇸 Inglês - Futuro
- 🇪🇸 Espanhol - Futuro

### Configuração
```yaml
# pubspec.yaml
flutter:
  generate: true

# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_pt.arb
output-localization-file: app_localizations.dart
```

---

## 🔧 Configurações de Desenvolvimento

### VS Code Extensions
- Flutter
- Dart
- Firebase
- GitLens
- Error Lens

### Android Studio Plugins
- Flutter
- Dart
- Firebase
- ADB Idea

### Configurações Recomendadas
```json
// .vscode/settings.json
{
  "dart.flutterSdkPath": "C:\\flutter",
  "dart.debugExternalPackageLibraries": true,
  "dart.debugSdkLibraries": false,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

---

## 📋 Checklist de Manutenção

### Semanal
- [ ] Verificar dependências desatualizadas
- [ ] Revisar crash reports
- [ ] Analisar métricas de performance
- [ ] Backup do banco de dados

### Mensal
- [ ] Atualizar Flutter SDK
- [ ] Revisar regras de segurança Firestore
- [ ] Analisar custos Firebase
- [ ] Testar em novos dispositivos

### Trimestral
- [ ] Renovar certificados
- [ ] Revisar política de privacidade
- [ ] Atualizar documentação
- [ ] Planejar novas features

---

## 📞 Contatos e Suporte

### Equipe de Desenvolvimento
- **Lead Developer:** [Nome]
- **Firebase Admin:** [Nome]
- **UI/UX Designer:** [Nome]

### Recursos Externos
- **Google Play Console:** https://play.google.com/console
- **Firebase Console:** https://console.firebase.google.com
- **Flutter Docs:** https://docs.flutter.dev
- **Material Design:** https://material.io

---

*Última atualização: $(Get-Date -Format "dd/MM/yyyy HH:mm")*
*Versão do documento: 1.0*