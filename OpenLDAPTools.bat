::@echo off
copy "%InstallationLocation%\ldap.conf" ..\Config\altiserv\OpenLdap\
:start "slapd.exe"/MIN  cmd /c \Users\ben\Documents\AltiGen\SWDecoder\OpenLdap\slapd.exe -f "\Users\ben\Documents\AltiGen\Traces\[capture_aspiriant]82560_2010_06_30_17_35_27_SFPHONES\Config\altiserv\OpenLdap\slapd.conf"
::start /B  cmd /c "C:\Users\ben\Documents\AltiGen\Traces\[capture_aspiriant]82560_2010_06_30_17_35_27_SFPHONES\LdapExplorer.exe"
echo dir ..\Config\altiserv\OpenLdap
dir ..\Config\altiserv\OpenLdap
pause