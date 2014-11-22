#!/bin/sh

# author : MailG
# email : gomailgm@gmail.com

PROGNAME=$0
CURRUNT_RELEASE=$(cat /etc/issue | sed "s#[^0-9]##g")
DEFAULT_STORE_PATH_PRIFIX=/home

help(){
	echo "Usage : $1 [-r <804|1004|1104|1110|1204|1210>] [-a <amd64|i386>] [-n <name>] [-p <store_path>] [-h]"
	cat<<EOF
-r, releasenum. Will be ${CURRUNT_RELEASE} if not set.
-a, arch. Will be amd64 if not set.
-n, name pix, Will be ubuntu if not set.
-p, store_path, it is prefix of your lxc store path where you store the lxc guest system. Will be ${DEFAULT_STORE_PATH_PRIFIX}.
-h, this help.
EOF
}

if [ $# -eq 0 ];then
	help $PROGNAME
fi

OPTERR=1
while getopts p:a:r:n:h OPTIONS;do
	case "$OPTIONS" in
		a) arch=$OPTARG ;;
		r) releasenum=$OPTARG ;;
		n) namepix=$OPTARG ;;
		p) store_path=$OPTARG ;;
		h) help $PROGNAME && exit 1 ;;
	esac
done

if [ -z "${arch}" ];then
	arch=amd64
fi

if [ "${releasenum}" = "1004" ];then
	release=lucid
elif [ "${releasenum}" = "804" ]; then
	release=hardy
elif [ "${releasenum}" = "1104" ]; then
	release=natty
elif [ "${releasenum}" = "1110" ]; then
	release=oneiric
elif [ "${releasenum}" = "1204" ]; then
	release=precise
elif [ "${releasenum}" = "1210" ]; then
	release=quantal
elif [ "${releasenum}" = "1304" ]; then
	release=raring
elif [ "${releasenum}" = "1310" ]; then
	release=saucy
elif [ "${releasenum}" = "1404" ]; then
	release=trusty
else
	releasenum=${CURRUNT_RELEASE}
	release=$(cat /etc/lsb-release | grep CODE | sed "s#.*=\(.*\)#\1#g")
fi

if [ -z "${namepix}" ]; then
	namepix='ubuntu'
fi

if [ -z "${store_path}" ];then
	store_path=${DEFAULT_STORE_PATH_PRIFIX}
fi

name=${releasenum}_${arch}_${namepix}_lxc
storepath=${store_path}/lxc/ubuntu_rootfs/${name}/

exec_command="sudo lxc-create -t ubuntu -n ${name} -B dir --dir ${storepath} -- -r ${release} -a ${arch}"
echo ${exec_command}
echo  -n "Do you want to start like that:(N/y)" 

read yx

if [  "x$yx" = "xy" -o "x$yx" = "xY" ];then
	${exec_command}
fi 
