		getColor() {
	if [[ -n "$1" ]]; then
		if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
			if [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -gt 1 ]] || [[ ${BASH_VERSINFO[0]} -gt 4 ]]; then
				tmp_color=${1,,}
			else
				tmp_color="$(tr '[:upper:]' '[:lower:]' <<< ${1})"
			fi
		else
			tmp_color="$(tr '[:upper:]' '[:lower:]' <<< ${1})"
		fi
		case "${tmp_color}" in
			'black')	color_ret='\033[0m\033[30m';;
			'red')		color_ret='\033[0m\033[31m';;
			'green')	color_ret='\033[0m\033[32m';;
			'brown')	color_ret='\033[0m\033[33m';;
			'blue')		color_ret='\033[0m\033[34m';;
			'purple')	color_ret='\033[0m\033[35m';;
			'cyan')		color_ret='\033[0m\033[36m';;
			'yellow')	color_ret='\033[0m\033[1;33m';;
			'white')	color_ret='\033[0m\033[1;37m';;
			
			'dark grey')	color_ret='\033[0m\033[1;30m';;
			'light red')	color_ret='\033[0m\033[1;31m';;
			'light green')	color_ret='\033[0m\033[1;32m';;
			'light blue')	color_ret='\033[0m\033[1;34m';;
			'light purple')	color_ret='\033[0m\033[1;35m';;
			'light cyan')	color_ret='\033[0m\033[1;36m';;
			'light grey')	color_ret='\033[0m\033[37m';;
			# Some 256 colors
			'orange') color_ret="$(colorize '202')";;
			# HaikuOS
			'black_haiku') color_ret="$(colorize '7')";;
			#ROSA color
			'rosa_blue') color_ret='\033[01;38;05;25m';;
		esac
		[[ -n "${color_ret}" ]] && echo "${color_ret}"
	else
		:
	fi
}


			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'yellow') # White
				c2=$(getColor 'light green') # White
				c3=$(getColor 'light blue') # White
				c4=$(getColor 'light purple') # White
				c5=$(getColor 'white') # White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			fulloutput=(
"${c1}                   ..                   %s"
"${c1}                 .PLTJ.                 %s"
"${c1}                <><><><>                %s"
"       ${c2}KKSSV' 4KKK ${c1}LJ${c4} KKKL.'VSSKK       %s"
"       ${c2}KKV' 4KKKKK ${c1}LJ${c4} KKKKAL 'VKK       %s"
"       ${c2}V' ' 'VKKKK ${c1}LJ${c4} KKKKV' ' 'V       %s"
"       ${c2}.4MA.' 'VKK ${c1}LJ${c4} KKV' '.4Mb.       %s"
"${c4}     . ${c2}KKKKKA.' 'V ${c1}LJ${c4} V' '.4KKKKK ${c3}.     %s"
"${c4}   .4D ${c2}KKKKKKKA.'' ${c1}LJ${c4} ''.4KKKKKKK ${c3}FA.   %s"
"${c4}  <QDD ++++++++++++  ${c3}++++++++++++ GFD>  %s"
"${c4}   'VD ${c3}KKKKKKKK'.. ${c2}LJ ${c1}..'KKKKKKKK ${c3}FV    %s"
"${c4}     ' ${c3}VKKKKK'. .4 ${c2}LJ ${c1}K. .'KKKKKV ${c3}'     %s"
"       ${c3} 'VK'. .4KK ${c2}LJ ${c1}KKA. .'KV'        %s"
"       ${c3}A. . .4KKKK ${c2}LJ ${c1}KKKKA. . .4       %s"
"       ${c3}KKA. 'KKKKK ${c2}LJ ${c1}KKKKK' .4KK       %s"
"       ${c3}KKSSA. VKKK ${c2}LJ ${c1}KKKV .4SSKK       %s"
"${c2}                <><><><>                 %s"
"${c2}                 'MKKM'                  %s"
"${c2}                   ''")