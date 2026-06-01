@echo off
echo ====================================================
echo    INICIANDO AGENTE CNC - AMBIENTE AUTOMATIZADO
echo ====================================================

echo [1/2] Abrindo Servidor Python com Auto-Reload...
start "SERVIDOR PYTHON (BACKEND)" cmd /k "C:\Users\karol\AppData\Local\Python\pythoncore-3.14-64\python.exe" -m uvicorn server:app --host 0.0.0.0 --port 8000 --reload

echo [2/2] Abrindo Aplicativo Flutter...
start "APLICATIVO FLUTTER (FRONTEND)" cmd /k flutter run -d edge

echo ====================================================
echo    SISTEMA LIGADO! PODE FECHAR ESTA JANELA BASE.
echo ====================================================
pause
