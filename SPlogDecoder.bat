@echo off
::Dump the T1/PRI HDLC information.  For now, only lines that contain "HDLC will be dumped.

for /F %%a IN ('dir /b TritonSPLo*.txt') do grep -f"%InstallationLocation%\grepSP" %%a > %%a.tmp
gsort -m TritonSPLog*.tmp > PRI_HDLC.html
sed -i -f "%InstallationLocation%\sedSP" PRI_HDLC.html

::sed -i "/LangCustom/ s;hrase\([[:digit:]]\{4\}\).*$;<font color=blue> // Play custom phrase\1</font>;g" PRI_HDLC.html
sed -i "s;Lang1..\(hrase[[:digit:]]\{4\}\).*$;&<span style=color:blue> // Play system <a href=\"%InstallPath%/allphrases.html#p\1\">p\1.</a></span><br>;g" PRI_HDLC.html
::sed -i "s/.*$/&<br>/g" PRI_HDLC.html
del TritonSP*.tmp

::Create html copies of all TritonSP files
copy TritonSP*.txt *.html
sed -i -f "%InstallationLocation%\SedSP" TritonSP*.html

::Create the TritonSPindex.html file, format the page, start the table
echo ^<html^>^<body style="font-family:arial;font-size:12;background-color:d9d9d9"^>^<table cellspacing="0" width="500" frame="hsides" cellpadding="5" style="font-family:arial;font-size:12"^>  > TritonSPindex.html
echo ^<tr^>^<th^>File:^</th^>^<th^>Start Time:^</th^>^<th^>End Time:^</th^>^</tr^> >> TritonSPindex.html

::Get the data for the table
for /R %%i in ("TritonSP*.txt") DO (
echo ^<tr^>^<td^>^<a href="%%~ni.html"^>%%~ni.html^</a^>^</td^> >> TritonSPindex.html 
sed -n "3 s;\(.\{19\}\).*$;<td>\1</td>;p" %%~ni.txt >> TritonSPindex.html
sed -n "$ s;\(.\{19\}\).*$;<td>\1<td></tr>\n;p" %%~ni.txt >> TritonSPindex.html
)

::Close up the table.
echo ^</table^>^</html^> >> TritonSPindex.html