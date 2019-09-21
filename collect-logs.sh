#!/bin/bash

# Script helper function
helpFunction()
{
   echo ""
   echo "Usage: $0 -uuid=YOURSITEUUID -env=YOURSITEENV"
   echo -e "\t-u Site UUID from Dashboard URL"
   echo -e "\t-e Environment name such as dev, test or live"
   exit 1 # Exit script after printing help
}

# Grab the parameters from the arguments
for i in "$@"
do
case $i in
    -u=*)
    SITE_UUID="${i#*=}"
    shift # past argument=value
    ;;
    -e=*)
    ENV_NAME="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
          # unknown option
    ;;
esac
done

# Print helpFunction in case parameters are empty
if [ -z "$SITE_UUID" ] && [ -z "$ENV_NAME" ] 
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Grab newrelic.log, nginx-access.log, nginx-error.log, php-fpm-error.log, php-slow.log
# and put them in an app_server directory where you execute this script
# and put them in an app_server directory where you execute this script
echo "Retrieving appserver logs...\n"
rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' $ENV_NAME.$SITE_UUID@appserver.$ENV_NAME.$SITE_UUID.drush.in:logs/* app_server_logs

# Grab the mysqld-slow-query.log, mysqld.log and put them in a 
# db_server directory
echo "Retrieving database server logs...\n"
rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' $ENV_NAME.$SITE_UUID@dbserver.$ENV_NAME.$SITE_UUID.drush.in:logs db_server_logs
