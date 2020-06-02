#!/usr/bin/env python

import os
import shutil
import time
import subprocess
import sys
import re
import argparse

# Arguments parsing
parser = argparse.ArgumentParser()
parser.add_argument("--uuid", help="UUID of your Pantheon Site Account")
parser.add_argument("--env", help="Environment name (dev, test, live or multidev")
args = "none";
args = parser.parse_args()

# Check and see if UUID and ENV args were passed
if ((not args.uuid) or (not args.env)):
  parser.print_help()
  # parser.print_usage() # for just the usage line
  parser.exit()
elif ( args.env == 'live'):
  print("Beginning rsync of Live appserver logs...")
  app_ipaddys = subprocess.Popen("dig +short appserver.live." + args.uuid + ".drush.in", shell=True, stdout=subprocess.PIPE)
  app_ips = app_ipaddys.communicate()[0]
  app_ips = app_ips.rstrip()
  app_ips = app_ips.split('\n')
  for ip in app_ips:
    app_process = subprocess.Popen("rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222 -o \"StrictHostKeyChecking no\"' " + args.env + "." + args.uuid + "@appserver." + args.env + "." + args.uuid + ".drush.in:logs/* app_server_logs_" + ip, shell=True)
    app_process.wait()
  print("Beginning rsync of Live dbserver logs...")
  app_ipaddys = subprocess.Popen("dig +short dbserver.live." + args.uuid + ".drush.in", shell=True, stdout=subprocess.PIPE)
  app_ips = app_ipaddys.communicate()[0]
  app_ips = app_ips.rstrip()
  app_ips = app_ips.split('\n')
  for ip in app_ips:
    app_process = subprocess.Popen("rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222 -o \"StrictHostKeyChecking no\"' " + args.env + "." + args.uuid + "@dbserver." + args.env + "." + args.uuid + ".drush.in:logs/* db_server_logs_" + ip, shell=True)
    app_process.wait()
else:
  # Initiate rsync of application server logs
  # Open rsync subprocess and download the appserver logs
  print("Beginning rsync of " + args.env + " appserver logs...")
  app_process = subprocess.Popen("rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222 -o \"StrictHostKeyChecking no\"' " + args.env + "." + args.uuid + "@appserver." + args.env + "." + args.uuid + ".drush.in:logs/* app_server_logs", shell=True)
  app_process.wait()

  # Open rsync and retrieve the DB servers logs
  print("Beginning rsync of " + args.env + " DB server logs...")
  db_process = subprocess.Popen("rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222 -o \"StrictHostKeyChecking no\"' " + args.env + "." + args.uuid + "@dbserver." + args.env + "." + args.uuid + ".drush.in:logs/* db_server_logs", shell=True)
  db_process.wait()