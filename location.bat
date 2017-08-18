@ECHO OFF
:: delims is a TAB followed by a space
FOR /F "tokens=2* delims=	 " %%A IN ('REG QUERY "HKLM\Software\AltiGen Communications, Inc.\AltiDecoder" /v InstallationLocation') DO SET InstallationLocation=%%B
ECHO InstallationLocation="%InstallationLocation%"
"%InstallationLocation%\hello.bat"