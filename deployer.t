#!/usr/bin/env perl

use strict;
use warnings;

use File::Temp qw(tempfile);
use Test::More tests => 1 + 3 + 5 + 1;

require_ok "Deployer";

ok(system("./deployer.pl >/dev/null") != 0, "--action required");
ok(system("./deployer.pl -a save >/dev/null") != 0, "--config required");
ok(system("./deployer.pl -a delete >/dev/null") != 0, "--config required");

ok(system("./deployer.pl -a deploy >/dev/null") != 0, "--application required");
ok(system("./deployer.pl -a undeploy >/dev/null") != 0, "--application required");
ok(system("./deployer.pl -a start >/dev/null") != 0, "--application required");
ok(system("./deployer.pl -a stop >/dev/null") != 0, "--application required");
ok(system("./deployer.pl -a check >/dev/null") != 0, "--application required");

my ($fh, $filename) = tempfile();
ok(system("./deployer.pl -a save -c $filename -u tomcat -p topsecret>/dev/null") == 0, "save config");
system("cat $filename");
