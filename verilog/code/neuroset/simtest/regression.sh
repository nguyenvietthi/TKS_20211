#!/bin/sh
# -----------------------------------------------------------------------------
# Author : yongchan jeon (Kris) poucotm@gmail.com
# File   : regression.sh
# Create : 2020-11-15 11:53:33
# Editor : sublime text3, tab size (3)
# -----------------------------------------------------------------------------

if [[ $# -gt 0 ]]; then
	for l01 in `echo $@`; do
		if [[ ${#l01} -ge 2 ]]; then
			Ol0=`expr "${l01}" : "\([+-][a-zA-Z]\w*\)"`
			lO1=`expr "${l01}" : "${Ol0}=\(.*\)"`
			if [[ "${Ol0:0:1}" == "+" ]]; then
				eval ${Ol0:1}="'${l01}'"
				eval ${Ol0:1}S="+"
				eval ${Ol0:1}V="'${lO1}'"
			elif [[ "${Ol0:0:1}" == "-" ]]; then
				eval ${Ol0:1}="'${l01}'"
				eval ${Ol0:1}S="-"
				eval ${Ol0:1}V="'${lO1}'"
			fi
		fi
	done
fi

# work directory
if [ ! -e "work" ]; then
	vlib work
fi
# result directory
if [ ! -e "result" ]; then
	mkdir result
fi
\rm -rf result/*.log

# iteration log
\rm -rf iter.log
echo "memorywork regression" > iter.log

# regression
for (( i = 0; i < $1; i++ )); do
	RND=`head -c4 /dev/urandom | od -N4 -tu4 | sed -ne '1s/.* //p'`
	TYPE=`expr ${RND} % 2`

	vlog -f file.list +define+TYPE=${TYPE} -timescale "1ns/1ps"
	vsim -novopt work.tb_memorywork -do run.do -logfile run.log -sv_seed random

	pass=`grep -E "PASS|SUCCESS" run.log`
	fail=`grep -E "FAIL" run.log`
	if [[ "$pass" == "" || "$fail" != "" ]]; then
		exit
	else
		echo "[ ${i} - TYPE=${TYPE} ]">> iter.log
	fi
done
