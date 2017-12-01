@echo off
::This first section we are setting up directory structure variables as well as establishing a 
::date and time stamp from which to pull information
set myplace=%cd%
cd..
set cpturefls=%cd%
cd %myplace%
findstr "Date:" %cpturefls%\Description.txt >%myplace%\descdate.txt

sed -i "s/Collect Date: //g" %myplace%\descdate.txt
sed -i "s/-/ /g" %myplace%\descdate.txt
for /f "tokens=1" %%a in (%myplace%\descdate.txt) do set word1=%%a
for /f "tokens=2" %%b in (%myplace%\descdate.txt) do set word2=%%b
for /f "tokens=3" %%c in (%myplace%\descdate.txt) do set word3=%%c
set newdate=%word3%-%word1%-%word2%
echo %newdate%
::Using the Date and time information we now begin modifying the workgroup statistics based on date from 
::the collection criteria used by the dealer
echo @echo off >>%myplace%\wglisting.bat
dir /B %cpturefls%\Config\altiserv\db\Storage\*_Grp.txt >>%myplace%\wglisting.bat
sed -i "s/Sys\_LineParkGrpExt\_Grp\.txt//g" %myplace%\wglisting.bat

sed -i "s/Ext_Gen_Ext\#/indstr \"/g" %myplace%\wglisting.bat 
sed -i "s/inds/finds/g" %myplace%\wglisting.bat
sed -i "s/\_Grp\.txt/\" wkgmsgmgr\.txt/g" %myplace%\wglisting.bat
sed -i "s/txt/txt \>\>wkgmsgmgr\.tmp\.txt/g" %myplace%\wglisting.bat

call %myplace%\wglisting.bat
findstr "%newdate%" %myplace%\wkgmsgmgr.tmp.txt >>%myplace%\wkgpworking.txt

sed -i "s/([0-9][0-9])//g" %myplace%\wkgpworking.txt
sed -i "s/: [0-9] - / ; /g" %myplace%\wkgpworking.txt
sed -i "s/: [0-9][0-9] - / ; /g" %myplace%\wkgpworking.txt
sed -i "s/,[[0-9][0-9][0-9] wg/;wg/g" %myplace%\wkgpworking.txt

copy %myplace%\wkgpworking.txt %myplace%\wgoutput.txt
sed -i "s/;/,/g" %myplace%\wgoutput.txt
sed -i "s/ /,/g" %myplace%\wgoutput.txt
sed -i "s/,,,/,/g" %myplace%\wgoutput.txt
sed -i "s/([0-9][0-9][0-9])//g" %myplace%\wgoutput.txt
sed -i "/RTM/ d" %myplace%\wgoutput.txt


::The following table is built to give us the new workgroup statistics page for Decoder
::the table contains sequential workgroups with the statistics built for the day of capture
echo ^<table border="1" cellpadding="3" style="font-family:arial;font-size:12;background-color:Cyan"^> >>%myplace%\WgStats.html
echo ^<caption style="font-family:arial;font-size:18;background-color:DeepSkyBlue" align="left"^>^<b^>^<u^>Workgroup Statistics^</u^>^</b^>^</style^>^</caption^> >>%myplace%\WgStats.html
awk "/Suppression/ {print \"^<caption align=left^>^<b^>\"$0\"^</b^>^</caption^>\"}" %myplace%\wgoutput.txt >> %myplace%\WgStats.html
echo ^<tr^>^<th^>Date^</th^>^<th^>Time of change^</th^>^<th^>WorkGroup^</th^>^<th^>TotalAgents^</th^>^<th^>LoggedIn^</th^>^<th^>Available^</th^>^<th^>DND^/FWD^</th^>^<th^>WrapUp^</th^>^<th^>NotReady^</th^>^<th^>Busy^</th^>^<th^>Error^</th^>^<th^>Logout^</th^>^<th^>UnStaffed^</th^>^</th^>^<th^>VoiceMails^</th^>^</th^>^<th^>Queued^</th^>^<th^>CallBack^</th^>^</tr^>  >>%myplace%\WgStats.html
awk -F"," "{print \"^<tr^>^<td^>\"$1\"^</td^>^<td^>\"$2\"^</td^>^<td^>\"$4\"^</td^>^<td^>\"$5\"^</td^>^<td^>\"$6\"^</td^>^<td^>\"$7\"^</td^>^<td^>\"$8\"^</td^>^<td^>\"$9\"^</td^>^<td^>\"$10\"^</td^>^<td^>\"$11\"^</td^>^<td^>\"$12\"^</td^>^<td^>\"$13\"^</td^>^<td^>\"$14\"^</td^>^<td^>\"$15\"^</td^>^<td^>\"$16\"^</td^>^<td^>\"$17\"^</td^>^</tr^>\"}" %myplace%\wgoutput.txt >>%myplace%\WgStats.html
echo ^</table^> >>%myplace%\WgStats.html

::make daily procinfolog.txt to file
findstr "%newdate%" %myplace%\procinfolog.txt >>%myplace%\procinfo.tmp.txt
findstr "%newdate%" %myplace%\procinfologbak.txt >>%myplace%\procinfo.tmp.txt
sed -i "s/K,p/K p/g" %myplace%\procinfo.tmp.txt
sed -i "s/,[[:digit:]][[:digit:]][[:digit:]] Handle/, Handle/g" %myplace%\procinfo.tmp.txt
sed -i "s/TotalCPU=100\%/Mytest/g" %myplace%\procinfo.tmp.txt

echo ^<table border="1" cellpadding="3" style="font-family:arial;font-size:12;background-color:e8ebec"^> >>%myplace%\procinfo.html
awk -F"," "{print \"^<tr^>^<td^>\"$1\"^</td^>^<td^>\"$2\"^</td^>^<td^>\"$3\"^</td^>^<td^>\"$4\"^</td^>^<td^>\"$5\"^</td^>^<td^>\"$6\"^</td^>^<td^>\"$7\"^</td^>^<td^>\"$8\"^</td^>^</tr^>\"}" %myplace%\procinfo.tmp.txt >>%myplace%\procinfo.html
sed -i "s;TotalCPU\=81%;<b>TotalCPU\=81<\b>;g" procinfo.html
sed -i "s;TotalCPU\=82%;<b>TotalCPU\=82<\b>;g" procinfo.html
sed -i "s;TotalCPU\=83%;<b>TotalCPU\=83<\b>;g" procinfo.html
sed -i "s;TotalCPU\=84%;<b>TotalCPU\=84<\b>;g" procinfo.html
sed -i "s;TotalCPU\=85%;<b>TotalCPU\=85<\b>;g" procinfo.html
sed -i "s;TotalCPU\=86%;<b>TotalCPU\=86<\b>;g" procinfo.html
sed -i "s;TotalCPU\=87%;<b>TotalCPU\=87<\b>;g" procinfo.html
sed -i "s;TotalCPU\=88%;<b>TotalCPU\=88<\b>;g" procinfo.html
sed -i "s;TotalCPU\=89%;<b>TotalCPU\=89<\b>;g" procinfo.html
sed -i "s;TotalCPU\=90%;<b>TotalCPU\=90<\b>;g" procinfo.html
sed -i "s;TotalCPU\=91%;<b>TotalCPU\=91<\b>;g" procinfo.html
sed -i "s;TotalCPU\=92%;<b>TotalCPU\=92<\b>;g" procinfo.html
sed -i "s;TotalCPU\=93%;<b>TotalCPU\=93<\b>;g" procinfo.html
sed -i "s;TotalCPU\=94%;<b>TotalCPU\=94<\b>;g" procinfo.html
sed -i "s;TotalCPU\=95%;<b>TotalCPU\=95<\b>;g" procinfo.html
sed -i "s;TotalCPU\=96%;<b>TotalCPU\=96<\b>;g" procinfo.html
sed -i "s;TotalCPU\=97%;<b>TotalCPU\=97<\b>;g" procinfo.html
sed -i "s;TotalCPU\=98%;<b>TotalCPU\=98<\b>;g" procinfo.html
sed -i "s;TotalCPU\=99%;<b>TotalCPU\=99<\b>;g" procinfo.html
sed -i "s;TotalCPU\=100%;<b>TotalCPU\=100<\b>;g" procinfo.html
sed -i "s;CPU\=81%;<b>CPU\=81<\b>;g" procinfo.html
sed -i "s;CPU\=82%;<b>CPU\=82<\b>;g" procinfo.html
sed -i "s;CPU\=83%;<b>CPU\=83<\b>;g" procinfo.html
sed -i "s;CPU\=84%;<b>CPU\=84<\b>;g" procinfo.html
sed -i "s;CPU\=85%;<b>CPU\=85<\b>;g" procinfo.html
sed -i "s;CPU\=86%;<b>CPU\=86<\b>;g" procinfo.html
sed -i "s;CPU\=87%;<b>CPU\=87<\b>;g" procinfo.html
sed -i "s;CPU\=88%;<b>CPU\=88<\b>;g" procinfo.html
sed -i "s;CPU\=89%;<b>CPU\=89<\b>;g" procinfo.html
sed -i "s;CPU\=90%;<b>CPU\=90<\b>;g" procinfo.html
sed -i "s;CPU\=91%;<b>CPU\=91<\b>;g" procinfo.html
sed -i "s;CPU\=92%;<b>CPU\=92<\b>;g" procinfo.html
sed -i "s;CPU\=93%;<b>CPU\=93<\b>;g" procinfo.html
sed -i "s;CPU\=94%;<b>CPU\=94<\b>;g" procinfo.html
sed -i "s;CPU\=95%;<b>CPU\=95<\b>;g" procinfo.html
sed -i "s;CPU\=96%;<b>CPU\=96<\b>;g" procinfo.html
sed -i "s;CPU\=97%;<b>CPU\=97<\b>;g" procinfo.html
sed -i "s;CPU\=98%;<b>CPU\=98<\b>;g" procinfo.html
sed -i "s;CPU\=99%;<b>CPU\=99<\b>;g" procinfo.html
sed -i "s;CPU\=100%;<b>CPU\=100<\b>;g" procinfo.html
cd %myplace%
::This portion of the code is built to grab the BLF key information from the Polycom extensions and place them into a table

findstr "attendant.resourceList...label" %cpturefls%\Config\altiserv\PolyComCfg\Ext*.cfg >>%myplace%\MyBLF.tmp.txt
sed -n -e "s/^.*Extension_//p" %myplace%\MyBLF.tmp.txt >>%myplace%\MyBlf.txt
::previos line useful.  states print everything on line after <whatever> in this case literally Extension_
sed -i "s/.cfg:attendant.resourceList./ BLF Key /g" %myplace%\MyBlf.txt
sed -i "s/.label/ ; Label/g" %myplace%\MyBlf.txt
echo ^<table border="1" cellpadding="3" style="font-family:arial;font-size:12;background-color:989392"^> >>PolycomBLF.html
echo ^<caption style="font-family:arial;font-size:18" align="left"^>^<b^>^<u^>BLF Keys^</u^>^</b^>^</style^>^</caption^> >>PolycomBLF.html
awk -F"\n" "{print \"^<tr^>^<td^>\"$1\"^</td^>^</tr^>\"}" MyBLF.txt >> PolycomBLF.html
echo ^</table^> >> PolycomBLF.html
::Final Phase, clean up after ones self

del %myplace%\wgoutput.txt %myplace%\wkgmsgmgr.tmp.txt %myplace%\wkgpworking.txt %myplace%\descdate.txt %myplace%\wglisting.bat %myplace%\procinfo.tmp.txt %myplace%\MyBLF.tmp.txt %myplace%\MyBlf.txt
