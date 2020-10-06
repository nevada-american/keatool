#!/bin/bash

## CONFIGURATION ##

realm=DRI.LOCAL
# Each keytab maps a ddns user (ddns or ddns-s) to the below principal.
# Grabbing a ticket for the user principal won't work - it has to be for the
# service/host principal.
principal="DNS/dhcp-nnsc-1.dri.edu@DRI.LOCAL"
keytab=/home/ddns@DRI.local/ddns-n.keytab
domain=dri.local
ns=maximus.dri.local
#ptr_suffix=.in-addr.arpa
logfile=/var/log/kea-hook-ddns.log
select="lease4_select"
commit="leases4_committed"
renew="lease4_renew"
subselect="subnet4_select"
timestamp=`date`
echo "====>>Captured Hook<<====" >> $logfile
echo "== $1 ==" >> $logfile
echo "====>>End Hook<<====" >> $logfile

#if [ ${SELECT} == $1 ]; then
#	echo ">> $1 <<" >> ${LOGFILE}
#	echo ${KEA_LEASE4_HOSTNAME} >> ${LOGFILE}
#	echo ${KEA_LEASE4_ADDRESS} >> ${LOGFILE}
#
#elif [ ${RENEW} == $1 ]; then
#	echo ">> $1 <<" >> ${LOGFILE}
#	echo ${KEA_LEASE4_HOSTNAME} >> ${LOGFILE}
#	echo ${KEA_LEASE4_ADDRESS} >> ${LOGFILE}
#
#else
#	echo
#fi
#/usr/bin/kinit DNS/dhcp-snsc-1.dri.edu@DRI.LOCAL -k -t ddns-s.keytab

#su -c "/usr/bin/kinit $principal -k -t $keytab" ddns-s@DRI.local

if [ $renew == $1 ] || [ $select == $1 ]; then
	echo ">>> $1 <<<" >> $logfile
	echo $timestamp >> $logfile
	echo "Inside --if-- statement" >> $logfile
	echo "Running /usr/bin/kinit $principal -k -t $keytab now..." >> $logfile
	ID=`id`
	echo $ID >> $logfile
	/usr/bin/kinit $principal -k -t $keytab

	# Generate PTR format for reverse zone entry
	#
	ptr=`echo ${KEA_LEASE4_ADDRESS} | awk -F'.' '{print $4,".",$3,".",$2,".",$1,".in-addr.arpa"}'|sed 's/ //g'`
	echo $ptr >> $logfile
	# Log what we're about to do
	echo "Adding PTR record $ptr for ${KEA_LEASE4_HOSTNAME} and A record for ${KEA_LEASE4_HOSTNAME} and ${KEA_LEASE4_ADDRESS}" >> $logfile
	echo "server $ns
	realm $realm
	update add ${KEA_LEASE4_HOSTNAME} 3600 A ${KEA_LEASE4_ADDRESS}
	send
	update add $ptr 3600 PTR ${KEA_LEASE4_HOSTNAME}
	send" >> $logfile
	# Process the update, forward and reverse zones
	/bin/nsupdate -D -g <<-EOT
	server $ns
        realm $realm
        update add ${KEA_LEASE4_HOSTNAME} 3600 A ${KEA_LEASE4_ADDRESS}
	send
        update add $ptr 3600 PTR ${KEA_LEASE4_HOSTNAME}
	send
	EOT
fi
