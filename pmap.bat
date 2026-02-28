@echo off
setlocal EnableExtensions
chcp 65001 >nul

set "PY=%~dp0.venv\Scripts\python.exe"
if not exist "%PY%" set "PY=python"

"%PY%" "%~dp0export_all_maps.py" %*
exit /b %ERRORLEVEL%
