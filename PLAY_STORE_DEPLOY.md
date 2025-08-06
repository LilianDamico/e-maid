# 📱 Deploy na Google Play Store - E-Maid

## 🔧 Pré-requisitos

1. **Conta Google Play Console** (taxa única de $25 USD)
2. **Java Development Kit (JDK)** instalado
3. **Android Studio** ou **Android SDK** configurado

## 📋 Passo a Passo

### 1️⃣ Criar Keystore para Assinatura

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Importante:** Guarde as senhas em local seguro!

### 2️⃣ Configurar Assinatura

1. Copie o arquivo `android/key.properties.example` para `android/key.properties`
2. Edite o arquivo `key.properties` com suas informações:

```properties
storePassword=SUA_SENHA_DO_KEYSTORE
keyPassword=SUA_SENHA_DA_CHAVE
keyAlias=upload
storeFile=../upload-keystore.jks
```

### 3️⃣ Build para Produção

**Opção A - Script Automatizado:**
```bash
./deploy.bat
```

**Opção B - Manual:**
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### 4️⃣ Upload na Play Console

1. Acesse [Google Play Console](https://play.google.com/console)
2. Crie novo aplicativo
3. Faça upload do arquivo `build/app/outputs/bundle/release/app-release.aab`
4. Preencha as informações obrigatórias:
   - Descrição do app
   - Screenshots (mínimo 2)
   - Ícone de alta resolução (512x512)
   - Ícone do app (192x192)
   - Política de privacidade (obrigatória)

## 📝 Informações do App

- **Nome:** E-Maid
- **Package:** com.emaid.app
- **Versão:** 1.0.0 (código 1)
- **Descrição:** E-Maid - Conecte-se com profissionais de limpeza qualificados

## 🔒 Permissões Configuradas

- `INTERNET` - Conexão com Firebase
- `ACCESS_NETWORK_STATE` - Verificar conectividade
- `CAMERA` - Captura de fotos
- `READ_EXTERNAL_STORAGE` - Leitura de imagens
- `ACCESS_FINE_LOCATION` - Localização precisa
- `ACCESS_COARSE_LOCATION` - Localização aproximada

## ⚠️ Importante

- **NUNCA** commite o arquivo `key.properties` com informações reais
- Mantenha backup seguro do keystore
- Teste o app em dispositivos reais antes do upload
- Primeira aprovação pode levar 1-3 dias

## 🚀 Próximos Passos

1. Configure Firebase Authentication na produção
2. Configure Firebase Storage
3. Implemente analytics
4. Configure crash reporting
5. Prepare materiais de marketing

---

**Arquivo gerado:** `build/app/outputs/bundle/release/app-release.aab`
**Tamanho aproximado:** ~15-25 MB