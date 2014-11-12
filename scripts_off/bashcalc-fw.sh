#!/bin/bash
# Bash Calculator Framework
# CS9E - Assignment 4.1
#
# Framework by Jeremy Huddleston <jeremyhu@cs.berkeley.edu>
# $LastChangedDate: 2007-10-11 15:49:54 -0700 (Thu, 11 Oct 2007) $
# $Id: bashcalc-fw.sh 88 2007-10-11 22:49:54Z selfpace $

## Floating Point Math Functions ##

# ==============================================================
# 		. bashcalc-fw.sh 				# enter in command line to source
# 		bashcalc "s(3.14159*0.25)"  	# sample function call 
# ==============================================================


# bashcalc <expression>
# This function simply passes in the given expressions to 'bc -l' and prints the result
function bashcalc {
	# ADD CODE HERE FOR PART 2
	echo $1 | bc -l
}

# Remove this line when you start part 3
# return 0

# sine <expression>
# This function prints the cosine of the given expression
function sine {
	# ADD CODE HERE FOR PART 3
	echo "s($1)" | bc -l
}


# cosine <expression>
# This function prints the cosine of the given expression
function cosine {
	# ADD CODE HERE FOR PART 3
	echo "c($1)" | bc -l

}

# angle_reduce <angle>
# Prints the angle given expressed as a value between 0 and 2pi
function angle_reduce {
	# ADD CODE HERE FOR PART 3
	LEN=${#1}

	TWO_PI=$(echo "8*a(1)" | bc -l)
	TWO_LEN=${#TWO_PI}


	# determine scale
	if [ $LEN -gt $TWO_LEN ]; then
		SCALE=$LEN
	else
		SCALE=$TWO_LEN
	fi

	NUM=$1
	if [ $(echo "scale=$LEN1; $1 >= 0" | bc -l) -eq 1 ]; then
		# Positive; keep subtracting TWO_PI until in range
		while float_lt "$TWO_PI" "$NUM"
		do
			NUM=$(echo "scale=$SCALE; $NUM - $TWO_PI" | bc -l)
		done
	else 	
		# Negative; keep adding TWO_PI until in range
		while float_lt "$NUM" "0" 
		do
			NUM=$(echo "scale=$SCALE; $NUM + $TWO_PI" | bc -l)
		done
	fi

	# output final number
	echo $NUM


}

# float_{lt,lte,eq} <expr 1> <expr 2>
# These functions returns true (exit code 0) if the first value is less than the second (lt),
# less than or equal to the second (lte), or equal to the second (eq).
# Note: We can't just use BASH's builtin [[ ... < ... ]] operator because that is
#       for integer math.
function float_lt {
	# ADD CODE HERE FOR PART 3
	LEN1=${#1}
	LEN2=${#2}
	LEN2=$(($LEN1 + $LEN2))
	if [ $LEN1 -lt $LEN2 ]; then
		if [[ $(echo "scale=$LEN2; $1 < $2" | bc -l) = 1 ]]; then
			# echo "swag"
			return 0
		else
			return 1
		fi
	else
		if [[ $(echo "scale=$LEN2; $1 < $2" | bc -l) = 1 ]]; then
			# echo "chill"
			return 0
		else
			return 1
		fi
	fi 
}

function float_eq {
	# ADD CODE HERE FOR PART 3
	LEN1=${#1}
	LEN2=${#2}
	if [ $LEN1 -lt $LEN2 ]; then
		if [ $(echo "scale=$LEN2; $1 == $2" | bc -l) = "1" ]; then
			# echo "chill"
			return 0
		else
			return 1
		fi
	else
		if [ $(echo "scale=$LEN1; $1 == $2" | bc -l) = "1" ]; then
			# echo "chill"
			return 0
		else
			return 1
		fi
	fi
}

function float_lte {
	# ADD CODE HERE FOR PART 3
	LEN1=${#1}
	LEN2=${#2}
	if [ $LEN1 -lt $LEN2 ]; then
		if [ $(echo "scale=$LEN2; $1 <= $2" | bc -l) = "1" ]; then
			# echo "chill"
			return 0
		else
			return 1
		fi
	else
		if [ $(echo "scale=$LEN1; $1 <= $2" | bc -l) = "1" ]; then
			# echo "chill"
			return 0
		else
			return 1
		fi
	fi 
}
