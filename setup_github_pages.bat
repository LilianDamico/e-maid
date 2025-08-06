@echo off
echo ========================================
echo    HOSPEDAGEM DOCUMENTOS LEGAIS
echo         GitHub Pages Setup
echo ========================================
echo.

REM Criar diretório para GitHub Pages
mkdir github_pages 2>nul
cd github_pages

REM Inicializar repositório Git
git init

REM Criar arquivo index.html
echo ^<!DOCTYPE html^> > index.html
echo ^<html lang="pt-BR"^> >> index.html
echo ^<head^> >> index.html
echo     ^<meta charset="UTF-8"^> >> index.html
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> index.html
echo     ^<title^>E-Maid - Documentos Legais^</title^> >> index.html
echo     ^<style^> >> index.html
echo         body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; } >> index.html
echo         h1 { color: #00BCD4; } >> index.html
echo         .doc-link { display: block; margin: 10px 0; padding: 15px; background: #f5f5f5; text-decoration: none; color: #333; border-radius: 5px; } >> index.html
echo         .doc-link:hover { background: #e0e0e0; } >> index.html
echo     ^</style^> >> index.html
echo ^</head^> >> index.html
echo ^<body^> >> index.html
echo     ^<h1^>E-Maid - Documentos Legais^</h1^> >> index.html
echo     ^<p^>Documentos oficiais do aplicativo E-Maid^</p^> >> index.html
echo     ^<a href="privacy-policy.html" class="doc-link"^>📋 Política de Privacidade^</a^> >> index.html
echo     ^<a href="terms-of-service.html" class="doc-link"^>📄 Termos de Uso^</a^> >> index.html
echo ^</body^> >> index.html
echo ^</html^> >> index.html

REM Converter Markdown para HTML
echo Convertendo documentos...

REM Copiar e converter PRIVACY_POLICY.md
copy "..\PRIVACY_POLICY.md" "privacy_policy_temp.md" >nul
powershell -Command "(Get-Content 'privacy_policy_temp.md') -replace '^# ', '<h1>' -replace '^## ', '<h2>' -replace '^### ', '<h3>' | Set-Content 'privacy-policy.html'"
powershell -Command "(Get-Content 'privacy-policy.html') -replace '$', '</h1>' -replace '</h1></h1>', '</h1>' | Set-Content 'privacy-policy.html'"

REM Copiar e converter TERMS_OF_SERVICE.md
copy "..\TERMS_OF_SERVICE.md" "terms_temp.md" >nul
powershell -Command "(Get-Content 'terms_temp.md') -replace '^# ', '<h1>' -replace '^## ', '<h2>' -replace '^### ', '<h3>' | Set-Content 'terms-of-service.html'"
powershell -Command "(Get-Content 'terms-of-service.html') -replace '$', '</h1>' -replace '</h1></h1>', '</h1>' | Set-Content 'terms-of-service.html'"

REM Limpar arquivos temporários
del privacy_policy_temp.md terms_temp.md 2>nul

echo.
echo ✅ Arquivos HTML criados com sucesso!
echo.
echo 📋 PRÓXIMOS PASSOS:
echo 1. Crie um repositório público no GitHub
echo 2. Execute os comandos abaixo:
echo.
echo git add .
echo git commit -m "Documentos legais E-Maid"
echo git branch -M main
echo git remote add origin https://github.com/SEU_USUARIO/emaid-legal-docs.git
echo git push -u origin main
echo.
echo 3. Ative GitHub Pages nas configurações do repositório
echo 4. Seus documentos estarão em:
echo    https://SEU_USUARIO.github.io/emaid-legal-docs/privacy-policy.html
echo    https://SEU_USUARIO.github.io/emaid-legal-docs/terms-of-service.html
echo.
pause