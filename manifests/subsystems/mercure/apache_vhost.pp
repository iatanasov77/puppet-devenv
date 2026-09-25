define vs_devenv::subsystems::mercure::apache_vhost (
    Hash $mercure       = {},
    String $hostName    = 'localhost',
    String $hostIp      = '0.0.0.0',
) {
    $certKey    = $mercure['certKey']
    $certFile   = $mercure['certFile']
    
    file { "${hostName}.conf":
        path    => "/etc/httpd/conf.d/${hostName}.conf",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure/apache_vhost.erb' ),
        notify  => Service['httpd'],
    }
    
    # Create cache/log dir
    file { "/var/www/${hostName}":
        ensure => 'directory',
        owner  => 'apache',
        group  => 'root',
        mode   => '0777',
    }
}
