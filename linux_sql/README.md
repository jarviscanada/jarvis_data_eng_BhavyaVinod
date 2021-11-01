# Linux & SQL Project : Monitoring agent

### Introduction

###### This project contains a Linux server cluster monitoring tool. Cluster monitor agent is an internal tool that monitors the server cluster resources. It records the hardware specifications of each server and also monitors CPU and memory utilization in real time.


### Architecture and design

###### A primary server will host the central database. In this database, there are two tables : 
- ###### ``` host_usage ``` contains information the usage statistics on each cluster node
- ###### ``` host_info ``` contains the hardware information of each node
###### Monitoring agent scripts:
- ###### ``` host_usage.sh ``` : This script run via crontab and it records host's resource utilization information in the database.
- ###### ``` host_info.sh ```  : This script run only once and it records host's hardware specifications to the database.

### Quick start
- ###### Start a psql instance using ``` psql_docker.sh ```
  - ###### Start: ``` ./psql_docker.sh start [user password] ```
  - ###### Stop: ``` _psql_docker.sh stop ```
  
- ###### Set up the database ``` ddl.sql ``` by using this command
  - ###### ``` psql -h [hostname] -U [username] -p [port number] -c "ddl.sql" ```
 
- ###### ```host_info.sh ``` : Collects the server hardare information and store it in the database by using the command
  - ###### ```./host_info.sh [host name] [database name] [username] [user password] ```
  
- ###### ```host_usage.sh``` : Collects data about memory and CPU utilization
  - ###### ```./host_usage.sh [hostname] [database name] [username] [user password]```
  
- ###### ```crontab``` : We need to run the host_usage.sh script every 1 minute, in order to schedule that we can use crontab. In our terminal, we can use the command ```crontab -e ``` to edit the scheduled tasks. And then we can use the following code to execute ```host_usage.sh``` once in every minute.
  - ###### ``` * * * * * * bash [server's local pathway]/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log```
  
- ###### ```queries.sql``` : Data that is currently collected using Cluster monitoring agent, and we can execute it using the following command
  - ###### ```psql -h [hostname] -U [username] -p [port number] -c "queries.sql"```
  
### Improvements
- ###### By using ```crontab```, we added a script that automatically executes ```host_usage.sh``` every minute instead of a user/admin manually scheduling the updation.
- ###### Detect and handle the hardware changes
- ###### We created an automated script to connect to the psql instance


