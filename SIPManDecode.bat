@echo off
::Create html copies of all SIPMan files
copy SIPMan*.txt *.html

::Create the IndexSIPMan.html file, format the page, start the table
echo ^<html^>^<body style="font-family:arial;font-size:12;background-color:d9d9d9"^>^<table cellspacing="0" width="500" frame="hsides" cellpadding="5" style="font-family:arial;font-size:12"^>  > IndexSIPMan.html
echo ^<tr^>^<th^>File:^</th^>^<th^>Start Time:^</th^>^</tr^> >> IndexSIPMan.html

::Get the data for the table
for /R %%i in ("SIPMan*.txt") DO (
echo ^<tr^>^<td^>^<a href="%%~ni.html"^>%%~ni.html^</a^>^</td^> >> IndexSIPMan.html 
sed -n "1 s;\(.\{19\}\).*$;<td>\1</td></tr>\n;p" %%~ni.txt >> IndexSIPMan.html
)

sed -i -f "%InstallationLocation%\SIPManSed" SIPMan*.html
sed -i "/RmtIP/{n;s;indented;callid;}" SIPMan*.html
sed -i "/SipCallMan/{n;s;indented;callid;}" SIPMan*.html

echo ^</table^>^</html^> >> IndexSIPMan.html
