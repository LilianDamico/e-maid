# Guia de Publicação no Google Play Store - E-Maid

## 📋 Documentos Legais Criados

### ✅ Política de Privacidade
- **Arquivo:** `PRIVACY_POLICY.md`
- **Status:** Completa e em conformidade com LGPD
- **Conteúdo:** Coleta de dados, uso, compartilhamento, direitos do usuário
- **Hospedagem necessária:** Deve ser disponibilizada online

### ✅ Termos de Uso
- **Arquivo:** `TERMS_OF_SERVICE.md`
- **Status:** Completo com todas as cláusulas necessárias
- **Conteúdo:** Regras de uso, responsabilidades, limitações
- **Hospedagem necessária:** Deve ser disponibilizada online

## 🌐 Hospedagem dos Documentos

### Opção 1: GitHub Pages (Gratuito)
1. Criar repositório público no GitHub
2. Fazer upload dos arquivos `.md`
3. Ativar GitHub Pages nas configurações
4. URLs ficam: `https://[usuario].github.io/[repo]/PRIVACY_POLICY.html`

### Opção 2: Site da Empresa
1. Converter arquivos `.md` para HTML
2. Fazer upload para seu site
3. URLs: `https://seusite.com.br/privacy-policy`

### Opção 3: Firebase Hosting (Recomendado)
1. Já configurado no projeto
2. Converter `.md` para HTML
3. Fazer deploy com `firebase deploy`

## 📱 Preparação para Google Play Console

### 1. Informações do App
- **Nome:** E-Maid
- **Descrição curta:** Conecte-se com profissionais de limpeza qualificados
- **Descrição completa:** [Ver seção abaixo]
- **Categoria:** Casa e decoração
- **Classificação de conteúdo:** Livre

### 2. Recursos Gráficos Necessários
- **Ícone do app:** 512x512 px (PNG)
- **Banner de recursos:** 1024x500 px
- **Capturas de tela:** Mínimo 2, máximo 8 (telefone)
- **Capturas de tela tablet:** Opcional mas recomendado

### 3. Descrição Completa Sugerida

```
🏠 E-Maid - Serviços Domésticos de Qualidade

Encontre profissionais qualificados para limpeza e organização da sua casa com segurança e praticidade.

✨ PRINCIPAIS RECURSOS:
• Profissionais verificados e avaliados
• Agendamento fácil e rápido
• Pagamento seguro integrado
• Sistema de avaliações transparente
• Suporte ao cliente dedicado

🔒 SEGURANÇA:
• Verificação de antecedentes dos profissionais
• Pagamentos protegidos
• Dados criptografados
• Conformidade com LGPD

💰 COMO FUNCIONA:
1. Escolha o serviço desejado
2. Selecione um profissional qualificado
3. Agende data e horário
4. Pague com segurança pelo app
5. Avalie o serviço prestado

🏆 SERVIÇOS DISPONÍVEIS:
• Limpeza residencial completa
• Limpeza pós-obra
• Organização de ambientes
• Limpeza de escritórios
• Serviços personalizados

Baixe agora e transforme a limpeza da sua casa em uma experiência simples e confiável!
```

### 4. Palavras-chave (ASO)
- limpeza
- doméstica
- casa
- profissionais
- serviços
- agendamento
- faxina
- organização

## 🔐 Configurações de Privacidade

### Dados Coletados (Para declarar no Play Console)

#### Informações Pessoais
- ✅ Nome
- ✅ Endereço de e-mail
- ✅ Número de telefone
- ✅ Endereço físico
- ✅ Fotos do usuário

#### Informações Financeiras
- ✅ Informações de pagamento
- ✅ Histórico de transações

#### Localização
- ✅ Localização aproximada
- ✅ Localização precisa (para serviços)

#### Atividade do App
- ✅ Interações no app
- ✅ Histórico de pesquisas
- ✅ Conteúdo gerado pelo usuário

### Finalidades do Uso de Dados
- ✅ Funcionalidade do app
- ✅ Análises
- ✅ Comunicação com desenvolvedores
- ✅ Publicidade ou marketing
- ✅ Prevenção de fraudes

## 📋 Checklist Pré-Publicação

### Documentação Legal
- [x] Política de Privacidade criada
- [x] Termos de Uso criados
- [ ] Documentos hospedados online
- [ ] URLs adicionadas no Play Console

### App Bundle
- [x] APK/AAB gerado com sucesso
- [x] Assinado com keystore de produção
- [x] Testado em dispositivos reais
- [ ] Versão de produção final

### Recursos Gráficos
- [ ] Ícone do app (512x512)
- [ ] Banner de recursos (1024x500)
- [ ] Capturas de tela (mínimo 2)
- [ ] Vídeo promocional (opcional)

### Configurações
- [ ] Classificação de conteúdo
- [ ] Países de distribuição
- [ ] Preço (gratuito)
- [ ] Categoria selecionada

### Testes
- [ ] Teste interno configurado
- [ ] Teste fechado (opcional)
- [ ] Teste aberto (opcional)

## 🚀 Processo de Publicação

### Fase 1: Preparação
1. Hospedar documentos legais
2. Criar recursos gráficos
3. Preparar descrições
4. Gerar AAB final

### Fase 2: Upload
1. Acessar Google Play Console
2. Criar novo app
3. Fazer upload do AAB
4. Preencher informações
5. Adicionar recursos gráficos

### Fase 3: Configuração
1. Definir classificação de conteúdo
2. Configurar política de privacidade
3. Selecionar países
4. Configurar preços

### Fase 4: Revisão
1. Enviar para revisão
2. Aguardar aprovação (1-3 dias)
3. Corrigir problemas se houver
4. Publicação automática após aprovação

## 📞 Suporte

Em caso de dúvidas durante o processo de publicação:
- Documentação oficial: https://developer.android.com/distribute/console
- Suporte Google Play: https://support.google.com/googleplay/android-developer

## 🔄 Atualizações Futuras

Para atualizações do app:
1. Incrementar `versionCode` e `versionName`
2. Gerar novo AAB
3. Fazer upload na mesma entrada do Play Console
4. Adicionar notas da versão
5. Enviar para revisão

---

**Nota:** Lembre-se de manter os documentos legais sempre atualizados e acessíveis online durante toda a vida útil do aplicativo na Play Store.