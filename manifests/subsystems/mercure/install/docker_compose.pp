class vs_devenv::subsystems::mercure::install::docker_compose (
    Hash $config,
    String $systemd_unit_path,
    String $hostIp,
) {
    $mercure = $config['mercure']
    $mercureDirectory = '/opt/mercure'
    
    File { 'mercure_opt_dir':
        path    => "${mercureDirectory}",
        ensure  => directory,
        mode    => '0755',
    }
    
    File { 'mercure_docker_compose_conf':
        path    => "${mercureDirectory}/mercure.Caddyfile",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/caddyfile.erb' ),
        require => File['mercure_opt_dir'],
    }
    
    File { 'mercure_docker_compose_mercure_json':
        path    => "${mercureDirectory}/mercure.json",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/mercure.json.erb' ),
        require => File['mercure_opt_dir'],
    }
    
    File { 'mercure_docker_compose':
        path    => "${mercureDirectory}/docker-compose.yml",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/docker-compose.yml.erb' ),
        require => File['mercure_opt_dir'],
    }
    
    docker_compose { 'docker_compose_mercure':
        ensure          => present,
        
        compose_files   => ["${mercureDirectory}/docker-compose.yml"],
        #up_args         => '-it',
        
        require         => [
            Class['vs_devenv::subsystems::docker'],
            Class['vs_devenv::subsystems::app_monitoring'],
            File['mercure_docker_compose'],
        ],
    }
    
    File { 'mercure.service':
        path    => "${systemd_unit_path}/mercure.service",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/docker_compose.service.erb' ),
        require => Docker_compose['docker_compose_mercure'],
        notify  => [
            Exec['daemon-reload'],
        ],
    }
}