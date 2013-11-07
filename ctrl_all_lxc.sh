#!/bin/sh
# author : MailG
# email : gomailgm@gmail.com

CTRL=lxc-start
CTRL_ARG=-d
PROC=$0

usage() {
	echo $PROC "{start|stop}"		
}
if [ "$#" = "0" ];then
	usage;	
	exit;
fi
start_lxc(){
	CTRL=lxc-start	
	CTRL_ARG=-d
	echo -n "${CTRL} $i"
	sudo ${CTRL} -n $i ${CTRL_ARG}
	echo " OK"
}
stop_lxc(){
	CTRL=lxc-stop
	echo -n "${CTRL} $i "
	if sudo lxc-info -n $i -s | grep -qi "running" ; then
		sudo ${CTRL} -n $i 
		echo OK
	else
		echo Not started
	fi
}

main(){
	if [ "x$1" = "xstart" ];then
		CTRL_FUNC=start_lxc
	elif [ "x$1" = "xstop" ];then
		CTRL_FUNC=stop_lxc
	else
		usage;	
		exit;
	fi

	for i in $(lxc-ls | sort | uniq)
	do
		${CTRL_FUNC} $i 
	done	
}

main $1
