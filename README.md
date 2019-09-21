# Pantheon Log Retriever

## Details ##
This script can be used to retrieve all of the application and database server log files in one execution. The script will create two local directories in the same directory from which the script was executed and place the logs in each corresponding directory.

- app_server_IPADDRESS
- db_server_IPADDRESS

The script takes 2 arguments.

- Site Plan UUID (retrievable from your site dashboard URL
- Environment name (dev, test, live or any multidev instance name)

#### Requirements: #### 

- Pantheon Site Plan
- Bash Shell
- sftp

#### Usage ####

./collect-logs.sh -uuid=(YOURSITEUUID) -env=(DEV, TEST, LIVE or MD)
