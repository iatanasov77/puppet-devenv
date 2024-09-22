class vs_devenv::subsystems::websocket_server (
    Hash $config    = {},
) {
    if ! defined( Package['iperf3'] ) {
        package { 'iperf3':
            ensure  => present,
        }
    } ->
    File { '/var/log/websocket':
        ensure  => directory,
    } ->
    user { 'wsworker':
        ensure  => present,
        shell   => '/sbin/nologin',
    }
    
    $config['servers'].each |String $serverKey, Hash $server| {
        File { "/etc/systemd/system/websocket_${serverKey}.service":
            ensure  => file,
            path    => "/etc/systemd/system/websocket_${serverKey}.service",
            content => template( 'vs_devenv/websocket.service.erb' ),
            mode    => '0644',
        } ->
        Service { "websocket_${serverKey}":
            ensure  => 'running',
            enable  => true,
            require => [User['wsworker']]
        }
    }
}
