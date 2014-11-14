#!/bin/bash
# Cat & Mouse Framework
# CS9E - Assignment 4.2
#
# Framework by Jeremy Huddleston <jeremyhu@cs.berkeley.edu>
# $LastChangedDate: 2007-10-11 15:49:54 -0700 (Thu, 11 Oct 2007) $
# $Id: catmouse-fw.sh 88 2007-10-11 22:49:54Z selfpace $

# Source the file containing your calculator functions:
. bashcalc-fw.sh

# Additional math functions:

# angle_between <A> <B> <C>
# Returns true (exit code 0) if angle B is between angles A and C and false otherwise
function angle_between {
	local A=$1
	local B=$2
	local C=$3

	# calculate cosine values
	cos_B_A=$(cosine "$B - $A")
	cos_C_A=$(cosine "$C - $A")
	cos_C_B=$(cosine "$C - $B")

	# see if angle B is equal to either A or C
	if float_eq $B $A || float_eq $B $C; then
		return 0
	fi

	# see if mathematical condition is satisfied
	if float_lt $cos_C_A $cos_B_A && float_lt $cos_C_A $cos_C_B; then
		return 0 # true
	else
		return 1 # true
	fi
}

### Simulation Functions ###
# Variables for the state
RUNNING=0
GIVEUP=1
CAUGHT=2

# does_cat_see_mouse <cat angle> <cat radius> <mouse angle>
#
# Returns true (exit code 0) if the cat can see the mouse, false otherwise.
#
# The cat sees the mouse if
# (cat radius) * cos (cat angle - mouse angle)
# is at least 1.0.
function does_cat_see_mouse {
	local cat_angle=$1
	local cat_radius=$2
	local mouse_angle=$3

	DIF=$(bashcalc "$cat_angle - $mouse_angle")
	COS=$(cosine $DIF)
	FIN=$(bashcalc "$cat_radius*$COS")

	# check mathematical condition
	if float_lte 1.0 $FIN; then
		return 0 #true
	else
		return 1 #false
	fi 
}

# next_step <current state> <current step #> <cat angle> <cat radius> <mouse angle> <max steps>
# returns string output similar to the input, but for the next step:
# <state at next step> <next step #> <cat angle> <cat radius> <mouse angle> <max steps>
#
# exit code of this function (return value) should be the state at the next step.  This allows for easy
# integration into a while loop.
function next_step {
	local state=$1
	local -i step=$2
	local old_cat_angle=$3
	local old_cat_radius=$4
	local old_mouse_angle=$5
	local -i max_steps=$6

	local new_cat_angle=${old_cat_angle}
	local new_cat_radius=${old_cat_radius}
	local new_mouse_angle=${old_mouse_angle}

	# First, make sure we are still running
	if (( ${state} != ${RUNNING} )) ; then
		echo ${state} ${step} ${old_cat_angle} ${old_cat_radius} ${old_mouse_angle} ${max_steps}
		return ${state}
	fi

	# increase step variable
	step=$(($step+1))

	# Move the cat first
	if ! float_eq $old_cat_radius 1 && does_cat_see_mouse $old_cat_angle $old_cat_radius $old_mouse_angle; then
		# Move the cat in if it's not at the statue and it can see the mouse
		if float_lte $old_cat_radius 2; then
			new_cat_radius=1
		else
			new_cat_radius=$(bashcalc "$old_cat_radius - 1")
		fi
	else
		# Move the cat around if it's at the statue or it can't see the mouse
		angle_change=$(bashcalc "1.25/$old_cat_radius")
		new_cat_angle=$(bashcalc "$old_cat_angle+$angle_change")
		new_cat_angle=$(angle_reduce $new_cat_angle)
		# Check if the cat caught the mouse
		if float_eq $new_cat_radius 1 && angle_between $old_cat_angle $old_mouse_angle $new_cat_angle; then
			state=$CAUGHT
		fi
	fi
	# Now move the mouse if it wasn't caught
	if ((${state} == ${RUNNING})); then
		# Move the mouse
		new_mouse_angle=$(bashcalc "$old_mouse_angle+1" )
		new_mouse_angle=$(angle_reduce $new_mouse_angle)
		# Give up if we're at the last step and haven't caught the mouse
		if [ $step -eq $max_steps ]; then
			state=$GIVEUP
		fi
	fi

	echo ${state} ${step} ${new_cat_angle} ${new_cat_radius} ${new_mouse_angle} ${max_steps}
	return ${state}
}

# ### Main Script ###

# check if command arguments make sense
if [[ ${#} != 4 ]] ; then
	echo "$0: usage" >&2
	echo "$0 <cat angle> <cat radius> <mouse angle> <max steps>" >&2
	exit 1
fi

# Initial call to next_step
max_step_const=$4
temp_state=$(next_step $RUNNING 0 $1 $2 $3 $4)
echo $temp_state

while [ $(echo $temp_state | cut -d " " -f1) -eq $RUNNING ]
do
	# cut outputs to use as new inputs
	state_arg=$(echo $temp_state | cut -d " " -f1)
	step_arg=$(echo $temp_state | cut -d " " -f2)
	cat_angle_arg=$(echo $temp_state | cut -d " " -f3)
	cat_radius_arg=$(echo $temp_state | cut -d " " -f4)
	mouse_angle_arg=$(echo $temp_state | cut -d " " -f5)
	# max_step_arg=$(echo $temp_state | cut -d " " -f6)

	# make next call to function and echo
	temp_state=$(next_step $state_arg $step_arg $cat_angle_arg $cat_radius_arg $mouse_angle_arg $max_step_const)
	echo $temp_state
done


