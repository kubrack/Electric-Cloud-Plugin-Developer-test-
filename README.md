# Electric-Cloud-Plugin-Developer-test-
Electric Cloud Plugin Developer test 

Name:
    deployer.pl - tool to deploy/undeploy/start/stop/check Apache Tomcat
    application using the Tomcat Manager

Usage:
    deployer.pl --config configfile --action deploy --webapp
    /path/to/webapp.war

    deployer.pl --host 127.0.0.1:8080 --user tomcat --password topsecret
    --action start --webapp webapp.war

    deployer.pl --host localhost --user tomcat --password topsecret --action
    stop --webapp webapp.war

        - tomcat application manipulation. User/password could be passed as option or read from appropriate host section.

    deployer.pl --config configfile --host 127.0.0.1:8080 --user tomcat
    --password topsecret --action save

        - save user, password parameters to configfile section [127.0.0.1:8080]

    deployer.pl --config configfile --host 127.0.0.1:8080 --action delete

        - delete section [127.0.0.1:8080] from configfile.

Options:
    --action|-a
        MANDATORY; Action, one of:

        deploy
        undeploy
        start
        stop
        check
                - tomcat application manipulation, --webapp, --user, --password required as option or via config file.

        save
        delete
                - config file section manipulation, --config required.

    --config|-c
        Config file name. User, password, application options per host could
        be defined here.

        Default config section is [127.0.0.1:8080].

        Config example:

        [my.app.server]
        user = alice
        password = 111
        webapp = default_app.war

        [127.0.0.1:8080]
        user = tomcat
        password = topsecret

    --host|-h
        Host[:port], default localhost:8080, default port 8080 if omitted.
        If --config also passed, points to config section.

    --user|-u
        User for Tomcat Manager, could be passed via config.

    --passwd|-p
        Password for Tomcat Manager user, could be passed via config.

    --webapp|-w
        Tomcat application, could be passed via config.


