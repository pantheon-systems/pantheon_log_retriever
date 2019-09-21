#!/usr/bin/perl

use Getopt::Std;

getopt("ue");

# Script helper function
sub help() {
   print "\r\n";
   print "Usage: $0 -u YOURSITEUUID -e YOURSITEENV\r\n";
   print "-u Site UUID from Dashboard URL\r\n";
   print "-e Environment name such as dev, test or live\r\n";
   print "\r\n";
   exit 0; # Exit script after printing help
}

if(defined $opt_u && defined $opt_e) {  # double check existence
  print "Retrieving appserver logs...\r\n";
  system('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222\' ' . $opt_e . '.' . $opt_u . '@appserver.' . $opt_e . '.' . $opt_u . '.drush.in:logs/* app_server_logs');
  print "Waiting for Appserver rsync to finish...\r\n";
  sleep(15);
  print "Retrieving DB server logs...\r\n";
  system('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222\' ' . $opt_e . '.' . $opt_u . '@dbserver.' . $opt_e . '.' . $opt_u . '.drush.in:logs/* db_server_logs');
} else {
  print "Some or all of the parameters are empty\r\n";
  help();
}
