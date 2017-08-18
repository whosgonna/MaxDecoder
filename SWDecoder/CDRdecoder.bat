::This script uses "sed", "gdate," and "join"
@echo off
::Consolidate any CDR files
gsort NewCDRExt*.txt > CDRExt
::Remove blank lines
sed -i "/^$/d" CDRExt
::number the lines
sed = CDRExt|sed "N;s/\n/wumbo /">CDRNumbered
::Extract the  UTCtimestamp and prep it to be run through gdate
sed "s;^.*<BT>\([[:digit:]]*\)</BT>.*$;UTC 1970-01-01 \1 secs;g" CDRNumbered > UTCConv
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
::Run the decoding file to convert to .html
::sed -f "sedCDR" CDR.txt > NewCDRExt.html
sed -f "%programfiles%\SW Log Decoder\sedCDR" CDR.txt > NewCDRExt.html
::Cleanup
del CDRExt CDRNumbered UTCConv CDRTimestamp CDRTimeNumbered CDR.txt



