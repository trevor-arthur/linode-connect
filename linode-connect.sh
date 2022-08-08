#!/bin/bash
# A script to create, remove, and check the status of SSH tunnels needed for securely VPCing to Linode servers


function main_menu() {
	# Main Menu
	echo ""
	echo "[*] Linode Connect"
	echo "[*] IP: ${IP_ADDR}"
	echo "[*] User: ${USER}"
	echo ""
	echo "[*] ---- Main Menu ----"
	echo "[1] Create SSH tunnel"
	echo "[2] Remove SSH tunnel"
	echo "[3] Check SSH tunnel status"
	echo "[h] Display the Main Menu"
	echo "[c] Clear the screen"
	echo "[q] Quit"
	echo ""
}


function error_check() {
        # An error checking function to see if commands worked successfully
        if [ $1 -ne 0 ]; then
                echo "[!] Error with:" $2
                exit 1
        fi
}


# Commands String
CREATE_STR="Creating SSH tunnel"
REMOVE_STR="Removing SSH tunnel"
STATUS_STR="Checking SSH tunnel status"


# Script
read -p "[?] Enter Linode Server IP: " IP_ADDR
read -p "[?] Enter Linode VPC username: " USER 
main_menu
while [ "$ANSWER" != "q" ]
do
	read -p "[?] What would you like to do?: " ANSWER
	case "$ANSWER" in
		1)
			echo "[*] ${CREATE_STR}..."
			ssh -L 61000:localhost:5901 -N -f ${USER}@23.239.22.152
			CREATE_CHK="$?"
			error_check $CREATE_CHK $CREATE_STR
			echo "[+] SSH tunnel successfully created!"
			echo "[*] You can now VPC to the instance using localhost:61000"
                        if [ -d /Applications/*VNC* ]; then
                                echo "[*] Starting VNC application..."
                                open /Applications/*VNC*
                        fi
			echo ""
			;;
		2)
			echo "[*] ${REMOVE_STR}..."
			kill $(ps aux | grep "61000:localhost:5901" | grep "Ss" | awk "{print $2}") &>/dev/null
			REMOVE_CHK="$?"
			error_check $REMOVE_CHK $REMOVE_STR
			echo "[+] SSH tunnel successfully removed!"
			echo ""
			;;
		3)
			echo "[*] ${STATUS_STR}..."
			ps aux | grep "61000:localhost:5901" | grep "Ss" &>/dev/null
			STATUS_CHK="$?"
			if [ $STATUS_CHK -eq 0 ]; then
				echo "[+] SSH tunnel is up!"
				echo ""
			else
				echo "[-] SSH tunnel is down!"
				echo ""
			fi
			;;
		h)
			main_menu
			;;
		c)
			clear
			;;
		q)
			echo "[*] Goodbye!"
			echo ""
			exit 1
			;;
		*)
			echo "[!] Invalid option"
			echo ""
			;;
	esac
done
