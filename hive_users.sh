# Iterates through all hive machine servers and prints out the number of users on each machine.

printf "\n"

for serv_numb in {1..28} ; do
	if [ "$serv_numb" == "6" -o "$serv_numb" == "7" -o "$serv_numb" == "9" -o "$serv_numb" == "14" -o "$serv_numb" == "17" -o "$serv_numb" == "20" -o "$serv_numb" == "23" -o "$serv_numb" == "25" ]; then
		echo "hive $serv_numb is not meant to be connected. access denied by default"
		continue
	fi

	NUMB="$(ssh cs61c-dv@hive$serv_numb.cs.berkeley.edu who | wc -l)" 
	if [[ "$NUMB" -eq 0 ]]; then
		echo "hive" $serv_numb "has" $NUMB "users. confirm if network reachable"
		continue
	else 
		echo "hive" $serv_numb "has" $NUMB "users"
	fi
done

printf "\n"

# 6 7 9 14 17 20 23 25