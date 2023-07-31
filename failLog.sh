#!/bin/bash

logPath="/var/log/auth.log"

reportFunc(){
    fails=$(grep -a "Failed password" "$logPath" | awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" \
"$13" "$14" "$15" "$16}')

    for user in $failUsr; do
        ((failArray[$user]++))
    done

    if [ -n "$fails" ]; then
        echo "Failed login attempts:"
        echo "$fails"
        echo " "
        echo "Repeat failed IP connection attempts:"


        sudo lastb | awk '{if ($3 ~ /([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}/)a[$3] = a[$3]+1} END {for (i in a){print i " : \
" a[i]}}' | sort -nk 3

        read -p "Would you like to ban the IP addresses and secure the system? (y/n)" yn
        case $yn in
            y ) echo ok, banning IPs;
                read -p "Enter the IP to ban." ipB;
                iptables -A INPUT -s "$ipB" -j DROP;;
            n) echo ok, will exit now.
               exit;;
            * ) echo exiting now;;
        esac
    fi


}
reportFunc





