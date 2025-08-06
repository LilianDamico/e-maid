@echo off
echo ========================================
echo    E-MAID - BUILD RELEASE SCRIPT
echo ========================================
echo.

REM Verificar se Flutter está instalado
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Flutter não encontrado no PATH
    echo Instale o Flutter e adicione ao PATH
    pause
    exit /b 1
)

echo [1/6] Limpando builds anteriores...
flutter clean
if %errorlevel% neq 0 (
    echo ERRO: Falha ao limpar projeto
    pause
    exit /b 1
)

echo.
echo [2/6] Obtendo dependências...
flutter pub get
if %errorlevel% neq 0 (
    echo ERRO: Falha ao obter dependências
    pause
    exit /b 1
)

echo.
echo [3/6] Verificando configurações de assinatura...
if not exist "android\key.properties" (
    echo ERRO: Arquivo key.properties não encontrado
    echo Execute: copy android\key.properties.example android\key.properties
    echo E configure as credenciais corretas
    pause
    exit /b 1
)

if not exist "android\upload-keystore.jks" (
    echo ERRO: Keystore não encontrado
    echo Execute o comando para gerar o keystore
    pause
    exit /b 1
)

echo.
echo [4/6] Construindo APK de release...
flutter build apk --release
if %errorlevel% neq 0 (
    echo ERRO: Falha ao construir APK
    pause
    exit /b 1
)

echo.
echo [5/6] Construindo App Bundle de release...
flutter build appbundle --release
if %errorlevel% neq 0 (
    echo ERRO: Falha ao construir App Bundle
    pause
    exit /b 1
)

echo.
echo [6/6] Verificando arquivos gerados...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ APK: build\app\outputs\flutter-apk\app-release.apk
    for %%I in ("build\app\outputs\flutter-apk\app-release.apk") do echo    Tamanho: %%~zI bytes
) else (
    echo ❌ APK não encontrado
)

if exist "build\app\outputs\bundle\release\app-release.aab" (
    echo ✅ AAB: build\app\outputs\bundle\release\app-release.aab
    for %%I in ("build\app\outputs\bundle\release\app-release.aab") do echo    Tamanho: %%~zI bytes
) else (
    echo ❌ App Bundle não encontrado
)

echo.
echo ========================================
echo           BUILD CONCLUÍDO!
echo ========================================
echo.
echo Arquivos prontos para publicação:
echo - APK: build\app\outputs\flutter-apk\app-release.apk
echo - AAB: build\app\outputs\bundle\release\app-release.aab
echo.
echo Próximos passos:
echo 1. Hospedar documentos legais (PRIVACY_POLICY.md, TERMS_OF_SERVICE.md)
echo 2. Capturar telas do aplicativo (ver SCREENSHOTS_GUIDE.md)
echo 3. Fazer upload no Google Play Console
echo.
echo Consulte PUBLICATION_CHECKLIST.md para detalhes completos.
echo.
pause