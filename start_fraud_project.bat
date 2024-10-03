@echo off
echo Starting full Django setup and run script...

rem Set up variables for paths
set "VENV_PATH=%USERPROFILE%\Documents\venv"
set "PROJECT_PATH=%USERPROFILE%\Desktop\Fraud_project"
set "BACKEND_PATH=%PROJECT_PATH%\fraud_backend"
set "PSQL_PATH=C:\Program Files\PostgreSQL\17\bin\psql.exe"

rem Check if PostgreSQL is installed
"%PSQL_PATH%" --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: PostgreSQL is not installed or not in PATH. Please install PostgreSQL.
    goto :error
)

rem Check if virtual environment exists
if exist "%VENV_PATH%\Scripts\activate.bat" (
    echo Virtual environment found! Activating...
    call "%VENV_PATH%\Scripts\activate.bat"
) else (
    echo Virtual environment not found, creating one...
    python -m venv "%VENV_PATH%"
    call "%VENV_PATH%\Scripts\activate.bat"
)

rem Navigate to the project directory
if not exist "%PROJECT_PATH%" (
    echo Creating project directory...
    mkdir "%PROJECT_PATH%"
)
cd /d "%PROJECT_PATH%"

rem Navigate to the backend directory
if not exist "%BACKEND_PATH%" (
    echo Creating backend directory...
    django-admin startproject fraud_backend "%BACKEND_PATH%"
)
cd "%BACKEND_PATH%"

rem Check if .env file exists and load environment variables
if exist ".env" (
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        set %%a=%%b
    )
) else (
    echo Error: .env file not found.
    goto :error
)

rem Create database if it doesn't exist
echo Checking if the database exists...
"%PSQL_PATH%" -U %DB_USER% -d %DB_NAME% -p %DB_PORT% -c "SELECT 1" 2>nul
if %ERRORLEVEL% neq 0 (
    echo Database not found. Creating database %DB_NAME%...
    "%PSQL_PATH%" -U %DB_USER% -p %DB_PORT% -c "CREATE DATABASE %DB_NAME%;" || goto :error
)

rem Install required Python packages
if exist "requirements.txt" (
    pip install -r requirements.txt
) else (
    echo Warning: requirements.txt file not found. Skipping package installation.
)

rem Run Django commands
echo Making migrations...
python manage.py makemigrations || goto :error

echo Applying migrations...
python manage.py migrate || goto :error

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
