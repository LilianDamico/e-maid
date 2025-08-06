@echo off
echo ========================================
echo      CAPTURA DE TELAS E-MAID
echo    Para Google Play Store
echo ========================================
echo.

REM Criar diretório para screenshots
mkdir screenshots 2>nul
cd screenshots

echo 📱 PREPARAÇÃO DO DISPOSITIVO:
echo ✅ Conecte seu dispositivo Android via USB
echo ✅ Ative a Depuração USB
echo ✅ Configure o brilho para máximo
echo ✅ Desative notificações temporariamente
echo ✅ Certifique-se que o app está em modo release
echo.
pause

echo Verificando conexão ADB...
adb devices
echo.

if errorlevel 1 (
    echo ❌ ADB não encontrado. Instale o Android SDK.
    pause
    exit /b 1
)

echo 🎯 INICIANDO CAPTURAS...
echo.

REM Captura 1: Tela de Login
echo 📸 Captura 1/6: Tela de Login
echo Navegue até a tela de login e pressione Enter...
pause >nul
adb shell screencap -p /sdcard/screenshot_temp.png
adb pull /sdcard/screenshot_temp.png screenshot_01_login.png
adb shell rm /sdcard/screenshot_temp.png
echo ✅ screenshot_01_login.png salvo
echo.

REM Captura 2: Catálogo de Serviços
echo 📸 Captura 2/6: Catálogo de Serviços
echo Navegue até o catálogo de serviços e pressione Enter...
pause >nul
adb shell screencap -p /sdcard/screenshot_temp.png
adb pull /sdcard/screenshot_temp.png screenshot_02_services.png
adb shell rm /sdcard/screenshot_temp.png
echo ✅ screenshot_02_services.png salvo
echo.

REM Captura 3: Agendamentos
echo 📸 Captura 3/6: Tela de Agendamentos
echo Navegue até a tela de agendamentos e pressione Enter...
pause >nul
adb shell screencap -p /sdcard/screenshot_temp.png
adb pull /sdcard/screenshot_temp.png screenshot_03_bookings.png
adb shell rm /sdcard/screenshot_temp.png
echo ✅ screenshot_03_bookings.png salvo
echo.

REM Captura 4: Perfil do Usuário
echo 📸 Captura 4/6: Perfil do Usuário
echo Navegue até o perfil do usuário e pressione Enter...
pause >nul
adb shell screencap -p /sdcard/screenshot_temp.png
adb pull /sdcard/screenshot_temp.png screenshot_04_profile.png
adb shell rm /sdcard/screenshot_temp.png
echo ✅ screenshot_04_profile.png salvo
echo.

REM Captura 5: Tela de Cadastro
echo 📸 Captura 5/6: Tela de Cadastro
echo Navegue até a tela de cadastro e pressione Enter...
pause >nul
adb shell screencap -p /sdcard/screenshot_temp.png
adb pull /sdcard/screenshot_temp.png screenshot_05_register.png
adb shell rm /sdcard/screenshot_temp.png
echo ✅ screenshot_05_register.png salvo
echo.

REM Captura 6: Detalhes do Serviço
echo 📸 Captura 6/6: Detalhes do Serviço
echo Navegue até os detalhes de um serviço e pressione Enter...
pause >nul
adb shell screencap -p /sdcard/screenshot_temp.png
adb pull /sdcard/screenshot_temp.png screenshot_06_service_details.png
adb shell rm /sdcard/screenshot_temp.png
echo ✅ screenshot_06_service_details.png salvo
echo.

echo 🎉 TODAS AS CAPTURAS CONCLUÍDAS!
echo.
echo 📁 Arquivos salvos em: %cd%
dir *.png
echo.
echo 📋 PRÓXIMOS PASSOS:
echo 1. Verifique a qualidade das imagens
echo 2. Faça upload no Google Play Console
echo 3. Adicione descrições para cada captura
echo.
echo 💡 DICAS:
echo - Resolução mínima: 320px
echo - Resolução máxima: 3840px
echo - Formato: PNG (recomendado)
echo - Orientação: Portrait (9:16)
echo.
pause