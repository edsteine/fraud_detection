@echo off
echo Starting Django setup and run script...

rem Set up variables for paths
set "VENV_PATH=%USERPROFILE%\Documents\venv"
set "PROJECT_PATH=%USERPROFILE%\Desktop\Fraud_project"
set "BACKEND_PATH=%PROJECT_PATH%\fraud_backend"

rem Check if virtual environment exists
if exist "%VENV_PATH%\Scripts\activate.bat" (
    echo Virtual environment found! Activating...
    call "%VENV_PATH%\Scripts\activate.bat"
) else (
    echo Error: Virtual environment not found at %VENV_PATH%
    echo Please ensure your virtual environment is set up correctly.
    goto :error
)

rem Navigate to the project directory
if exist "%PROJECT_PATH%" (
    cd /d "%PROJECT_PATH%"
) else (
    echo Error: Project directory not found at %PROJECT_PATH%
    goto :error
)

rem Navigate to the backend directory
if exist "%BACKEND_PATH%" (
    cd "%BACKEND_PATH%"
) else (
    echo Error: Backend directory not found at %BACKEND_PATH%
    goto :error
)

rem Run Django commands
echo Making migrations...
python manage.py makemigrations
if %ERRORLEVEL% neq 0 goto :error

echo Applying migrations...
python manage.py migrate
if %ERRORLEVEL% neq 0 goto :error

echo Starting Django development server...
python manage.py runserver 0.0.0.0:8000

goto :end

:error
echo An error occurred. Exiting script.
pause
exit /b 1

:end
echo Script completed successfully.
pause