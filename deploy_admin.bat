@echo off
REM Admin App Deployment Script for Windows
REM Usage: deploy_admin.bat

echo ==========================================
echo Admin App Deployment Script
echo ==========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: Flutter not found. Please install Flutter first.
    pause
    exit /b 1
)

echo Flutter found
echo.

REM Navigate to admin_app directory
cd admin_app

echo Getting dependencies...
call flutter pub get

echo.
echo Building for web (release mode)...
call flutter build web --release

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Build successful!
    echo.
    echo Choose deployment option:
    echo 1) Firebase Hosting
    echo 2) Vercel
    echo 3) Manual (build/web folder ready)
    echo.
    set /p option="Enter option (1-3): "

    if "%option%"=="1" (
        echo.
        echo Deploying to Firebase...
        where firebase >nul 2>nul
        if %ERRORLEVEL% EQU 0 (
            call firebase deploy --only hosting
            echo.
            echo Deployed to Firebase!
        ) else (
            echo Error: Firebase CLI not found. Install with: npm install -g firebase-tools
        )
    ) else if "%option%"=="2" (
        echo.
        echo Deploying to Vercel...
        cd build\web
        where vercel >nul 2>nul
        if %ERRORLEVEL% EQU 0 (
            call vercel --prod
            echo.
            echo Deployed to Vercel!
        ) else (
            echo Error: Vercel CLI not found. Install with: npm install -g vercel
        )
    ) else if "%option%"=="3" (
        echo.
        echo Build complete! Files are in: admin_app\build\web
        echo You can now:
        echo   - Upload to any static hosting
        echo   - Deploy to Render static site
        echo   - Use with any web server
    ) else (
        echo Invalid option
    )
) else (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo Deployment Complete!
echo ==========================================
pause
