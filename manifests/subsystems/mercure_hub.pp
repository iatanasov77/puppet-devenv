class vs_devenv::subsystems::mercure_hub (
    Hash $config                = {},
    String $systemd_unit_path   = '/etc/systemd/system',
    String $hostIp              = '0.0.0.0',
) {
    $mercure = $config['mercure']
    
    class { 'vs_devenv::subsystems::mercure::env_vars':
        mercure => $mercure,
    }

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
    
    file { 'mercure.conf':
        path    => "/etc/mercure.Caddyfile",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure.conf.erb' ),
        require => Package['mercure'],
    }
    
    file { 'mercure.service':
        path    => "${systemd_unit_path}/mercure.service",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure.service.erb' ),
        require     => [
            File['mercure.conf'],
            Class['vs_devenv::subsystems::mercure::env_vars']
        ],
        notify  => [
            Exec['daemon-reload'],
        ],
    }
    
    service { 'mercure':
        ensure      => running,
        enable      => true,
        provider    => systemd,
        timeout     => 3600,
        require     => File['mercure.service'],
    }
    
    class { 'vs_devenv::subsystems::mercure::apache_vhost':
        mercure => $mercure,
        hostIp  => $hostIp,
        require => Service['mercure'],
    }
}
