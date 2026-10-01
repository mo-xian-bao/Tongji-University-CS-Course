@echo off
echo Building B-Tree Visualization Qt Project...
echo.

REM Check if qmake is available
where qmake >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: qmake not found in PATH
    echo Please make sure Qt is installed and qmake is in your PATH
    echo.
    echo Typical Qt installation paths:
    echo   C:\Qt\5.15.2\mingw81_64\bin
    echo   C:\Qt\6.x.x\mingw_64\bin
    echo.
    pause
    exit /b 1
)

echo Found qmake: 
qmake --version
echo.

REM Generate Makefile
echo Generating Makefile...
qmake BTreeVisualization.pro
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to generate Makefile
    pause
    exit /b 1
)

REM Check if make/mingw32-make is available
where mingw32-make >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set MAKE_CMD=mingw32-make
) else (
    where make >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        set MAKE_CMD=make
    ) else (
        echo Error: Neither 'make' nor 'mingw32-make' found in PATH
        pause
        exit /b 1
    )
)

echo Using make command: %MAKE_CMD%
echo.

REM Build the project
echo Building project...
%MAKE_CMD%
if %ERRORLEVEL% NEQ 0 (
    echo Error: Build failed
    pause
    exit /b 1
)

echo.
echo Build successful!
echo.

REM Check if executable was created
if exist "debug\BTreeVisualization.exe" (
    echo Executable found: debug\BTreeVisualization.exe
    echo You can now run the program.
    echo.
    set /p choice="Do you want to run the program now? (y/n): "
    if /i "%choice%"=="y" (
        start debug\BTreeVisualization.exe
    )
) else if exist "release\BTreeVisualization.exe" (
    echo Executable found: release\BTreeVisualization.exe
    echo You can now run the program.
    echo.
    set /p choice="Do you want to run the program now? (y/n): "
    if /i "%choice%"=="y" (
        start release\BTreeVisualization.exe
    )
) else (
    echo Warning: Executable not found in expected locations
    echo Please check the build output above for any errors
)

pause
