#!/bin/bash
# Tested with a RX 580 and a Ryzen 5 5600G
# based on documention found here:
#	https://www.kernel.org/doc/html/latest/gpu/amdgpu.html#gpu-power-thermal-controls-and-monitoring

if [ -n "$1" ] && [ ! -f ~/.local/share/icons/sensors-applet-gpu.png ];then
	# download icon if not present
	mkdir -p ~/.local/share/icons/
	wget https://raw.githubusercontent.com/alexmurray/sensors-applet/master/pixmaps/sensors-applet-gpu.png -O ~/.local/share/icons/sensors-applet-gpu.png
fi

AMD_GPU_CT=$(ls /sys/class/drm/ | grep "^card[0-9]$" | wc -l)
i=0
while [ $i -lt $AMD_GPU_CT ];do
	dev="/sys/class/drm/card$i/device"
	devs[$i]="$dev"
	mons[$i]="$dev/hwmon/$(ls $dev/hwmon)" # $dev/hwmon should have a single folder in it
	i=$(($i+1))
done
while [ 1 ]; do
	i=0
	OUT=""
	while [ $i -lt $AMD_GPU_CT ];do
		dev=${devs[$i]}
		mon=${mons[$i]}
		read -r coreClk < $mon/freq1_input
		coreClk=$(($coreClk/1000000))
		read -r corePct < $dev/gpu_busy_percent
		if [ -f $mon/freq2_input ];then
			read -r memClk < $mon/freq2_input
			memClk=$(($memClk/1000000))
		else
			memClk="N/A"
		fi
		if [ -f $mon/fan1_input ];then
			read -r fanSpd < $mon/fan1_input
			read -r fanPct < $mon/pwm1
			fanPct=$(($fanPct*100/255))
			#read -r fanTgt < $mon/fan1_target
			read -r fanCtrl < $mon/pwm1_enable
		else
			fanSpd="N/A"
			fanPct="N/A"
			fanCtrl="N/A"
		fi
		read -r temp < $mon/temp1_input
		temp=$(($temp/1000))
		read -r pwr < $mon/power1_average
		pwr=$(($pwr/1000000))
		if [ -f $mon/power1_cap ];then
			read -r pwrLmt < $mon/power1_cap
			pwrLmt=$(($pwrLmt/1000000))
		else
			pwrLmt="N/A"
		fi
		read -r volt < $mon/in0_input
		read -r mem < $dev/mem_info_vram_total
		mem=$(($mem/1000000))
		read -r memUsed < $dev/mem_info_vram_used
		memUsed=$(($memUsed/1000000))
		memPct=$(($memUsed*100/$mem))
		if [ -f $dev/mem_busy_percent ];then
			read -r memLoad < $dev/mem_busy_percent
		else
			memLoad="N/A"
		fi
		case $fanCtrl in
			0)
				fanCtrl="Disabled"
				;;
			1)
				fanCtrl="Manual"
				;;
			2)
				fanCtrl="Automatic"
				;;
		esac
		if [ -z "$1" ];then
			if [ $i -gt 0 ];then
				OUT+="\n--------------------------------------\n"
			fi
			OUT+="Core:\n\tClock:\t$coreClk Mhz\n\tTemp:\t$temp°C\n\tVolts:\t$volt mV (set)\n\tUsage:\t$corePct%\n"
			OUT+="Memory:\n\tClock:\t$memClk Mhz\n\tData:\t$memUsed / $mem MiB ($memPct%)\n\tUsage:\t$memLoad%\n"
			OUT+="Fan:\n\tSpeed:\t$fanSpd RPM ($fanPct%)\n\tMode:\t$fanCtrl\n"
			OUT+="Power:\n\tWatts:\t$pwr / $pwrLmt"
		else
			tooltip="<table><tbody><tr><td>Core:</td><td></td><td></td></tr><tr><td></td><td>Clock:</td><td>$coreClk Mhz</td></tr><tr><td></td><td>Temp:</td><td>$temp°C</td></tr><tr><td></td><td>Volts:</td><td>$volt mV (set)</td></tr><tr><td></td><td>Usage:</td><td>$corePct%</td></tr><tr><td>Memory:</td><td></td><td></td></tr><tr><td></td><td>Clock:</td><td>$memClk Mhz</td></tr><tr><td></td><td>Data:</td><td>$memUsed / $mem MiB ($memPct%)</td></tr><tr><td></td><td>Usage:</td><td>$memLoad%</td></tr><tr><td>Fan:</td><td></td><td></td></tr><tr><td></td><td>Speed:</td><td>$fanSpd RPM ($fanPct%)</td></tr><tr><td></td><td>Mode:</td><td>$fanCtrl</td></tr><tr><td>Power:</td><td></td><td></td></tr><tr><td></td><td>Watts:</td><td>$pwr / $pwrLmt</td></tr></tbody></table>"
			OUT+="| A | <img src=\"/home/$USER/.local/share/icons/sensors-applet-gpu.png\"/> $temp°C | $tooltip | |"
		fi
		i=$(($i+1))
	done
	if [ -z "$1" ];then
		clear
		echo -e "$OUT"
	else
		qdbus org.kde.plasma.doityourselfbar /id_$1 org.kde.plasma.doityourselfbar.pass "$OUT"
	fi
	sleep 5
done
exit
