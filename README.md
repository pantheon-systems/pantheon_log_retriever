# Pantheon Log Retriever

[![Unsupported](https://img.shields.io/badge/Pantheon-Unsupported-yellow?logo=pantheon&color=FFDC28)](https://pantheon.io/docs/oss-support-levels#unsupported)

## Details ##
These scripts can be used to retrieve all of the application and database server log files in one execution. These scripts will create two local directories in the same directory from which the script was executed and place the logs in each corresponding directory.

- app_server_logs_ENV_NAME
- db_server_logs_ENV_NAME

When you specify "live" as your environment name, the scripts will retrieve the logs from each of your live application containers and place them into separate directories called:

- app_server_logs_IP_ADDRESS_OF_CONTAINER
- db_server_logs_IP_ADDRESS_OF_CONTAINER

The script takes 2 arguments.

- Site Plan UUID (retrievable from your site dashboard URL
- Environment name (dev, test, live or any multidev instance name)

#### Requirements: #### 

- Pantheon Site Plan
- Bash Shell or Perl or Python or PHP
- rsync

#### Usage ####

Bash Script execution

./collect-logs.sh -u=(YOURSITEUUID) -e=(DEV, TEST, LIVE or MD)

PHP Script execution

./collect-logs.php u=(YOURSITEUUID) e=(DEV, TEST, LIVE or MD NAME)

Perl Script Execution

./collect-logs.pl -u (YOURSITEUUID) -e (DEV, TEST, LIVE or MD)

Python Script Execution

./collect-logs.py --uuid (YOURSITEUUID) --env (DEV, TEST, LIVE or MD)
