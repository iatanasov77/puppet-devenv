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
    
    file { 'mercure.service':
        path    => "${systemd_unit_path}/mercure.service",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/binary.service.erb' ),
        require     => [
            File['mercure.conf'],
        ],
        notify  => [
            Exec['daemon-reload'],
        ],
    }
}