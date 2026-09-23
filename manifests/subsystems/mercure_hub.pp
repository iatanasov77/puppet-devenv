class vs_devenv::subsystems::mercure_hub (
    Hash $config                = {},
    String $systemd_unit_path   = '/etc/systemd/system',
    String $hostIp              = '0.0.0.0',
) {
    if ( $config['installType'] == 'binary' ) {
        class { 'vs_devenv::subsystems::mercure::install::binary':
            config              => $config,
            systemd_unit_path   => $systemd_unit_path,
            hostIp              => $hostIp,
        }
    } else {
        class { 'vs_devenv::subsystems::mercure::install::docker':
            config              => $config,
            systemd_unit_path   => $systemd_unit_path,
            hostIp              => $hostIp,
        }
    }
    
    service { 'mercure':
        ensure      => running,
        enable      => true,
        provider    => systemd,
        timeout     => 3600,
        require     => File['mercure.service'],
    }
    
    if ( $config['installType'] == 'binary' ) {
        class { 'vs_devenv::subsystems::mercure::apache_vhost':
            mercure => $mercure,
            hostIp  => $hostIp,
            require => Service['mercure'],
        }
    }
}
