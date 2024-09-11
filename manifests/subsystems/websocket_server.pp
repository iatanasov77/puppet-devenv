class vs_devenv::subsystems::websocket_server (
    Hash $config    = {},
) {
    if ! defined( Package['iperf3'] ) {
        package { 'iperf3':
            ensure  => present,
        }
    } ->
    user { 'wsworker':
        ensure  => present,
        shell   => '/sbin/nologin',
    } ->
    File { '/etc/systemd/system/websocket.service':
        ensure  => file,
        path    => '/etc/systemd/system/websocket.service',
        content => template( 'vs_devenv/websocket.service.erb' ),
        mode    => '0644',
    } ->
    Service { 'websocket':
        ensure  => 'running',
        enable  => true,
    }
}
