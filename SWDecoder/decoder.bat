@echo off
cd "%1"
dir /b sw*txt > filelist.txt
sed "s;\(^.*\).txt$;& \1.html;g" filelist.txt >> renamelist.bat
sed -i "s;\(.*\);copy\ \1;g" renamelist.bat
echo echo Please wait while the files are decoded... >> renamelist.bat
call renamelist.bat
sed -i -f "%programfiles%\SW Log Decoder\cons.txt" renamelist.bat
call renamelist.bat
sed -i -f "%programfiles%\SW Log Decoder\cons2.txt" renamelist.bat
call renamelist.bat
sed -i -f "%programfiles%\SW Log Decoder\cons3.txt" renamelist.bat
call renamelist.bat
del filelist.txt
sed -i -f "%programfiles%\SW Log Decoder\sedcommand" sw*.html
del renamelist.bat
call CDRdecoder.bat
dir /b sw*.html > portlist.html
sed -i -f "%programfiles%\SW Log Decoder\portlist" portlist.html
copy SipExtChanTbl.log SipExtChanTbl.html
sed -i -f "%programfiles%\SW Log Decoder\sipext.txt" SipExtChanTbl.html
echo ^</body^>^</html^> >> SipExtChanTbl.html
cd ..\
copy Description.txt Description.html
sed -i -f "%programfiles%\SW Log Decoder\description" description.html
echo ^<br^>^<a href="log/portlist.html"^>Port List^</a^> >> Description.html
echo ^<br^>^<a href="config/ReadOE/altigen_rc.html"^>ReadOE^</a^> >> Description.html
echo ^<br^>^<a href="log/SipExtChanTbl.html"^>SIP Extension Channel Table^</a^> >> Description.html
echo ^<br^>^<a href="log/NewCDRExt.html"^>Call Detail Report^</a^> >> Description.html
Description.html
exit