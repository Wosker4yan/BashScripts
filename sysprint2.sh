#!/bin/bash

function print_info {
		echo "			********* 		"	
		echo " "				
		echo "		For CPU type following commands: "
		echo " "				
		echo "type -mi			: for model information"
		echo "type -core		: to see the number of cores"
		echo " "
		echo " "								
		echo "		For GPU type following commands: "
		echo " "
		echo " "				
		echo " "								
		echo "-gpu			: prints GPU information"
		echo "-spec             	: for specific GPU characteristics"
		echo "-ver or -vendor		: for GPU's product name and vendor's name"
		echo " "
		echo " "				
		echo " "				
		echo " "
		echo "		For RAM type following command: "
		echo " "
		echo "-ram			: for RAM."
		echo " "	
		echo " "
		echo " "
		echo " "	
		echo "		Other options "	
		echo " "				
		echo " -all			:prints important information about RAM/CPU/GPU"											
		echo " "	
		echo "			********* 		"	
		exit 0
}

function print_whole {
	echo "Processor frequency is: "
	cat /proc/cpuinfo | grep -o '....GHz$' | head -1
	cat /proc/cpuinfo | grep 'cpu.cores' | head -1 | sed 's/cpu cores/Number of cores of the CPU/g'
	cat /proc/cpuinfo | grep -e model -e name | tail -1 | sed 's/model name/CPU model name/g'
	echo "Your GPU clock is: " 
	sudo lshw -C display | grep '..MHz'
	sudo lshw -C display | grep '[[a-z A-Z]]'|awk {print$3}|sed 's/product:/Your GPU Model is:/g'
	cat /proc/meminfo | grep 'MemTotal' | sed 's/MemTotal/Total Memory is:/g'			
}

function print_all {
	 while test $# -gt 0; do
		case "$1" in

			-h|--help) #prints help
				print_info
				;;
			-all) #prints all RAM/GPU/CPU information.
				print_whole
				break
				;;
			#prints CPU frequency
			-fr)
				echo "Your processor working frequency is: "	
				cat /proc/cpuinfo | grep -o '....GHz$' | head -1
				break
				;;
			#prints all CPU information.
			-cpu) 
				cat /proc/cpuinfo
				break
				;;
			#prints the number of cores.			
			-core) 
				cat /proc/cpuinfo | grep 'cpu.cores' | head -1	
				break
				;;
			#prints all GPU information.
			-gpu) 
				sudo lshw -C display 
				break
				;;	
			#prints all GPU information.
			-clock) 
				echo "Your GPU clock is: "
				 sudo lshw -C display | grep '..MHz'
				break
				;;	
			-ver) #prints GPU product name and vendor name.
				sudo lshw -C display | grep -e product -e vendor
				break
				;;	
			-spec) #prints specific brief characteristics.
				for s in $(lspci | grep VGA | awk '{print $1}'); do
					 lspci -v -s $s; 
				done
				break
				;;	
			-mn)
				cat /proc/cpuinfo | grep -e model -e name | head -2
				break
				;;
			-ram)
				cat /proc/meminfo
				break
				;;
			-memtotal)
				cat /proc/meminfo | grep 'MemTotal'
				break
				;;
			*) #misspeled the flag.
				echo "Error: Invalid flag"
				break
				;;
		esac
	done
}
		
main(){
	print_all $@
}

main $@

