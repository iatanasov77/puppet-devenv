class vs_devenv::subsystems::elasticsearch (
    Hash $config    = {},
) {
    class { 'vs_core::elasticsearch':
        version     => $config['version'],
        yumRepo     => $config['yumRepo'],
        
        apiProtocol => "${config['scheme']}",
        apiHost     => "${config['host']}",
        apiPort     => $config['port'],
        apiUsername => "${config['user']}",
        apiPassword => "${config['pass']}",
    }
}
