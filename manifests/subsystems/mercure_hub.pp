class vs_devenv::subsystems::mercure_hub (
    Hash $config                = {},
    String $systemd_unit_path   = '/etc/systemd/system',
    String $hostIp              = '0.0.0.0',
) {
    $mercure = $config['mercure']
    
    case $config['installType'] {
        'binary': {
            class { 'vs_devenv::subsystems::mercure::install::binary':
                config              => $config,
                systemd_unit_path   => $systemd_unit_path,
                hostIp              => $hostIp,
            }
            
            $requiredResources = [ File['mercure.service'], File['mercure.conf'] ]
        }
        
        'docker': {
            class { 'vs_devenv::subsystems::mercure::install::docker':
                config              => $config,
                systemd_unit_path   => $systemd_unit_path,
                hostIp              => $hostIp,
                require             => Class['docker'],
            }
            
            $requiredResources = [ File['mercure.service'] ]
        }
        
        'docker_compose': {
            class { 'vs_devenv::subsystems::mercure::install::docker_compose':
                config              => $config,
                systemd_unit_path   => $systemd_unit_path,
                hostIp              => $hostIp,
                require             => Class['docker'],
            }
            
            $requiredResources = [ File['mercure.service'] ]
        }
    }
    
    service { 'mercure':
        ensure      => running,
        enable      => true,
        provider    => systemd,
        timeout     => 3600,
        require     => $requiredResources,
    }
    
    vs_devenv::subsystems::mercure::apache_vhost{ "mercure_${mercure['host']}":
        mercure     => $mercure,
        hostName    => $mercure['host'],
        hostIp      => $hostIp,
        require     => Service['mercure'],
    }
    
    vs_devenv::system_host{ "${mercure['host']}":
        hostIp      => $hostIp,
        hostName    => $mercure['host'],
    }
    
    $mercure['siteHosts'].each |String $host| {
        vs_devenv::subsystems::mercure::apache_vhost{ "mercure_${host}":
            mercure     => $mercure,
            hostName    => "mercure-hub.${host}",
            hostIp      => $hostIp,
            require     => Service['mercure'],
        }
        
        vs_devenv::system_host{ "mercure-hub.${host}":
            hostIp      => $hostIp,
            hostName    => "mercure-hub.${host}",
        }
    }
}
