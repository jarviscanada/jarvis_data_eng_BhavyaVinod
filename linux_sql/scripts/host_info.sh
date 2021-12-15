#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

#Error message for missing arguments
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters. Please provide psql host, port number, database name, user and password"
    exit 1
fi

#parsing host hardware specifications
hostname=$(hostname -f)
lscpu_out=`lscpu`
cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | egrep "^Model:" | awk '{print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_out" | egrep "^CPU\sMHz:" | awk '{print $3}' | xargs)
l2_cache1=$(echo "$lscpu_out" | egrep "^L2\scache:" | awk '{print $3}' | xargs)
l2_cache=${l2_cache1//[^[:digit:].-]/}
total_mem=$(cat /proc/meminfo | egrep "MemTotal:" | awk '{print $2}' | xargs)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

#Query to insert data into host_info table
insert_stmnt="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp) VALUES('$hostname', $cpu_number, '$cpu_architecture', $cpu_model, $cpu_mhz, $l2_cache, $total_mem, '$timestamp');"

#Executing Insert statement through psql CLI tool
export PGPASSWORD=$psql_password
psql -h localhost -p 5432 -U postgres -d host_agent -c "$insert_stmnt"
exit 0
