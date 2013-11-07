#!/bin/bash
# author : MailG
# email : gomailgm@gmail.com

PROC_NAME=$0
LXC_CONF_PATH=/var/lib/lxc
IP_BASE=200

usage(){
	echo "${PROC_NAME} <-i ip_base>"
}

add_to_lxc_conf(){
	local ipv4_pattern="ipv4\s*="
	local ipv4_gateway_pattern="ipv4\.gateway\s*="
	local ipaddr=$1
	local lxc_conf_file=$2
	if grep -q "${ipv4_pattern}" ${lxc_conf_file} ;then
		sudo sed -i "s#\(lxc.network.ipv4\s\+=\).*#\1 ${ipaddr}#" ${lxc_conf_file}
	else
		sudo sed -i "/lxc.network.hwaddr/a\
lxc.network.ipv4 = ${ipaddr}
" ${lxc_conf_file}	
	fi

	if grep -q "${ipv4_gateway_pattern}" ${lxc_conf_file} ;then
		#grep "${ipv4_gateway_pattern}" ${lxc_conf_file}
		:
	else
		sudo sed -i "/lxc.network.hwaddr/a\
lxc.network.ipv4.gateway = 10.0.3.1
" ${lxc_conf_file}	
	fi

}

add_to_ssh_conf(){
	local ipaddr=$1
	local sshalias=$2
	local ssh_conf_file=~/.ssh/config
	if grep -q "${sshalias}" ${ssh_conf_file} ;then
		sed -i "/host ${sshalias}/ {
			N
			s/HostName\s[0-9.]*/HostName ${ipaddr}/
		}" ${ssh_conf_file}
	else
		cat>>${ssh_conf_file}<<EOF
host ${sshalias}
	HostName ${ipaddr}
	user ubuntu 
	IdentityFile ~/.ssh/id_rsa
EOF
	fi
}


main(){
	TOTAL_LXC=$(lxc-ls | sort | uniq)
	i=${IP_BASE}
	outputfile=~/lxc-ip-ssh-maplist
	echo "ip(x.x.x.x)   --    lxc-name (xxxx_xxx_ubuntu_xxx)       ssh alias ">${outputfile}
	for j in ${TOTAL_LXC};
	do 
		((i++))
		ip="10.0.3.$i"
		echo "configuring ${j} -- ${ip}/24 into ssh config"
		echo "${ip} <--> ${j} <--> lxc_${j} ">>${outputfile}
		add_to_lxc_conf ${ip}/24 ${LXC_CONF_PATH}/${j}/config
		add_to_ssh_conf ${ip} lxc_${j}
	done
}

test_add_to_lxc_conf(){
	add_to_lxc_conf 10.0.3.111/24 conf	
}

#test_add_to_lxc_conf
main

