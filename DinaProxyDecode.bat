@echo off
::This script uses sed, and gnu printf, and awk.
copy DinaProxyDump.txt DinaProxyDump.tmp.txt
sed -i "s/[[:cntrl:]]//g" DinaProxyDump.tmp.txt
sed -n "/GWVIPs/ s/^.*\([[:digit:]]\{10\}\).*$/\1/p" DinaProxyDump.tmp.txt > decip.tmp.txt
set /P decip=<decip.tmp.txt
printf "%%x" %decip%> convip.bat
::sed -i "/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//" hexip.tmp
sed -i "s;\(..\)\(..\)\(..\)\(..\);set /A d=0x\1\nset /A c=0x\2\nset /A b=0x\3\nset /A a=0x\4;g" convip.bat
call convip.bat
echo %a%.%b%.%c%.%d%>NATip.txt
set /P NATip=<NATip.txt
echo END>>DinaProxyDump.tmp.txt
sed -i "/GWVIPs/ s/GWVIPs :[[:digit:]]\{10\}/GWVIPs :%ip%/" DinaProxyDump.tmp.txt
sed -n "/IP Ranges/,/Pipes Control/p" DinaProxyDump.tmp.txt > IPRanges.txt
sed -n "/IP Dialing Tables/,/IP Devices Ranges/p" DinaProxyDump.tmp.txt > IPDialingTable.txt
sed -n "/Sorted IP Devices Ranges/,/Codec Profiles/p" DinaProxyDump.tmp.txt > IPDeviceRanges.txt
sed -n "/Codec Profiles/,/END/p" DinaProxyDump.tmp.txt > CodecProfiles.txt
sed -i "/END/ d" CodecProfiles.txt
sed -i "/^*/ d" IPRanges.txt IPDialingTable.txt IPDeviceRanges.txt CodecProfiles.txt
sed -i "/^$/ d" IPRanges.txt IPDialingTable.txt IPDeviceRanges.txt CodecProfiles.txt
echo ^<html^> >ENMconf.html
echo ^<body style="font-family:arial;font-size:12;background-color:d9d9d9"^> >>ENMconf.html

echo ^<h4^>^<u^>NAT Support^</u^>^</h4^> >>ENMconf.html
awk "/SIPNAT:1/ {print \"^<b^>SIP NAT Support:^</b^> Enabled\"}" DinaProxyDump.txt >>ENMconf.html
awk "/SIPNAT:0/ {print \"^<b^>SIP NAT Support:^</b^> Disabled\"}" DinaProxyDump.txt >>ENMconf.html
awk "/H323NAT:1/ {print \"^<b^>h.323 NAT Support:^</b^> Enabled\"}" DinaProxyDump.txt >>ENMconf.html
awk "/H323NAT:1/ {print \"^<b^>h.323 NAT Support:^</b^> Disabled\"}" DinaProxyDump.txt >>ENMconf.html
awk "/SIPNAT:1/ {print \"^<b^>SIP NAT Support:^</b^> Enabled\"}" DinaProxyDump.txt >>ENMconf.html
awk "/GWVIPs:0/ {print \"^<b^>Virtual IPs:^</b^> Disabled\"}" DinaProxyDump.txt >>ENMconf.html
awk "/GWVIPs:1/ {print \"^<b^>Virtual IPs:^</b^> Enabled (Note: This feature is currently not supported.)\"}" DinaProxyDump.txt >>ENMconf.html
echo ^<b^>Public IP for NAT support:^</b^> %NATip% >> ENMconf.html

sed -i "s;private:1;private: yes;g" IPRanges.txt
sed -i "s;private:1;private: no;g" IPRanges.txt
echo ^<br^>^<u^>^<b^>IP Networks:^</b^>^</u^> >> ENMconf.html
awk -F, "{print $1 $4 $5}" IPRanges.txt >> ENMconf.html

::Decode Codecs
echo ^<table border="1" cellpadding="3" style="font-family:arial;font-size:12"^> >>ENMconf.html
echo ^<caption style="font-family:arial;font-size:18" align="left"^>^<b^>^<u^>Codec Profiles^</u^>^</b^>^</style^>^</caption^> >>ENMconf.html
awk "/Suppression/ {print \"^<caption align=left^>^<b^>\"$0\"^</b^>^</caption^>\"}" CodecProfiles.txt >> ENMconf.html
sed -i "/Suppression/  s;0;</b>Disabled<b>;g" ENMconf.html
sed -i "/Suppression/  s;1;</b>Enabled<b>;g" ENMconf.html
sed -i "1d" CodecProfiles.txt
awk "OFS=\";\" {print $1,\"Codec:\"$(NF-10),\"EarlyMedia:\"$(NF-9),\"DTMF:\"$(NF-8),$(NF-7),$(NF-6),$(NF-5),$(NF-4),$(NF-3),$(NF-2),$(NF-1),$NF}" CodecProfiles.txt > CodecProfiles.new.txt
awk "{$(NF-10)=$(NF-9)=$(NF-8)=$(NF-7)=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=\"\";print}" CodecProfiles.txt > CodecNames.txt
sed -i "s/ /;/" CodecNames.txt
sed -i "s/ *$//" CodecNames.txt
sed -i "s;Codec:0;g.711;g" CodecProfiles.new.txt
sed -i "s;Codec:1;g.732;g" CodecProfiles.new.txt
sed -i "s;Codec:2;g.729;g" CodecProfiles.new.txt
sed -i "s;EarlyMedia:0;Disabled;g" CodecProfiles.new.txt
sed -i "s;EarlyMedia:1;enabled;g" CodecProfiles.new.txt
sed -i "s;DTMF:0;In band;g" CodecProfiles.new.txt
sed -i "s;DTMF:1;Default;g" CodecProfiles.new.txt
sed -i "s;DTMF:2;RFC 2833;g" CodecProfiles.new.txt
join -t ; CodecNames.txt CodecProfiles.new.txt > Codecs.txt
echo ^<tr^> ^<th^>Profile Name^</th^>^<th^>Profile #^</th^>^<th^>Codec^</th^>^<th^>Early Media^</th^>^<th^>DTMF^</th^>^<th^>g.711 Min^</th^>^<th^>g.711 Max^</th^>^<th^>g.723 Min^</th^>^<th^>g.723 Max^</th^>^<th^>g.729 Min^</th^>^<th^>g.729 Max^</th^>^<th^>g.711 Length^</th^>^<th^>g.729 Length^</th^>^</tr^>  >>ENMConf.html
awk -F";" "{print \"^<tr^>^<td^>\"$2\"^</td^>^<td^>\"$1\"^</td^>^<td^>\"$3\"^</td^>^<td^>\"$4\"^</td^>^<td^>\"$5\"^</td^>^<td^>\"$6\"ms^</td^>^<td^>\"$7\"ms^</td^>^<td^>\"$8\"ms^</td^>^<td^>\"$9\"ms^</td^>^<td^>\"$10\"ms^</td^>^<td^>\"$11\"ms^</td^>^<td^>\"$12\"ms^</td^>^<td^>\"$13\"ms^</td^>^</tr^>\"}" Codecs.txt >>ENMConf.html
echo ^</table^> >> ENMconf.html

::Replace Codec ID's in "IPDeviceRanges.txt" with Codec Names
awk -F";" "{print \"sed -i 's/codec:\"$1\"/,\"$2\"/' IPDeviceRanges.txt\"}" Codecs.txt > CodecVars.bat
sed -i "s/'/\"/g" CodecVars.bat
call CodecVars.bat
sed -i "s/ /,/" IPDeviceRanges.txt
sed -i "s/.->./,/" IPDeviceRanges.txt

::Codec Profile Assignments Table
echo ^<table border="1" cellpadding="3" style="font-family:arial;font-size:12"^> >>ENMconf.html
echo ^<caption style="font-family:arial;font-size:18" align="left"^>^<b^>^<u^>Codec Profile Assignments^</u^>^</b^>^</style^>^</caption^> >>ENMconf.html
echo ^<tr^>^<th^>From:^</th^>^<th^>To:^</th^>^<th^>Codec Profile:^</th^>^<th^>Range ID:^</th^>^<tr^> >> ENMconf.html
awk -F"," "{print \"^<tr^>^<td^>\"$2\"^</td^>^<td^>\"$3\"^</td^>^<td^>\"$6\"^</td^>^<td^>\"$1\"^</td^>^</tr^>\"}" IPDeviceRanges.txt >> ENMconf.html
echo ^</table^> >> ENMconf.html



sed -i "s;^.*$;&<br>;g" ENMconf.html
del decip.tmp DinaProxyDump.tmp CodecProfiles.txt convip.bat decip.tmp.txt IPDeviceRanges.txt NATip.txt DinaProxyDump.tmp.txt CodecProfiles.new.txt CodecNames.txt Codecs.txt CodecVars.bat IPRanges.txt IPDialingTable.txt








