printf "\n"

for serv_numb in {1..28} ; do
	if [ "$serv_numb" == "25" ]; then
		echo "hive 25 is not meant to be connected. access denied by default"
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


# 6 7 9 14 17 20 23