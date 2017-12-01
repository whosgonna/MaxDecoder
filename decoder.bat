@echo off
cd "%1"
::Add the decoder location to the path, etc.
:: NEED TO CHECK FOR OS TYPE (use %processor_architecture% to find if it's 64 or 32 bit.)
:: If it's 64 bit os then use "REG QUERY "HKLM\Software\Wow6432Node\AltiGen Communications, Inc.\MaxDecoder"
if %processor_architecture% == x86 (set reg_path=HKLM\Software\AltiGen Communications, Inc.\MaxDecoder) else (set reg_path=HKLM\Software\Wow6432Node\AltiGen Communications, Inc.\MaxDecoder)
FOR /F "tokens=2,*" %%A IN ('REG QUERY "%reg_path%" /v InstallationLocation ^| findstr InstallationLocation') DO SET InstallationLocation=%%B
path=%PATH%;%InstallationLocation%
set InstallPath=%InstallationLocation:\=/%

::Start work for switching files
dir /b sw*txt > filelist.txt
sed "s;\(^.*\).txt$;& \1.html;g" filelist.txt > renamelist.bat
sed -i "s;\(.*\);copy\ \1;g" renamelist.bat
echo echo Please wait while the files are decoded... >> renamelist.bat
call renamelist.bat
sed -i -f "%InstallationLocation%\cons.txt" renamelist.bat
call renamelist.bat
sed -i -f "%InstallationLocation%\cons2.txt" renamelist.bat
call renamelist.bat
sed -i -f "%InstallationLocation%\cons3.txt" renamelist.bat
call renamelist.bat
del filelist.txt

sed -i -f "%InstallationLocation%\sedcommand" sw*.html
for /F %%G IN ('dir /B sw*.html') DO (sed -i "1i\<html><head>\n<title>%%G</title></head>" %%G)
sed -i "s;[Pp]\(hrase[1-9][[:digit:]][[:digit:]][[:digit:]]\).*rc=0;&<span style=color:blue> // Play <a href=\"%InstallPath%/allphrases.html#p\1\">p\1.</a></span><br>;g" sw*.html
del renamelist.bat

::Switching traces decoded above.  Seperate modules for each of the remaining files.
call "%InstallationLocation%\CDRdecoder.bat"
call "%InstallationLocation%\SPlogDecoder.bat"
call "%InstallationLocation%\CTProxyDump.bat"
call "%InstallationLocation%\DinaProxyDecode.bat"
call "%InstallationLocation%\SIPManDecode.bat"
call "%InstallationLocation%\atps.bat"
call "%InstallationLocation%\DSPDecoder.bat"
call "%InstallationLocation%\wgmnttest.bat"

::Create port listing
dir /b sw*.html > portlist.html
sed -i -f "%InstallationLocation%\portlist" portlist.html
copy SipExtChanTbl.log SipExtChanTbl.html

::Create extension channel file.
sed -i -f "%InstallationLocation%\sipext.txt" SipExtChanTbl.html
echo ^</body^>^</html^> >> SipExtChanTbl.html
cd ..\

::Assemble the desription page
copy Description.txt Description.html
sed -i -f "%InstallationLocation%\description" description.html
echo ^<br^>^<a href="log/portlist.html"^>Port List^</a^> >> Description.html
echo ^<br^>^<a href="config/ReadOE/altigen_rc.html"^>ReadOE^</a^> >> Description.html
echo ^<br^>^<a href="log/SipExtChanTbl.html"^>SIP Extension Channel Table^</a^> >> Description.html
echo ^<br^>^<a href="log/NewCDRExt.html"^>Call Detail Report^</a^> >> Description.html
echo ^<br^>^<a href="log/CTProxyDump.html"^>AltiClient apps logged in.^</a^> >> Description.html
echo ^<br^>^<a href="log/ENMconf.html"^>Enterprise Network Config.^</a^> >> Description.html
echo ^<br^>^<a href="log/TritonSPIndex.html"^>TritonSP Logs^</a^> >> Description.html
echo ^<br^>^<a href="log/IndexSIPMan.html"^>SIPMan Logs^</a^> >> Description.html
echo ^<br^>^<a href="log/IndexATPS.html"^>ATPSXML Logs^</a^> >> Description.html
echo ^<br^>^<a href="log/IndexDSP.html"^>DSP Logs^</a^> >> Description.html
echo ^<br^>^<a href="log/WgStats.html"^>WorkGroup Stats^</a^> >> Description.html
echo ^<br^>^<a href="log/CTProxyDump.html"^>Agent/Communicator Stats^</a^> >> Description.html
echo ^<br^>^<a href="log/procinfo.html"^>Processor Information^</a^> >> Description.html
echo ^<br^>^<a href="log/PolycomBLF.html"^>Polycom BLFs^</a^> >> Description.html

::Open the description file for viewing

::exit
rm sed*
rm log\sed*
