#!/bin/bash

psql_host=$1
psql_port=$2
database_name=$3
psql_user=$4
psql_password=$5

# Checking for parameters
if [ "$#" -ne 5 ];
then
  echo "Incorrect number of parameters provided."
fi

# Saving host name to a variable.
hostname=$(hostname -f)

# Linux information.
lscpu_output=`lscpu`
#meminfo=`cat /proc/meminfo`

# Saving hardware details into new variables
cpu_number=$(echo "$lscpu_output" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_output" | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_output" | egrep "Model name" | awk '{print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_output" | egrep "^CPU MHz:" | awk -F':' '{print $2}' | xargs)
l2_cache=$(echo "$lscpu_output" | egrep "^L2 cache:" | awk '{print $3}' | xargs)
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2 $3}'| xargs)
timestamp=$(vmstat -t | awk '{if(NR==3) print $18" "$19}' | xargs)

insert_stmt="INSERT INTO host_info
	 (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp)
	 VALUES ('"$hostname"', '"$cpu_number"', '"$cpu_architecture"', '"$cpu_model"', '"$cpu_mhz"', '"$l2_cache"', '"$total_mem"', '"$timestamp"');"

export PGPASSWORD=$psql_password
psql -h $hostname -U $psql_user -w $database_name -p $psql_port -c "$insert_stmt"
exit 0 
