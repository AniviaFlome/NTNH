@echo off
cls
echo Checking for script updates...

:: Получение последнего тега с GitHub
for /f "delims=" %%i in ('powershell -command "(Invoke-RestMethod https://api.github.com/repos/Nuclear-Tech-New-Horizons/NTNH/tags).name | Select-Object -First 1"') do set LATEST_TAG=%%i

:: Проверка текущей версии скрипта
if exist current_version.txt (
    set /p CURRENT_TAG=<current_version.txt
    if "%CURRENT_TAG%"=="%LATEST_TAG%" (
        echo Script is up to date.
    ) else (
        echo Updating script to version %LATEST_TAG%...
        :: Скачивание новой версии скрипта
        powershell -command "Start-BitsTransfer -Source 'https://raw.githubusercontent.com/Nuclear-Tech-New-Horizons/NTNH/%LATEST_TAG%/+UpdateScript_DoYouTrustMe-client.bat' -Destination '+UpdateScript_DoYouTrustMe-client.bat.new'"
        if exist +UpdateScript_DoYouTrustMe-client.bat.new (
            :: Замена текущего скрипта
            move /y +UpdateScript_DoYouTrustMe-client.bat.new +UpdateScript_DoYouTrustMe-client.bat
            echo Script updated. Restarting...
            :: Перезапуск скрипта
            start "" cmd /c "%~f0" %*
            exit /b
        ) else (
            echo Failed to download script update. Continuing with current version...
        )
    )
) else (
    echo No current_version.txt found. Proceeding with update...
)

echo Checking for game updates...

:: Проверка текущей версии игры
if exist current_version.txt (
    set /p CURRENT_TAG=<current_version.txt
    if "%CURRENT_TAG%"=="%LATEST_TAG%" (
        echo Game files are already up to date.
        PAUSE
        exit /b
    )
)

echo Updating game files to version %LATEST_TAG%...
echo Do you trust me? This script will delete all configs and mods, press any button to continue.
PAUSE

:: Создание папки для кэша, если её нет
if not exist cache mkdir cache

:: Проверка наличия кэшированного zip-файла
set ZIP_FILE=cache\NTNH_%LATEST_TAG%.zip
if exist "%ZIP_FILE%" (
    echo Using cached zip file...
) else (
    echo Downloading latest version...
    powershell -command "Start-BitsTransfer -Source 'https://github.com/Nuclear-Tech-New-Horizons/NTNH/archive/refs/tags/%LATEST_TAG%.zip' -Destination '%ZIP_FILE%'"
)

:: Удаление существующих файлов и папок
echo Deleting old files...
rmdir /s /q config
rmdir /s /q mods
rmdir /s /q scripts
rmdir /s /q serverutilities
del MODLIST.txt
del icon.png
del README.md
del LICENSE

:: Распаковка zip-архива
echo Extracting files...
mkdir temp_extract
:: Используйте 7z, если он установлен, или оставьте Expand-Archive
7z x "%ZIP_FILE%" -o"temp_extract" || powershell -command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath temp_extract"

:: Поиск распакованной папки
for /d %%i in (temp_extract\NTNH-*) do set EXTRACTED_FOLDER=%%i

:: Перемещение файлов
echo Moving new files...
robocopy "%EXTRACTED_FOLDER%\config" "config" /mov /e
robocopy "%EXTRACTED_FOLDER%\mods" "mods" /mov /e
robocopy "%EXTRACTED_FOLDER%\scripts" "scripts" /mov /e
robocopy "%EXTRACTED_FOLDER%\serverutilities" "serverutilities" /mov /e
robocopy "%EXTRACTED_FOLDER%" "." CODEOWNERS /mov
robocopy "%EXTRACTED_FOLDER%" "." icon.png /mov
robocopy "%EXTRACTED_FOLDER%" "." LICENSE /mov
robocopy "%EXTRACTED_FOLDER%" "." MODLIST.txt /mov
robocopy "%EXTRACTED_FOLDER%" "." README.md /mov

:: Очистка временных файлов
echo Cleaning up...
del temp.zip 2>nul
rmdir /s /q temp_extract

:: Сохранение текущей версии
echo %LATEST_TAG% > current_version.txt

echo UPDATED SUCCESSFULLY! THANK YOU FOR TRUSTING ME!
PAUSE
