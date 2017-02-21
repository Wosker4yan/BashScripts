#!/bin/bash
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi


function print_info {
		echo "			*****HELP SECTION***** 		"	
		echo " "				
		echo "		For CPU type following commands: "
		echo " "				
		echo " -mn			: for model information"
		echo " -core			: to see the number of cores"
		echo " -cpu			: for all cpu information. "
		echo " -fr                  	: for cpu's frequency. "
		echo " -cache 			: for cpu's cache."
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
		echo "		For RAM type following commands: "
		echo " "
		echo "-ram			: for RAM."
		echo "-mem			: for RAM Memory."	
		echo " "	
		echo " "
		echo " "
		echo " "	
		echo "		Other options "	
		echo " "				
		echo " -all			:prints important information about RAM/CPU/GPU"											
		echo " "
		echo " "			
		echo " "			
		echo " "		
		echo "			*************************** 		"	

}

function print_whole {
		echo " " 	
		echo " 			CPU Info: "	
		echo " " 
		cat /proc/cpuinfo | grep 'model name'| awk '{print "Frequency: ", $9}'|tail -1
		cat /proc/cpuinfo | grep 'cache size'|awk '{print "Cache: ", $4, $5}'|head -1
		cat /proc/cpuinfo | grep 'cpu.cores' | head -1 | awk '{print "Cores: ", $4}'
		cat /proc/cpuinfo | grep -e model -e name | awk '{print "Model: ",  $6}'| tail -1
		echo " " 	
		echo "			GPU Info: "	
		echo " " 	
		sudo lshw -C display | grep 'clock' | awk '{print "clock: ",  $2}'|head -1
		sudo lshw -C display| grep 'product'|awk '{print "Name : ", $2, $3, $4, $5}'|head -1
		sudo lshw -C display| grep 'product'|awk '{print "Product:", $2, $3, $4, $5}'|tail -1
		echo " " 	
		echo "			   RAM: "	
		echo " " 
		awk '/MemTotal/ {printf "Memory: %.02fGB\n", $2/1024/1024}' /proc/meminfo
		sudo lshw -short -C memory|grep '/0/c/0'|awk '{print "Frequency: " $7, $8 }'
		sudo lshw -short -C memory|grep '/0/c/0'|awk '{print "Type of DD3: " $5 }'


}



function print_all {
		if [ $# -eq 0 -o $# -gt 2 ]; then
			print_help
			fi
		for i in $@; do		
			case $i in
			
			-h|--help) 
				print_info
				;;
			#prints RAM/GPU/CPU information.
			-all)
				print_whole
				;;
			#prints CPU frequency
			-fr)
				cat /proc/cpuinfo | grep 'model name'| awk '{print "Frequency: ", $9}'|tail -1
				;;
			-cache)
				cat /proc/cpuinfo | grep 'cache size'|awk '{print "Cache: ", $4, $5}'|head -1
				;;
			#prints all CPU information.
			-cpu) 
				cat /proc/cpuinfo
				;;
			#prints the number of cores.			
			-cores) 
				cat /proc/cpuinfo | grep 'cpu.cores' | head -1	
				;;
			#prints all GPU information.
			-gpu) 
				sudo lshw -C display 
				;;	
			#prints all GPU information.
			-clock) 
				echo "Your GPU clock is: "
				sudo lshw -C display | grep '..MHz'| head -1
				;;	
			-ver) #prints GPU product name and vendor name.
				sudo lshw -C display | grep -e product -e vendor
				;;	
			-spec) #prints specific brief characteristics.
				for s in $(lspci | grep VGA | awk '{print $1}'); do
					 lspci -v -s $s; 
				done
				;;	
			-mn)
				cat /proc/cpuinfo | grep 'model name'| awk '{print "Frequency: ", $9}'|tail -1;;
			-ram)
				cat /proc/meminfo
				;;
			-mem)
				sudo lshw -short -C memory
				;;
			
			*) #misspeled the flag.
				echo "Error: Invalid flag $i not found."
				;;
			
		esac
	done
}

function print_help {
	echo "$0: invalid option"
	echo "Try '$0 --help or -h' for mor information"
}
		
main() {
	$1
	print_all $@
}

main $@
