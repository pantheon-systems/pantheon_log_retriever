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
  if($opt_e eq 'live') {
    # Run a dig to obtain all the IP address of the live application containers
    print "Obtaining IP Address of appservers...\r\n";
    @app_dig = `dig +short appserver.live.$opt_u.drush.in`;
    # Begin retrieval of the log files on the live appservers
    print "Retrieving live appserver " . $opt_u . " logs...\r\n";
    foreach $app_server (@app_dig) {
      chomp $app_server;
      system('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222\' ' . $opt_e . '.' . $opt_u . '@appserver.' . $opt_e . '.' . $opt_u . '.drush.in:logs/* app_server_' . $app_server .'_logs');
      #print "Waiting for appserver rsync to finish...\r\n";
      #sleep(3);
    }
    print "Obtaining IP Address of dbservers...\r\n";
    @app_dig = `dig +short dbserver.live.$opt_u.drush.in`;
    print "Retrieving DB server logs...\r\n";
    foreach $app_server (@app_dig) {
      chomp $app_server;
      system('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222\' ' . $opt_e . '.' . $opt_u . '@dbserver.' . $opt_e . '.' . $opt_u . '.drush.in:logs/* db_server_' . $app_server .'_logs');
      #print "Waiting for dbserver rsync to finish...\r\n";
      #sleep(3);
    }
  } else {
    print "Retrieving appserver logs for " . $opt_e . "...\r\n";
    system('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222\' ' . $opt_e . '.' . $opt_u . '@appserver.' . $opt_e . '.' . $opt_u . '.drush.in:logs/* app_server_logs_' . $opt_e);
    print "Waiting for Appserver rsync to finish...\r\n";
    sleep(3);
    print "Retrieving DB server logs for " . $opt_e . "...\r\n";
    system('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222\' ' . $opt_e . '.' . $opt_u . '@dbserver.' . $opt_e . '.' . $opt_u . '.drush.in:logs/* db_server_logs_' . $opt_e);
  }
} else {
  print "Some or all of the parameters are empty\r\n";
  help();
}
