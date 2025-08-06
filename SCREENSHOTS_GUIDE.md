# Guia de Capturas de Tela - Google Play Store

## 📱 Capturas de Tela Necessárias

### Requisitos Técnicos
- **Formato:** PNG ou JPEG
- **Quantidade:** Mínimo 2, máximo 8
- **Resolução:** 16:9 ou 9:16 (recomendado)
- **Tamanho mínimo:** 320px
- **Tamanho máximo:** 3840px

### 📋 Lista de Telas para Capturar

#### 1. Tela de Login ✅
- **Arquivo:** `screenshot_01_login.png`
- **Descrição:** "Acesso rápido e seguro"
- **Elementos importantes:**
  - Logo E-Maid
  - Campos de login
  - Botão de entrada
  - Link para cadastro

#### 2. Catálogo de Serviços ✅
- **Arquivo:** `screenshot_02_services.png`
- **Descrição:** "Diversos serviços disponíveis"
- **Elementos importantes:**
  - Lista de serviços
  - Preços visíveis
  - Interface limpa
  - Navegação por abas

#### 3. Tela de Agendamentos ✅
- **Arquivo:** `screenshot_03_bookings.png`
- **Descrição:** "Gerencie seus agendamentos"
- **Elementos importantes:**
  - Lista de agendamentos
  - Status dos serviços
  - Informações do profissional
  - Data e horário

#### 4. Perfil do Usuário ✅
- **Arquivo:** `screenshot_04_profile.png`
- **Descrição:** "Perfil personalizado"
- **Elementos importantes:**
  - Informações do usuário
  - Menu de opções
  - Configurações
  - Área profissional (se aplicável)

#### 5. Tela de Cadastro ✅
- **Arquivo:** `screenshot_05_register.png`
- **Descrição:** "Cadastro simples e rápido"
- **Elementos importantes:**
  - Formulário de cadastro
  - Seleção de tipo de usuário
  - Validação de campos
  - Interface intuitiva

#### 6. Detalhes do Serviço (Opcional) ✅
- **Arquivo:** `screenshot_06_service_details.png`
- **Descrição:** "Informações detalhadas"
- **Elementos importantes:**
  - Descrição do serviço
  - Preço e duração
  - Botão de agendamento
  - Avaliações

### 🎨 Dicas para Capturas de Qualidade

#### Preparação do Dispositivo
1. **Limpe a tela** do dispositivo
2. **Configure o brilho** para máximo
3. **Desative notificações** temporariamente
4. **Use dados fictícios** realistas
5. **Verifique a bateria** (mostrar 100% ou ocultar)

#### Configurações de Captura
1. **Resolução nativa** do dispositivo
2. **Orientação portrait** (vertical)
3. **Sem elementos de debug** visíveis
4. **Interface completa** (sem cortes)

#### Conteúdo das Telas
1. **Dados realistas** mas não pessoais
2. **Textos legíveis** e bem formatados
3. **Cores vibrantes** e contrastantes
4. **Elementos interativos** destacados

### 📐 Especificações por Dispositivo

#### Smartphone (Obrigatório)
- **Resolução recomendada:** 1080x1920 ou 1440x2560
- **Aspect ratio:** 9:16
- **Quantidade:** 2-8 capturas

#### Tablet (Opcional)
- **Resolução recomendada:** 1200x1920 ou 1600x2560
- **Aspect ratio:** 10:16 ou 3:4
- **Quantidade:** 1-8 capturas

### 🖼️ Processamento das Imagens

#### Ferramentas Recomendadas
- **Android Studio:** Device Frame Screenshots
- **Figma:** Para adicionar molduras
- **Canva:** Para criar composições
- **GIMP/Photoshop:** Para edições avançadas

#### Edições Permitidas
1. **Adicionar moldura** do dispositivo
2. **Ajustar brilho/contraste** levemente
3. **Redimensionar** mantendo proporção
4. **Adicionar sombra** sutil

#### Edições Proibidas
1. **Alterar conteúdo** da interface
2. **Adicionar elementos** não existentes
3. **Modificar textos** ou preços
4. **Usar imagens** de outros apps

### 📝 Descrições Sugeridas

#### Para cada captura, use descrições atrativas:

1. **"Acesso rápido e seguro ao seu app de serviços domésticos"**
2. **"Encontre profissionais qualificados para limpeza e organização"**
3. **"Gerencie todos os seus agendamentos em um só lugar"**
4. **"Perfil personalizado com área profissional integrada"**
5. **"Cadastro simples para clientes e profissionais"**
6. **"Informações detalhadas de cada serviço disponível"**

### ✅ Checklist Final

- [ ] Todas as capturas em alta resolução
- [ ] Orientação consistente (portrait)
- [ ] Dados fictícios realistas
- [ ] Interface limpa e profissional
- [ ] Cores vibrantes e legíveis
- [ ] Sem elementos de debug
- [ ] Arquivos nomeados corretamente
- [ ] Tamanho otimizado (< 8MB cada)
- [ ] Formato PNG ou JPEG
- [ ] Testado em diferentes tamanhos de tela

### 🚀 Upload no Google Play Console

1. Acesse **Google Play Console**
2. Vá em **Presença na loja > Listagem principal**
3. Role até **Capturas de tela do telefone**
4. Faça upload das imagens na ordem desejada
5. Adicione descrições para cada captura
6. Salve as alterações
7. Visualize a prévia antes de publicar

### 📱 Comando para Captura via ADB

```bash
# Conectar dispositivo via USB
adb devices

# Capturar tela
adb shell screencap -p /sdcard/screenshot.png

# Baixar para o computador
adb pull /sdcard/screenshot.png ./screenshot_01_login.png

# Limpar arquivo do dispositivo
adb shell rm /sdcard/screenshot.png
```

### 🎯 Dicas de Marketing

1. **Primeira impressão:** A primeira captura é a mais importante
2. **Sequência lógica:** Mostre o fluxo natural do usuário
3. **Destaque benefícios:** Foque nos diferenciais do app
4. **Qualidade visual:** Invista em capturas profissionais
5. **Teste A/B:** Experimente diferentes ordens e descrições

---

**Lembre-se:** As capturas de tela são fundamentais para a conversão de downloads. Invista tempo para criar imagens atrativas e representativas do seu aplicativo!