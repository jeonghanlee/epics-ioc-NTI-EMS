#!/usr/bin/env bash
#
#  Copyright (c) 2016 - 2020    Jeong Han Lee
#  Copyright (c) 2016 - 2019    European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Monday, April 20 16:40:43 PDT 2020
# version : 1.0.7

declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME=${0##*/}
declare -gr SC_TOP="${SC_SCRIPT%/*}"

declare -a pvlist=();

function usage
{
    {
	echo "";
	echo "Usage    : $0 [-l pvlist_file] [-w watch_interval_sec] [-f <filter_string>] [-c] [-7] "
	echo "";
	echo "               -l : pvlist file generated by dbl output or hand"
	echo "               -w : watch interval sec"
	echo "               -f : without arg, select all"
	echo "               -c : disable existent EPICS CA ADDR environment"
	echo "               -7 : use pvget instead of caget"
	echo "";
	echo " bash $0 -l pvlist_file"
	echo " bash $0 -l pvlist_file -f \"RB\" "
	echo " bash $0 -l pvlist_file -w 5 "
	echo ""
	
    } 1>&2;
    exit 1; 
}


function print_ca_addr
{
    local msg="$1"
    printf ">> %s : EPICS CA ADDR Info ... \n" "$msg"
    echo "   EPICS_CA_ADDR_LIST      : $EPICS_CA_ADDR_LIST"
    echo "   EPICS_CA_AUTO_ADDR_LIST : $EPICS_CA_AUTO_ADDR_LIST"
}


function unset_ca_addr
{
#    printf ">> Unset ... EPICS CA ADDR Info\n"
    unset EPICS_CA_ADDR_LIST
    unset EPICS_CA_AUTO_ADDR_LIST
}

function set_ca_addr
{
#    printf ">> Set   ... EPICS CA ADDR Info \n";
    export EPICS_CA_ADDR_LIST="$1"
    export EPICS_CA_AUTO_ADDR_LIST="$2";
 }


function reset_ca_addr
{
    local auto_addr="$1"; shift;
    printf ">> Reset EPICS CA ADDR ..... \n";
    print_ca_addr "Before Reset"
    _HOST_IP="$(ip -4 route get 8.8.8.8 | awk {'print $7'} | tr -d '\n')";
    unset_ca_addr 
    set_ca_addr "$_HOST_IP" "$auto_addr"
    print_ca_addr "After  Reset"
}


function pvs_from_list
{
    local i=0;
    local j=0;
    local pv;
    local filename="$1"
    local filter="$2"
    local raw_pvlist=();
    local temp_pvlist=();
    let i=0
    while IFS= read -r line_data; do
	if [ "$line_data" ]; then
	    [[ "$line_data" =~ ^#.*$ ]] && continue
	    raw_pvlist[i]="${line_data}"
	    ((++i))
	fi
    done < "${filename}"

    # https://stackoverflow.com/questions/7442417/how-to-sort-an-array-in-bash
    IFS=$'\n' read -d '' -r -a temp_pvlist < <(printf '%s\n' "${raw_pvlist[@]}" | sort)

    if [ -z "$filter" ]; then
	let i=0;
	for pv in ${temp_pvlist[@]}; do
	    pvlist[i]="$pv"
	    ((++i))
	done
    else
	let j=0
	for pv in ${temp_pvlist[@]}; do
	    if test "${pv#*$filter}" != "$pv"; then
		pvlist[j]="$pv"
		((++j))
	    fi
	done
    fi
    
}

function getValue_pvlist
{
    local pv;
    local sleep_interval=.001
    printf "\n>> Selected PV and its value with %s\n" "${GET_CMD}"
    if hash ${GET_CMD} 2>/dev/null ; then
	for pv in ${pvlist[@]}; do
	    ${GET_CMD} "$pv"
	    sleep ${sleep_interval}
	done
    else
	printf "\n>>>> We cannot run $0\n";
	printf "     because we cannot find $GET_CMD in the system\n"
	printf "     please source setE3Env.bash first\n"
	printf "\n"
	exit;
    fi
    printf "\n";
}

# l:, arg is mandatory
# c , arg is optional

options="l:w:f:cn7"
RESETCA="NO"
AUTO_ADDR=""
GET_CMD="caget"
WATCH=""
LIST=""
SUBSTRING=""
AUTO_ADDR="YES"

while getopts "${options}" opt; do
    case "${opt}" in
        l) LIST=${OPTARG}      ;;
	w) WATCH=${OPTARG}     ;;
	f) SUBSTRING=${OPTARG} ;;
 	c) RESETCA="YES"       ;;
	n) AUTO_ADDR="NO"  ;;
	7) GET_CMD="pvget"     ;;
   	:)
	    echo "Option -$OPTARG requires an argument." >&2
	    usage
	    ;;
	h)
	    usage
	    ;;
	\?)
	    echo "Invalid option: -$OPTARG" >&2
	    usage
	    ;;
    esac
done
shift $((OPTIND-1))


if [ -z "$LIST" ]; then
    usage;
fi


if [ "$RESETCA" == "YES" ]; then
    
    reset_ca_addr "${AUTO_ADDR}";
    sleep 2;
    clear;
fi

pvs_from_list "${LIST}" "${SUBSTRING}"

if [ -z "$WATCH" ]; then
    getValue_pvlist
else
    # This is the fake watch
    offset=0.1
    interval=$(echo "${WATCH}-${offset}" | bc)
    while true; do
	LOG_DATE=$(date)
	GET_LIST=$(getValue_pvlist)
	clear;
	printf "Fake watch with the sleep interval %s (The offset %s is introduced). \n" "${interval}" "${offset}"
	printf "%s\n" "$LOG_DATE";
	printf "$GET_LIST\n";
	sleep ${interval}
    done;
    
fi
