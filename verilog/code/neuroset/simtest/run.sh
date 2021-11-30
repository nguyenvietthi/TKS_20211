#!/bin/sh
# -----------------------------------------------------------------------------
# Author : yongchan jeon (Kris) poucotm@gmail.com
# File   : run.sh
# Create : 2020-11-15 11:51:02
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

#option
SIMOPT="-vopt -do run.do -logfile run.log"
if [ "${seedS}" == "+" ]; then
	SIMOPT="$SIMOPT -sv_seed ${seedV}"
else
	SIMOPT="$SIMOPT -sv_seed random"
fi

# work directory
if [ ! -e "work" ]; then
	vlib work
fi
# compile
vlog -f file.list -timescale "1ns/1ps"
# simulation
vsim -voptargs=+acc work.tb_memorywork ${SIMOPT} ${vcd}
