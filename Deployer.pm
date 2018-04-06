package Deployer;

use strict;
use warnings;

use Config::IniFiles;
use HTTP::Request;
use File::Slurp qw(read_file);
use LWP::UserAgent;

use fields qw(action config user password application host _ua);

sub new {
    my $class = shift;
    my $args = shift;

    if (my $conf_file = $args->{config}) {

        die "Non-writable config '$conf_file'" unless -w $conf_file;

        $args->{config} = Config::IniFiles->new(
            -file => $conf_file,
            -default => $args->{host},
            -allowempty => 1,
        );

        die "Wrong config file '$conf_file': ". join("\n", @Config::IniFiles::errors)
            unless $args->{config};

        for my $val (qw/user password application/) {
            $args->{$val} //= $args->{config}->val($args->{host}, $val);
        }
    }

    my $self = bless $args, $class;
}

sub save {
    my $self = shift;

    my $config = $self->{config};
    my $host = $self->{host};

    die "'config' option required" unless $config;

    $config->AddSection($host);
    for my $val (qw/user password application/) {
        $config->newval($host, $val, $self->{$val}) if defined $self->{$val};
    }
    $config->RewriteConfig();
}

sub delete {
    my $self = shift;
    my $config = $self->{config};

    die "'config' option required" unless $config;

    $config->DeleteSection($self->{host});
    $config->RewriteConfig();
}

sub _ua {
    my $self = shift;
    return $self->{_ua} if $self->{_ua};

    my $ua = LWP::UserAgent->new() or die "User agent: $!";
    $ua->credentials( $self->{host}, "Tomcat Manager Application", $self->{user}, $self->{password});
    $self->{_ua} = $ua;
}

sub _req {
    my $self = shift;

    my $req = HTTP::Request->new(@_);
    my $res = $self->_ua()->request($req);

    die $res->status_line() unless $res->is_success();
    return $res;
}

sub _app_place {
    my $self = shift;

    die "application required" unless defined $self->{application};
    ( $self->{application} =~ /.*\/(\S+)/ ) ? $1 : $self->{application};
}

sub list {
    my $self = shift;
    print $self->_req(GET => "http://$self->{host}/manager/text/list")->content();
}

sub deploy {
    my $self = shift;

    my $app_place = $self->_app_place();
    my $app_bytes = read_file($self->{application});
    my $uri = "http://$self->{host}/manager/text/deploy?path=/$app_place";
    print $self->_req(PUT => $uri, undef, $app_bytes)->content();
}

sub undeploy {
    my $self = shift;

    my $app_place = $self->_app_place();
    my $uri = "http://$self->{host}/manager/text/undeploy?path=/$app_place";
    print $self->_req(GET => $uri)->content();
}

sub start {
    my $self = shift;

    my $app_place = $self->_app_place();
    my $uri = "http://$self->{host}/manager/text/start?path=/$app_place";
    print $self->_req(GET => $uri)->content();
}

sub stop {
    my $self = shift;

    my $app_place = $self->_app_place();
    my $uri = "http://$self->{host}/manager/text/stop?path=/$app_place";
    print $self->_req(GET => $uri)->content();
}

sub check {
    my $self = shift;
    my $app_place = $self->_app_place();

    my $uri = "http://$self->{host}/$app_place";
    print("Application $uri responded\n") if $self->_req(GET => $uri);
}

1;
