@echo off
REM Batch script to setup and activate virtual environment
REM This script does NOT require Python to be installed first
REM Usage: activate_env.bat [folder_name]
REM Example: activate_env.bat Section_2

set REQUIREMENTS_FILE=cvcourse_windows.txt

REM Get folder name from command line argument or use default
if "%~1"=="" (
    set ENV_NAME=cvcourse_env
    set FOLDER_NAME=
) else (
    set FOLDER_NAME=%~1
    set ENV_NAME=%~1\cvcourse_env
)

echo ============================================================
echo Python Virtual Environment Setup
echo ============================================================

if not "%FOLDER_NAME%"=="" (
    echo Target folder: %FOLDER_NAME%
)
echo Environment path: %ENV_NAME%
echo ============================================================

REM Check if Python is installed
echo.
echo Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo Python is not installed or not in PATH
    echo.
    echo Please install Python from https://www.python.org/downloads/
    echo Make sure to check 'Add Python to PATH' during installation
    exit /b 1
)

REM Create folder if it doesn't exist
if not "%FOLDER_NAME%"=="" (
    if not exist "%FOLDER_NAME%" (
        echo.
        echo Creating folder '%FOLDER_NAME%'...
        mkdir "%FOLDER_NAME%"
        echo Folder created successfully
    )
)

REM Clean existing environment if it exists
if exist "%ENV_NAME%" (
    echo.
    echo Cleaning existing environment '%ENV_NAME%'...
    rmdir /s /q "%ENV_NAME%"
    if errorlevel 1 (
        echo Failed to remove old environment
        echo Please close any programs using the environment and try again
        exit /b 1
    )
    echo Old environment removed successfully
)

REM Check if virtual environment exists
if not exist "%ENV_NAME%" (
    echo.
    echo Creating virtual environment '%ENV_NAME%'...
    python -m venv %ENV_NAME%
    
    if errorlevel 1 (
        echo Failed to create virtual environment
        exit /b 1
    )
    echo Virtual environment created successfully
)

REM Activate virtual environment
echo.
echo Activating virtual environment...
call %ENV_NAME%\Scripts\activate.bat

if errorlevel 1 (
    echo Failed to activate virtual environment
    exit /b 1
)

echo Virtual environment activated

REM Upgrade pip
echo.
echo Upgrading pip...
"%ENV_NAME%\Scripts\python.exe" -m pip install --upgrade pip --quiet

REM Install/Update requirements
if exist "%REQUIREMENTS_FILE%" (
    echo.
    echo Installing/Updating packages from %REQUIREMENTS_FILE%...
    echo ============================================================
    
    REM Count total packages
    set /a TOTAL_PACKAGES=0
    for /f "tokens=*" %%i in ('type "%REQUIREMENTS_FILE%" ^| findstr /v /r "^#" ^| findstr /r "."') do (
        set /a TOTAL_PACKAGES+=1
    )
    
    echo Found %TOTAL_PACKAGES% packages to install
    echo.
    
    set /a SUCCESS_COUNT=0
    set /a FAILED_COUNT=0
    set /a INDEX=0
    set FAILED_PACKAGES=
    
    REM Install packages one by one
    for /f "tokens=*" %%i in ('type "%REQUIREMENTS_FILE%" ^| findstr /v /r "^#" ^| findstr /r "."') do (
        set /a INDEX+=1
        set PACKAGE=%%i
        echo [!INDEX!/%TOTAL_PACKAGES%] Installing !PACKAGE!...
        
        "%ENV_NAME%\Scripts\python.exe" -m pip install "!PACKAGE!" --quiet >nul 2>&1
        
        if errorlevel 1 (
            echo     [FAILED]
            set /a FAILED_COUNT+=1
            set FAILED_PACKAGES=!FAILED_PACKAGES! !PACKAGE!
        ) else (
            echo     [OK]
            set /a SUCCESS_COUNT+=1
        )
    )
    
    echo.
    echo ============================================================
    echo.
    echo Installation Summary:
    echo   [OK] Successful: !SUCCESS_COUNT!/%TOTAL_PACKAGES%
    
    if !FAILED_COUNT! GTR 0 (
        echo   [FAILED] Failed: !FAILED_COUNT!/%TOTAL_PACKAGES%
        echo.
        echo Failed packages:!FAILED_PACKAGES!
        echo.
        echo Some packages failed to install
    ) else (
        echo.
        echo All packages installed/updated successfully
    )
) else (
    echo.
    echo Requirements file '%REQUIREMENTS_FILE%' not found
)

echo.
echo ============================================================
echo Environment is ready!
echo ============================================================
echo.
echo To activate the virtual environment, run:
echo   %ENV_NAME%\Scripts\activate.bat
echo.
echo To deactivate when done, run:
echo   deactivate
echo ============================================================

REM Ask if user wants to activate now
echo.
set /p ACTIVATE="Would you like to activate the environment now? (y/n): "

if /i "%ACTIVATE%"=="y" goto ACTIVATE_NOW
if /i "%ACTIVATE%"=="yes" goto ACTIVATE_NOW
goto SKIP_ACTIVATE

:ACTIVATE_NOW
echo.
echo Activating environment...

REM Change to the target directory if folder was specified
if not "%FOLDER_NAME%"=="" (
    echo Changing directory to: %FOLDER_NAME%
    cd /d "%FOLDER_NAME%"
    if errorlevel 1 (
        echo [WARNING] Could not change directory
    ) else (
        echo [OK] Changed to: %CD%
    )
)

call "%ENV_NAME%\Scripts\activate.bat"

if defined VIRTUAL_ENV (
    echo [OK] Environment activated successfully!
    echo.
    echo You can now use Python with all installed packages.
    echo Type 'deactivate' when you're done.
) else (
    echo [WARNING] Environment may not be active in this session.
)
goto END_SCRIPT

:SKIP_ACTIVATE
echo.
echo Environment ready. Activate it manually when needed.
goto END_SCRIPT

:END_SCRIPT
echo ============================================================
