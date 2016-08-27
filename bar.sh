#!/bin/bash

# Echo the text

font="-*-tewi-medium-*-*-*-11-*-*-*-*-*-*-*"

Clock() {
        DATE=$(date "+%a %b %d, %l:%M:%S %P ")

        echo -n "$DATE"
}


Volume() {
	vol=`amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1 /p'| uniq`
		if [[ $vol -ge 100 ]];
			then
				echo "░░▒▒▓▓███ ℳаϰ"
			elif [[ $vol -gt 90 && $vol -lt 100 ]];
				then
					echo "░░▒▒▓▓███"
			elif [[ $vol -gt 80 && $vol -lt 91 ]];
				then
					echo "░░▒▒▓▓██"
			elif [[ $vol -gt 70 && $vol -lt 81 ]];
				then
					echo "░░▒▒▓▓█"
			elif [[ $vol -gt 60 && $vol -lt 71 ]];
				then
					echo "░░▒▒▓▓"
			elif [[ $vol -gt 50 && $vol -lt 61 ]];
				then
					echo "░░▒▒▓"
			elif [[ $vol -gt 40 && $vol -lt 51 ]];
				then
					echo "░░▒▒"
			elif [[ $vol -gt 30 && $vol -lt 41 ]];
				then
					echo "░░▒"
			elif [[ $vol -gt 20 && $vol -lt 31 ]];
				then
					echo "░░"
			elif [[ $vol -gt 10 && $vol -lt 21 ]];
				then
					echo "░"
			elif [[ $vol -gt 0 && $vol -lt 11 ]];
				then
					echo "ℳⁱ◠"
			else
				echo "ℳ◡⊤ϵ"	
		fi
}

Playing() {	
	cur=`mpc current`
	test -n "$cur" && echo ♫  $cur  ♫ || echo "✖× Nothing Currently Playing ×✖"
}


while true; do
        echo "%{c}%{F#f4cc60}$(Playing)%{l}%{F#f4cc60} $(Volume)%{r}%{F#f4cc60}$(Clock)%{F-} "
        sleep 1;
done
