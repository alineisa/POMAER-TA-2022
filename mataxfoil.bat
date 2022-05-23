set xfoil=xfoil.exe
timeout 10
set /a k=0
:start
set /a k+=1
if %k%==10 goto fim
echo %k%
tasklist > %TEMP%\tasks.txt
  find /i "%xfoil%" %TEMP%\tasks.txt > nul
  if errorlevel 1 goto :ERR
    echo xfoil aberto
  goto start
  :ERR
    echo xfoil fechado
    exit
:fim
TASKKILL /F /IM xfoil.exe
exit
