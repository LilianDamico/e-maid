# Configuração do Firebase para E-Maid

## 1. Criar Projeto no Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Clique em "Adicionar projeto"
3. Nome do projeto: `e-maid-app`
4. Desabilite Google Analytics (opcional)
5. Clique em "Criar projeto"

## 2. Configurar Authentication

1. No painel do Firebase, vá em **Authentication**
2. Clique em "Começar"
3. Na aba **Sign-in method**, habilite:
   - **Email/Password**
4. Configure domínios autorizados se necessário

## 3. Configurar Firestore Database

1. No painel do Firebase, vá em **Firestore Database**
2. Clique em "Criar banco de dados"
3. Escolha **Modo de teste** (para desenvolvimento)
4. Selecione uma localização (ex: `southamerica-east1`)

### Regras de Segurança do Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Professionals can read/write their own data
    match /professionals/{professionalId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == professionalId;
    }
    
    // Services are read-only for all authenticated users
    match /services/{serviceId} {
      allow read: if request.auth != null;
    }
    
    // Bookings
    match /bookings/{bookingId} {
      allow read, write: if request.auth != null && 
        (resource.data.clientId == request.auth.uid || 
         resource.data.professionalId == request.auth.uid);
      allow create: if request.auth != null;
    }
    
    // Reviews
    match /reviews/{reviewId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.auth.uid == resource.data.clientId;
    }
    
    // Notifications
    match /notifications/{notificationId} {
      allow read, write: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```

## 4. Configurar Storage (Opcional)

1. No painel do Firebase, vá em **Storage**
2. Clique em "Começar"
3. Aceite as regras padrão
4. Selecione a mesma localização do Firestore

## 5. Configurar Hosting

1. No painel do Firebase, vá em **Hosting**
2. Clique em "Começar"
3. Instale o Firebase CLI:

```bash
npm install -g firebase-tools
```

4. Faça login no Firebase:

```bash
firebase login
```

5. Inicialize o projeto:

```bash
firebase init hosting
```

6. Selecione o projeto criado
7. Configure:
   - Public directory: `build/web`
   - Single-page app: `Yes`
   - Automatic builds: `No`

## 6. Configurar o App Flutter

### Instalar Firebase CLI Tools

```bash
dart pub global activate flutterfire_cli
```

### Configurar Firebase para Flutter

```bash
flutterfire configure
```

1. Selecione o projeto `e-maid-app`
2. Selecione as plataformas (Web, Android, iOS)
3. Isso gerará o arquivo `firebase_options.dart` automaticamente

## 7. Build e Deploy

### Build para Web

```bash
flutter build web --release
```

### Deploy para Firebase Hosting

```bash
firebase deploy --only hosting
```

### Deploy Completo (Hosting + Firestore Rules)

```bash
firebase deploy
```

## 8. Configurações de Produção

### Variáveis de Ambiente

Crie um arquivo `.env` (não commitado):

```env
FIREBASE_API_KEY=your-api-key
FIREBASE_PROJECT_ID=e-maid-app
FIREBASE_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_APP_ID=your-app-id
```

### Configurar Domínio Personalizado

1. No Firebase Hosting, clique em "Adicionar domínio personalizado"
2. Digite seu domínio (ex: `app.emaid.com.br`)
3. Siga as instruções para configurar DNS

## 9. Dados Iniciais (Opcional)

### Adicionar Serviços no Firestore

Você pode adicionar os serviços iniciais manualmente no console do Firestore ou criar um script:

```javascript
// Coleção: services
{
  "name": "Limpeza Residencial",
  "category": "Limpeza",
  "icon": "home",
  "basePrice": 25.0,
  "description": "Limpeza completa da residência",
  "createdAt": "timestamp"
}
```

## 10. Monitoramento

### Analytics (Opcional)

1. Habilite Google Analytics no projeto
2. Configure eventos personalizados no app

### Performance Monitoring

1. Adicione `firebase_performance` no pubspec.yaml
2. Configure métricas personalizadas

## 11. Comandos Úteis

```bash
# Ver logs do Firebase
firebase functions:log

# Testar localmente
firebase serve --only hosting

# Ver status do deploy
firebase hosting:channel:list

# Rollback (se necessário)
firebase hosting:clone SOURCE_SITE_ID:SOURCE_CHANNEL_ID TARGET_SITE_ID:live
```

## 12. Checklist de Deploy

- [ ] Firebase projeto criado
- [ ] Authentication configurado
- [ ] Firestore configurado com regras
- [ ] Firebase CLI instalado
- [ ] FlutterFire CLI configurado
- [ ] `firebase_options.dart` gerado
- [ ] Build web executado
- [ ] Deploy realizado
- [ ] Domínio configurado (se aplicável)
- [ ] SSL habilitado
- [ ] Dados iniciais adicionados
- [ ] Testes realizados

## Troubleshooting

### Erro de CORS
- Configure domínios autorizados no Firebase Authentication

### Erro de Permissão Firestore
- Verifique as regras de segurança
- Confirme se o usuário está autenticado

### Build Web Falha
- Execute `flutter clean`
- Execute `flutter pub get`
- Tente novamente o build

### Deploy Falha
- Verifique se está logado: `firebase login`
- Confirme o projeto: `firebase use --add`
- Verifique permissões do projeto