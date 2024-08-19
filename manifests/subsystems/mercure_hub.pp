class vs_devenv::subsystems::mercure_hub (
    Hash $config    = {},
) {
    $mercure    = $config['mercure']
    
    ##############################################################################################
    # https://www.linode.com/docs/guides/how-to-install-and-configure-supervisor-on-centos-8/
    ##############################################################################################
    if ! defined( Package['supervisor'] ) {
        package { 'supervisor':
            ensure  => present,
        }
    } ->
    Service { 'supervisord':
        ensure  => 'running',
        enable  => true,
    }
    
    ############################################################################
    # https://codingstories.net/how-to/how-to-install-and-use-mercure/
    ############################################################################
    archive { "/tmp/mercure-legacy_Linux_x86_64.tar.gz":
        ensure          => present,
        source          => "https://github.com/dunglas/mercure/releases/download/v${config['version']}/mercure-legacy_Linux_x86_64.tar.gz",
        extract         => true,
        extract_path    => '/usr/local/bin',
        cleanup         => true,
        require         => [Package['supervisor']],
    }
    -> file { '/usr/local/bin/mercure':
        ensure  => 'present',
        mode    => '0777',
    } ->
    File { '/var/log/mercure':
        ensure  => directory,
    } ->
    File { '/etc/supervisord.d/mercure.ini':
        ensure  => file,
        path    => '/etc/supervisord.d/mercure.ini',
        content => template( 'vs_devenv/mercure.conf.erb' ),
        mode    => '0755',
        notify  => Service['supervisord'],
    }
}
