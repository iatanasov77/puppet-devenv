class vs_devenv::subsystems::mercure::install::binary (
    Hash $config,
    String $systemd_unit_path,
    String $hostIp,
) {
    $mercure = $config['mercure']
    
    case $facts['os']['name'] {
        'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
            package { 'mercure':
                provider => 'rpm',
                source => "https://github.com/dunglas/mercure/releases/download/v${config['version']}/mercure_${config['version']}_linux_amd64.rpm",
            }
        }
        'Debian', 'Ubuntu': {
            package { 'mercure':
                provider => dpkg,
                source   => "https://github.com/dunglas/mercure/releases/download/v${config['version']}/mercure_${config['version']}_linux_amd64.deb",
            }
        }
        
        default: { fail( "Unsupported OS '${::operatingsystem}'" ) }
    }
    
    file { 'mercure_service_environement':
        path    => "/etc/mercure/mercure.env",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/service_env_vars.erb' ),
        require => File['mercure_config_dir'],
    }
    
    file { 'mercure_environement':
        ensure  => present,
        path    => "/etc/profile.d/mercure.sh",
        content => template( 'vs_devenv/mercure/env_vars.sh.erb' ),
        require     => [
            File['mercure.conf'],
        ],
    }
    
    file { 'mercure.service':
        path    => "${systemd_unit_path}/mercure.service",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/binary.service.erb' ),
        require     => [
            File['mercure_service_environement'],
            File['mercure_environement'],
        ],
        notify  => [
            Exec['daemon-reload'],
        ],
    }
    
    File { 'mercure_config_dir':
        path    => "/etc/mercure",
        ensure  => directory,
        mode    => '0755',
    }
    
    file { 'mercure.conf':
        path    => "/etc/mercure/mercure.Caddyfile",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/conf.erb' ),
        require => File['mercure_config_dir'],
    }
}