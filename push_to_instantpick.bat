@echo off
echo ========================================
echo Pushing InstantPick Project to GitHub
echo ========================================
echo.

REM Check if git is initialized
if not exist ".git" (
    echo Initializing Git repository...
    git init
    echo.
)

REM Add remote repository
echo Adding remote repository...
git remote remove origin 2>nul
git remote add origin https://github.com/vivekx11/instantpick...git
echo.

REM Add all files
echo Adding all files...
git add .
echo.

REM Commit changes
echo Committing changes...
git commit -m "Complete InstantPick project with UI improvements"
echo.

REM Push to GitHub
echo Pushing to GitHub...
git branch -M main
git push -u origin main --force
echo.

echo ========================================
echo Push completed successfully!
echo Repository: https://github.com/vivekx11/instantpick..
echo ========================================
pause
