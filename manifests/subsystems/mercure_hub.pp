class vs_devenv::subsystems::mercure_hub (
    Hash $config                = {},
    String $systemd_unit_path   = '/etc/systemd/system',
) {
    $mercure        = $config['mercure']
    $mercureSource  = "https://github.com/dunglas/mercure/releases/download/v${config['version']}/mercure_Linux_x86_64.tar.gz"
    
    File { '/usr/local/bin/mercure':
        ensure  => directory,
    } ->
    File { '/var/log/mercure':
        ensure  => directory,
    } ->
    archive { "/tmp/mercure_Linux_x86_64.tar.gz":
        ensure          => present,
        source          => $mercureSource,
        extract         => true,
        extract_path    => '/usr/local/bin/mercure',
        cleanup         => true,
    }
    -> file { '/usr/local/bin/mercure/mercure':
        ensure  => 'present',
        mode    => '0777',
    } ->
    file { 'mercure.conf':
        path    => "/usr/local/bin/mercure/mercure.Caddyfile",
        owner   => root,
        group   => root,
        mode    => '0444',
        content => template( 'vs_devenv/mercure.conf.erb' ),
    } ->
    file { 'mercure.service':
        path    => "${systemd_unit_path}/mercure.service",
        owner   => root,
        group   => root,
        mode    => '0444',
        content => template( 'vs_devenv/mercure.service.erb' ),
        notify  => [
            Exec['daemon-reload'],
            Service['mercure'],
        ],
    }
    
    service { 'mercure':
        ensure      => running,
        enable      => true,
        provider    => systemd,
        timeout     => 3600,
        require     => File['mercure.service'],
    }
}
