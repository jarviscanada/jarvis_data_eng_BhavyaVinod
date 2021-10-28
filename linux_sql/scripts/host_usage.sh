#!/bin/bash

#setting arguments

psql_host=$1
psql_port=$2
database=$3
psql_user=$4
psql_password=$5

hostname=$(hostname -f)

# Linux info

lscpu_output=`lscpu`
meminfo=`cat /proc/meminfo`
vmstat=`vmstat -a -S M`
disk=`df -BM /`

timestamp=$(vmstat -t | awk '{if(NR==3) print $18" "$19}' | xargs)

# CPU utilization info

memory_free=$(echo "$vmstat" | awk '{if(NR==3) print $4}' | xargs)
cpu_idle=$(echo "$disk" | awk '{if(NR==2) print 100-$5}' | xargs)
cpu_kernel=$(echo "$meminfo" | egrep "^KernelStack:" | awk '{print $2}' | xargs)
disk_io=$(vmstat --unit M | awk '{if(NR==3) print $9}' | xargs)
disk_available=$(echo "$disk" | awk '{if(NR==3) print $4}' | xargs)

export PGPASSWORD='$psql_password' psql -h $hostname -U $psql_user -w $database_name -p $psql_port -c \
        "INSERT INTO host_usage
         (hostname, timestamp, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) 
         VALUES ('"$hostname"',timestamp, $memory_free, $cpu_idle,$cpu_kernel, $disk_io, $disk_available);"

exit 0







































































