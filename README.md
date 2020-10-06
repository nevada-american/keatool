Simple CLI tool to manipulate mysql tables used by Kea DHCP backend database.

Note:

To support DDNS updates, you will need to build this hook:

zorun/kea-hook-runscript

Then use the DDNS update shell script to process the updates.

Our specific use case was for DDNS to Windows AD DNS; the extensive theatrics involved for this are NOT required if you use a sensible DNS server (ISC BIND).  

To generate the credentials needed for a Linux server to push DDNS updates to Active Directory, see:

https://docs.infoblox.com/display/NAG8/About+GSS-TSIG#AboutGSS-TSIG-bookmark1974

