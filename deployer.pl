#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use Deployer;

my ($action, $config, $user, $password, $application);
my $host = '127.0.0.1';

GetOptions(
    'action=s'      => \$action,
    'config:s'      => \$config,
    'user:s'        => \$user,
    'password:s'    => \$password,
    'host:s'        => \$host,
    'webapp:s'      => \$application,
) or pod2usage({-verbose=>99, -exitval=>1, });

$host .= ':8080' unless $host =~ /:/;
die "action required" unless $action;

my $deployer = Deployer->new(
    {
        config => $config,
        user => $user,
        password => $password,
        host => $host,
        application => $application,
    }
);

if ( $deployer->can($action) ) {
    $deployer->$action();
} else {
    die "Unknown action $action";
}

__END__

=head1 NAME

deployer.pl - tool to deploy/undeploy/start/stop/check Apache Tomcat application using the Tomcat Manager

=head1 SYNOPSIS

deployer.pl --config configfile --action deploy --webapp /path/to/webapp.war

deployer.pl --host 127.0.0.1:8080 --user tomcat --password topsecret --action start --webapp webapp.war

deployer.pl --host localhost --user tomcat --password topsecret --action stop --webapp webapp.war

    - tomcat application manipulation. User/password could be passed as option or read from appropriate host section.

deployer.pl --config configfile --host 127.0.0.1:8080 --user tomcat --password topsecret --action save

    - save user, password parameters to configfile section [127.0.0.1:8080]

deployer.pl --config configfile --host 127.0.0.1:8080 --action delete

    - delete section [127.0.0.1:8080] from configfile.

=head1 OPTIONS

=over 4

=item B<--action|-a>

MANDATORY; Action, one of:

=over

=item deploy

=item undeploy

=item start

=item stop

=item check

    - tomcat application manipulation, --webapp, --user, --password required as option or via config file.

=item save

=item delete

    - config file section manipulation, --config required.

=back

=item B<--config|-c>

Config file name.
User, password, application options per host could be defined here.

Default config section is [127.0.0.1:8080].

Config example:

=over

=item [my.app.server]

=item user = alice

=item password = 111

=item webapp = default_app.war

=back

=over

=item [127.0.0.1:8080]

=item user = tomcat

=item password = topsecret

=back

=item B<--host|-h>

Host[:port], default localhost:8080, default port 8080 if omitted.
If --config also passed, points to config section.

=item B<--user|-u>

User for Tomcat Manager, could be passed via config.

=item B<--passwd|-p>

Password for Tomcat Manager user, could be passed via config.

=item B<--webapp|-w>

Tomcat application, could be passed via config.

=back

=cut

