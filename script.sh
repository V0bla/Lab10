#!/bin/bash
# Скрипт реализации команды ps ax
# получаем pidы всех процессов и их кол-во
pids=$(ls /proc | awk '/[1-9]/{print $0}'| sort -n)
#pids=3296
# формат заголовока
fmt="%-10s%-10s%-10s%-10s%-60s\n"
printf	"$fmt" PID TTY STAT TIME CMDLINE

for pid in $pids
do
	if [[ -f /proc/$pid/stat ]]
	then
		# получаем tty
		tty=$(ls -l /proc/$pid/fd | awk '/0 ->/{print $11}' | grep -e pts -e tty -m1 | sed 's/\/dev\///g')	
		if [ -z $tty ]
		then
			tty='?'
		fi

		# считываем stat, utime, stime
		stats=$(awk '{print $3,$14,$15}' /proc/$pid/stat)
		stat=$(echo $stats | awk '{print $1}')
		utime=$(echo $stats | awk '{print $2}')
		stime=$(echo $stats | awk '{print $3}')

		#расчитываем time
		time_s=$[$[$utime+$stime]/$(getconf CLK_TCK)]
		time=$(date -u -d @$time_s +"%T")

		# получаем команду запустившую процесс

		cmd=$(cat /proc/$pid/cmdline | tr -d '\0' | cut -c 1-120 )
		if  [[ -z $cmd ]]
		then
			cmd="[`awk '/Name/{print $2}' /proc/$pid/status | cut -c 1-120`]"
		fi
		# выводим на экран
		printf	"$fmt" $pid	$tty	$stat	$time	"$cmd"
	fi
done
