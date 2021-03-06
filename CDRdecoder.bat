::This script uses "sed", "gdate," and "join"
@echo off
::Consolidate any CDR files
gsort NewCDRExt*.txt > CDRExt
::Remove blank lines, and remove lines that do not start with a timestamp
sed -i "/^$/d" CDRExt
sed -i "/^20[[:digit:]][[:digit:]]/!d" CDRExt
::Script to calculate the time offset
sed q CDRExt > EndTimeLoc
sed -i "s;\(^.*[[:digit:]]*:[[:digit:]]*:[[:digit:]]*\).*$;\1;" EndTimeLoc
gdate -f EndTimeLoc +%%s > EndTimeUTC
set /P EndtimeUTC=<EndTimeUTC
sed q CDRExt > timecalc
sed "s;^.*<BT>\([[:digit:]]*\)*</BT.*<TD>\([[:digit:]]*\)</TD>.*$;\1;" timecalc > starttime
sed "s;^.*<BT>\([[:digit:]]*\)*</BT.*<TD>\([[:digit:]]*\)</TD>.*$;\2;" timecalc > duration
set /P starttime=<starttime
set /P duration=<duration
set /A starttime = starttime 
set /A endtimeUTC = EndTimeUTC 
set /A offset = EndTimeUTC-starttime
set /A offset = offset-duration
::number the lines
sed = CDRExt|sed "N;s/\n/wumbo /">CDRNumbered
::Extract the  UTCtimestamp and prep it to be run through gdate
::sed "s;^.*<BT>\([[:digit:]]*\)</BT>.*$;UTC 1970-01-01 \1 secs %offset% secs;g" CDRNumbered > UTCConv
sed "s;^.*<BT>\([[:digit:]]*\)</BT>.*$;UTC 1970-01-01 \1 secs %offset% secs;g" CDRNumbered > UTCConv
::convert the timestamp from utc to real people time!
gdate -f UTCConv +"%%Y-%%m-%%d %%T" > CDRTimestamp
::Add "TIME" Flags
sed -i "s;\(.*\);<TIME>\1</TIME>;g" CDRTimestamp
::Number the timestampfile file
sed = CDRTimestamp|sed "N;s/\n/wumbo /">CDRTimeNumbered
::Join the files to get the human timestamp into the file
join CDRTimeNumbered CDRNumbered > CDR.txt
::delete  the line number, the original timestamp and the UTC Stamp
sed -i "s;^.*\(<TIME>.*</TIME>\).*</BT>;<E>\1;g" CDR.txt
gsort CDR.txt -o CDR.txt

::Run the decoding file to convert to .html
sed -f "%InstallationLocation%\sedCDR" CDR.txt > NewCDRExt.html

::Cleanup
del CDRExt CDRNumbered UTCConv CDRTimestamp CDRTimeNumbered CDR.txt EndTimeLoc EndTimeUTC Timecalc starttime duration



