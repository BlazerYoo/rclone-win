@echo off
setlocal enabledelayedexpansion


REM Create new directory for rclone
set rclonePath=C:\rclone
mkdir %rclonePath%
echo Created new directory at %rclonePath%
echo --------------------------------------------------------


REM Choose windows version
set executables=.\executables
echo Available versions:
set /a index=0
for /d %%i in (%executables%\*) do (
    set /a index+=1
    echo !index!. %%~nxi
    set zips[!index!]=%%~nxi
)

:GET_INPUT
set /p "userInput=Enter an integer (between 1 and %index% inclusive): "

:: Check if the input is a valid integer
for /f "tokens=1 delims=0123456789" %%a in ("%userInput%") do (
    echo Invalid input. Please try again.
    goto GET_INPUT
)
:: Check if the integer is within the specified range
if %userInput% lss 1 (
    echo Integer must be greater than or equal to 1.
    goto GET_INPUT
)
if %userInput% gtr %index% (
    echo Integer must be less than or equal to %index%.
    goto GET_INPUT
)

echo Selected !zips[%userInput%]!
echo --------------------------------------------------------


REM Copy selected windows version copy to created rclone path
set coursePath=%executables%\!zips[%userInput%]!\!zips[%userInput%]!\rclone.exe
copy %coursePath% %rclonePath%
echo Moved !zips[%userInput%]! executable to %rclonePath%
echo --------------------------------------------------------


REM Add rclone directory to PATH
if not defined PATH (
    setx PATH "%rclonePath%"
) else (
    setx PATH "%PATH%;%rclonePath%"
)
echo Added %rclonePath% to PATH


endlocal