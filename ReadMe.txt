MaxDecoder v.0.2.6
==================

The decoder tool is meant to be run against a collected AltiServ trace package.
It is context menu driven, and will automatically open a browser page with the description
file (inputed during the collection of the trace), containing links to the decoded files.

HOWTO USE THIS TOOL:
--------------------
To run the tool, extract the collectd trace from the .zip file, and the right click on the
"log" folder and select "MaxDecoder"


NOTES:
------
1.  This tool makes use of several GNU programs, and an attempt has been made to make sure
that the license is intact and complied with.  Please refer to their site for information
regaring their fine software:
	http://gnuwin32.sourceforge.net/
	
2.  This tool is by no means a complete catalog of every event that can occur on the
system.  It does not attempt to analyze the sum of trace file and make conclusions.  Each
line of the decoded files is evaluated on it's own, and comments are added where it has
been deemed useful.  Determining why a sequence of events occured is left to humans.

2.  This tool is not made to be run against a live running system log files.  Please
collect the trace first.  It is recommened that the files be decoded on another machine.
The primary purpose of the AltiGen server is to process phone calls.

3.  Depending on the build of the server, the traces running, and some files may or may
not be generated.  Example:  The Client Login file is generated from the CTProxyDump.txt
file, which is not created in AltiWare 5.1 therefore, an empty file is created durring the
decoding process.

4.  This is designed to decode trace files for 5.1 and above systems.


FEEDBACK:
---------
Please send feedback to ben.kaufman@altigen.com


Updates:
--------

0.2.6
-- Added handling for SERVICE and SERVICE ACK messages in TritonSP logs (were previously showing as CONNECT / CONNECT ACK)
-- Cleanup any sed* files left over from parsing.

0.2.5
-- Fixed minor issue with ATPSXML parsing that caused the html to display improperly in large atpsxml files.

0.2.4:
-- Now converting DSP files to html. Converting timestamps to real time (no dates), highlighting some specific lines.