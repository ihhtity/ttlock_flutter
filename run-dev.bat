@echo off
echo ========================================
echo Flutter Auto-Reload Development Server
echo ========================================
echo.
echo Starting Flutter app with auto-reload...
echo Press Ctrl+C to stop
echo.

cd example

:loop
flutter run -d emulator-5554
if errorlevel 1 (
    echo.
    echo App stopped or crashed. Restarting in 3 seconds...
    timeout /t 3 /nobreak >nul
    goto loop
)
