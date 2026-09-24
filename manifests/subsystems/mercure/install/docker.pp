class vs_devenv::subsystems::mercure::install::docker (
    Hash $config,
    String $systemd_unit_path,
    String $hostIp,
) {
    $mercure = $config['mercure']
    
    file { "mercure_run.sh":
        ensure  => present,
        path    => "/usr/local/bin/mercure_run.sh",
        mode    => "0777",
        content => template( 'vs_devenv/mercure/docker_run.sh.erb' ),
    }
    
    file { 'mercure.service':
        path    => "${systemd_unit_path}/mercure.service",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/docker.service.erb' ),
        require => File['mercure_run.sh'],
        notify  => [
            Exec['daemon-reload'],
        ],
    }
}