@echo of
mkdir ..\DSP\html
copy ..\DSP\*.log ..\DSP\html\*.log
for /F %%G IN ('dir /B ..\DSP\html\') DO (
"%InstallationLocation%\DSPLogTimeDecode.exe" ..\DSP\html\%%G
del ..\DSP\html\%%G
sed -i -f "%InstallationLocation%\DSPsed" ..\DSP\html\%%G.txt
echo ^</body^>^</html^> >> ..\DSP\html\%%G.txt
move ..\DSP\html\%%G.txt ..\DSP\html\%%G.html)

echo ^<html^>^<body style="font-family:arial;font-size:12;background-color:d9d9d9"^>  > IndexDSP.html

for /F %%a IN ('dir /B ..\DSP\html\*.html') DO ( echo ^<a href="../DSP/html\%%a"^>%%a^</a^>^<br /^> >> IndexDSP.html)