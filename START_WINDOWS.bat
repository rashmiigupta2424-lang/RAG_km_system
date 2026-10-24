@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ============================================
echo RAG KM System - Start
 echo ============================================

if not exist venv\Scripts\python.exe (
  echo ERROR: Python environment not found.
  echo Run SETUP_WINDOWS.bat first.
  pause
  exit /b 1
)
if not exist frontend-react\node_modules (
  echo ERROR: Frontend dependencies not found.
  echo Run SETUP_WINDOWS.bat first.
  pause
  exit /b 1
)
if not exist .env (
  echo ERROR: .env not found.
  echo Run SETUP_WINDOWS.bat first, then add GEMINI_API_KEY.
  pause
  exit /b 1
)

findstr /R /C:"^GEMINI_API_KEY=your_" /C:"^GEMINI_API_KEY=YOUR_" /C:"^GEMINI_API_KEY=replace-" .env >nul 2>nul
if not errorlevel 1 (
  echo ERROR: GEMINI_API_KEY is still a placeholder in .env.
  echo Edit .env and add your real Gemini API key.
  pause
  exit /b 1
)

start "RAG KM - Backend" cmd /k "cd /d "%~dp0" && venv\Scripts\python.exe -m uvicorn backend.main:app --host 127.0.0.1 --port 8000 --reload"
timeout /t 2 /nobreak >nul
start "RAG KM - Frontend" cmd /k "cd /d "%~dp0frontend-react" && npm.cmd run dev -- --host 127.0.0.1"

echo.
echo Frontend: http://localhost:5173
echo Backend:  http://localhost:8000
echo API docs: http://localhost:8000/docs
echo.
echo Keep the two server windows open.
exit /b 0
