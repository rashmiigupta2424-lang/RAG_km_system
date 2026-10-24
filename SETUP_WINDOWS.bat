@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ============================================
echo RAG KM System - Windows Setup
echo ============================================

where py >nul 2>nul
if errorlevel 1 (
  echo ERROR: Python launcher ^(py^) not found.
  echo Install Python 3.11 and reopen this terminal.
  pause
  exit /b 1
)

py -3.11 --version >nul 2>nul
if errorlevel 1 (
  echo ERROR: Python 3.11 is required/recommended for this project.
  echo Install Python 3.11, then run this file again.
  pause
  exit /b 1
)

if not exist requirements.txt (
  echo ERROR: Run this file from the extracted project root.
  pause
  exit /b 1
)

if not exist venv\Scripts\python.exe (
  echo Creating Python virtual environment...
  py -3.11 -m venv venv
  if errorlevel 1 goto :error
)

echo Installing backend dependencies...
venv\Scripts\python.exe -m pip install --upgrade pip
if errorlevel 1 goto :error
venv\Scripts\python.exe -m pip install -r requirements.txt
if errorlevel 1 goto :error

if not exist .env copy /Y .env.example .env >nul
if not exist frontend-react\.env copy /Y frontend-react\.env.example frontend-react\.env >nul

where npm.cmd >nul 2>nul
if errorlevel 1 (
  echo ERROR: npm was not found. Install Node.js 20 LTS or newer.
  pause
  exit /b 1
)

echo Installing frontend dependencies...
cd frontend-react
npm.cmd ci
if errorlevel 1 goto :error
npm.cmd run build
if errorlevel 1 goto :error
cd ..

echo.
echo ============================================
echo SETUP COMPLETE
 echo ============================================
echo Edit .env and set your GEMINI_API_KEY.
echo Then double-click START_WINDOWS.bat
pause
exit /b 0

:error
cd /d "%~dp0"
echo.
echo SETUP FAILED. Read the error above.
pause
exit /b 1
