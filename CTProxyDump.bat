@echo off
echo ^<html^> > CTProxyDump.html
echo ^<body style="font-family:arial;font-size:12;background-color:d9d9d9"^> >>CTProxyDump.html
grep -f "%InstallationLocation%\ctproxdumpgrep.txt" ./CTPROXY/CTProxyDump.TXT >> CTProxyDump.html
sed -i "s;Guitar=GATORS01;& <span style="color:blue"><b> // AltiView</b></span>;g" CTProxyDump.html
sed -i "s;Guitar=GATORS02;& <span style="color:blue"><b> // AltiAgent</b></span>;g" CTProxyDump.html
sed -i "s;Guitar=GATORS03;& <span style="color:blue"><b> // AltiSupervisor</b></span>;g" CTProxyDump.html
sed -i "s;Guitar=GATORS06;& <span style="color:blue"><b> // AltiConsole</b></span>;g" CTProxyDump.html

sed -i "s;Address.*$;&<br>;g" CTProxyDump.html
sed -i "s;.*$;&<br>;g" CTProxyDump.html