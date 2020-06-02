<?php

// Parse arg values
if ($argv) {
  if(in_array('help', $argv) || !isset($argv[1])) {
    help();
    exit();
  } else {
    foreach ($argv as $arg) {
      $arg = explode("=", $arg);
      if ($arg[0] == "u") {
        $uuid = $arg[1];
      } elseif($arg[0] == "e") {
        $env = $arg[1];
      }
    }
    fetch_logs($uuid, $env);
  }
}

// Script helper function
function help() {
   print "\r\n";
   print "Usage: pantheon_log_retriever.php u=YOURSITEUUID e=YOURSITEENV\r\n";
   print "u Site UUID from Dashboard URL\r\n";
   print "e Environment name such as dev, test or live\r\n";
   print "\r\n";
   exit(); # Exit script after printing help
}

function fetch_logs($uuid, $env) {
  if(isset($uuid) && isset($env)) {
    if($env == 'live') {
      # Run a dig to obtain all the IP address of the live application containers
      print "Obtaining IP Aadresses of appservers...\r\n";
      $app_ips = array();
      $app_dig = shell_exec('dig +short appserver.live.' . $uuid . '.drush.in');
      $app_ips = array_filter(explode("\n", $app_dig));
      # Begin retrieval of the log files on the live appservers
      print "Retrieving live appserver " . $uuid ." logs...\r\n";
      foreach($app_ips as $app_server) {
        shell_exec('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222 -o "StrictHostKeyChecking no"\' ' . $env . '.' . $uuid . '@appserver.' . $env . '.' . $uuid . '.drush.in:logs/* app_server_' . $app_server .'_logs');
        print "Waiting for appserver " . $app_server . " rsync to finish...\r\n";
        sleep(3);
      }
      print "Obtaining IP Address of dbservers...\r\n";
      $db_ips = array();
      $db_dig = shell_exec('dig +short dbserver.live.' . $uuid . '.drush.in');
      $db_ips = array_filter(explode("\n", $db_dig));
      print "Retrieving DB server logs...\r\n";
      foreach($db_ips as $db_server) {
        shell_exec('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222 -o "StrictHostKeyChecking no"\' ' . $env . '.' . $uuid . '@dbserver.' . $env . '.' . $uuid . '.drush.in:logs/* db_server_' . $db_server .'_logs');
        print "Waiting for dbserver rsync to finish...\r\n";
        sleep(3);
      }
    } else {
      print "Retrieving appserver " . $env ." logs...\r\n";
      shell_exec('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222 -o "StrictHostKeyChecking no"\' ' . $env . '.' . $uuid . '@appserver.' . $env . '.' . $uuid . '.drush.in:logs/* app_server_' . $env .'_logs');
      print "Waiting for Appserver rsync to finish...\r\n";
      sleep(3);
      print "Retrieving DB server logs for " . $env . "...\r\n";
      shell_exec('rsync -rlvz --size-only --ipv4 --progress -e \'ssh -p 2222 -o "StrictHostKeyChecking no"\' ' . $env . '.' . $uuid . '@dbserver.' . $env . '.' . $uuid . '.drush.in:logs/* db_server_' . $env .'_logs');
    }
  } else {
    print "Some or all of the parameters are empty\r\n";
    help();
  }
}

?>
