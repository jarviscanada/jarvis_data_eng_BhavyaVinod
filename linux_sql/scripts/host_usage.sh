#!/bin/bash

psql_host=$1
psql_port=$2
database=$3
psql_user=$4
psql_password=$5

#Error message for missing arguments
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters. Please provide psql host, port number, database name, user and password"
    exit 1
fi

hostname=$(hostname -f)
memory_free=$(vmstat --unit M |awk '{for(i=NF;i>0;i--)if($i=="free"){x=i;break}}END{print $x}' | xargs)
cpu_idle=$(vmstat --unit M |awk '{for(i=NF;i>0;i--)if($i=="id"){x=i;break}}END{print $x}' | xargs)
cpu_kernel=$(vmstat --unit M |awk '{for(i=NF;i>0;i--)if($i=="sy"){x=i;break}}END{print $x}' | xargs)
disk_io=$(vmstat -d |awk '{for(i=NF;i>0;i--)if($i=="cur"){x=i+1;break}}END{print $x}' | xargs)
disk_available1=$(df -BM / |awk '{for(i=NF;i>0;i--)if($i=="Available"){x=i;break}}END{print $x}' | xargs)
disk_available=${disk_available1//[^[:digit:].-]/}
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

#Query to insert data into host_usage table

insert_stmnt="INSERT INTO host_usage(timestamp,host_id,memory_free,cpu_idle,cpu_kernel,disk_io,disk_available) VALUES('$timestamp',(SELECT id FROM host_info WHERE hostname='$hostname'),$memory_free,$cpu_idle,$cpu_kernel,$disk_io,$disk_available);"

#Executing Insert statement through psql CLI tool
export PGPASSWORD=$psql_password
psql -h localhost -p 5432 -U postgres -d host_agent -c "$insert_stmnt"
exit 0




































































