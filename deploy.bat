@echo off
echo ========================================
echo    E-MAID - SCRIPT DE DEPLOY
echo ========================================
echo.

echo [1/4] Limpando cache do Flutter...
flutter clean
if %errorlevel% neq 0 (
    echo ERRO: Falha ao limpar cache
    pause
    exit /b 1
)

echo [2/4] Instalando dependencias...
flutter pub get
if %errorlevel% neq 0 (
    echo ERRO: Falha ao instalar dependencias
    pause
    exit /b 1
)

echo [3/4] Fazendo build para Android (Release)...
flutter build appbundle --release
if %errorlevel% neq 0 (
    echo ERRO: Falha no build Android
    pause
    exit /b 1
)

echo [4/4] Build concluido com sucesso!
echo.
echo Arquivo gerado em: build\app\outputs\bundle\release\app-release.aab
echo.
echo ========================================
echo    DEPLOY CONCLUIDO COM SUCESSO!
echo ========================================
echo.
echo Proximo passo: Fazer upload do arquivo .aab na Google Play Console
echo URL: https://play.google.com/console
echo.
pause