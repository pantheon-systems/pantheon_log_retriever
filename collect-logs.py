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
else:
  # Initiate rsync of application server logs
  # Open rsync subprocess and download the appserver logs
  print("Beginning rsync of Appserver logs...")
  app_process = subprocess.Popen("rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' " + args.env + "." + args.uuid + "@appserver." + args.env + "." + args.uuid + ".drush.in:logs/* app_server_logs", shell=True)
  app_process.wait()

  # Open rsync and retrieve the DB servers logs
  print("Beginning rsync of DBserver logs...")
  db_process = subprocess.Popen("rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' " + args.env + "." + args.uuid + "@dbserver." + args.env + "." + args.uuid + ".drush.in:logs/* db_server_logs", shell=True)
  db_process.wait()