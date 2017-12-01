@echo off
IF EXIST output.txt (
del /Q output.txt
)
findstr "name:" DinaProxyDump.txt >>jimmy.txt && findstr "list:" DinaProxyDump.txt >>hoffa.txt 

@echo off
setlocal enabledelayedexpansion

for /f "tokens=3" %%a in ('type hoffa.txt') do (
set line=%%a
echo "!line!" >>newly.txt
)
sed "1q;d" jimmy.txt >>output.txt
sed "1q;d" newly.txt >>output.txt
sed "2q;d" jimmy.txt >>output.txt
sed "2q;d" newly.txt >>output.txt
sed "3q;d" jimmy.txt >>output.txt
sed "3q;d" newly.txt >>output.txt
sed "4q;d" jimmy.txt >>output.txt
sed "4q;d" newly.txt >>output.txt
sed "5q;d" jimmy.txt >>output.txt
sed "5q;d" newly.txt >>output.txt
sed "6q;d" jimmy.txt >>output.txt
sed "6q;d" newly.txt >>output.txt
sed "7q;d" jimmy.txt >>output.txt
sed "7q;d" newly.txt >>output.txt
sed "8q;d" jimmy.txt >>output.txt
sed "8q;d" newly.txt >>output.txt
sed "9q;d" jimmy.txt >>output.txt
sed "9q;d" newly.txt >>output.txt
sed "10q;d" jimmy.txt >>output.txt
sed "10q;d" newly.txt >>output.txt
sed "11q;d" jimmy.txt >>output.txt
sed "11q;d" newly.txt >>output.txt
sed "12q;d" jimmy.txt >>output.txt
sed "12q;d" newly.txt >>output.txt
sed "13q;d" jimmy.txt >>output.txt
sed "13q;d" newly.txt >>output.txt
sed -i "s/CT_//g" output.txt
sed -n "1{p;q}" output.txt
sed -i "s/,\"/\"/g" output.txt
sed -i "s/\"//g" output.txt


echo ^<table border="1" cellpadding="3" style="font-family:arial;font-size:12"^> >>ENMconf.html
echo ^<caption style="font-family:arial;font-size:18" align="left"^>^<b^>^<u^>Codecs in Table^</u^>^</b^>^</style^>^</caption^> >>ENMconf.html
::echo ^<tr^>^<th^>Profile Name^</th^>^<th^>List^</th^>^<tr^> >> CodecTbl.html
awk -F"\n" "{print \"^<tr^>^<td^>\"$1\"^</td^>^</tr^>\"}" output.txt >> ENMconf.html
echo ^</table^> >> ENMconf.html

del jimmy.txt hoffa.txt newly.txt output.txt
