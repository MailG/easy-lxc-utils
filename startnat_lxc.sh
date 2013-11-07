#!/bin/bash
# author : MailG
# email : gomailgm@gmail.com

nat_lxc() 
{
	if [ "x${INTERFACE_NAME}" = "x" ];then
		echo -n "Enter your interface to route the nat(such as wlan0 or eth0 or ppp0) :(wlan0) "
		read INTERFACE_NAME
		if [ "x${INTERFACE_NAME}" = "x" ];then
			INTERFACE_NAME=wlan0
		fi
	fi
	if [ "x$1" = "x" -a "x$2" = "x" ]; then
		echo nat_lxc dport ip:port
		exit
	fi
	sudo iptables -t nat -A PREROUTING -p tcp --dport $1 -i ${INTERFACE_NAME} -j DNAT --to $2
	echo "$1 --> $2 OK". 
}

IP_BASE=200
main(){
	TOTAL_LXC=$(lxc-ls | sort | uniq)
	i=${IP_BASE}
	for j in ${TOTAL_LXC};
	do 
		((i++))
		nat_lxc 1${i}8 10.0.3.${i}:80
		nat_lxc 1${i}2 10.0.3.${i}:22
	done

}

main
