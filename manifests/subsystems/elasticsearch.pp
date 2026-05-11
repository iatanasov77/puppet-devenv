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
        
        apiConfig   => {
            'cluster.name'                  => 'VsElkCluster',
            'node.name'                     => "${config['apiHost']}",
            'network.host'                  => ["localhost", "${facts['host_ip']}"],
            'cluster.initial_master_nodes'  => ["${config['host']}"],
            
            'http.port'                     => $config['port'],
            'http.cors.allow-origin'        => "http://localhost:1358",
            'http.cors.enabled'             => true,
            'http.cors.allow-headers'       => 'X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization',
            'http.cors.allow-credentials'   => true,
        },
        
        indexes                             => $config['indexes'],
        guis                                => $config['guis'],
    }
}
