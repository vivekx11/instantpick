@echo off
echo ========================================
echo Starting Admin Dashboard
echo ========================================
echo.

echo Checking backend...
cd backend
if not exist node_modules (
    echo Installing backend dependencies...
    call npm install
)

echo.
echo Starting backend server...
start cmd /k "npm start"

echo.
echo Waiting for backend to start...
timeout /t 5 /nobreak > nul

echo.
echo Starting admin app...
cd ..\admin_app
start cmd /k "flutter run -d chrome"

echo.
echo ========================================
echo Admin Dashboard Started!
echo ========================================
echo Backend: http://localhost:3000
echo Admin App: Opening in Chrome...
echo.
echo Press any key to exit this window...
pause > nul
