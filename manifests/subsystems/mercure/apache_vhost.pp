class vs_devenv::subsystems::mercure::apache_vhost (
    Hash $mercure   = {},
    String $hostIp  = '0.0.0.0',
) {
    $certKey    = $mercure['certKey']
    $certFile   = $mercure['certFile']
    
    /*  
    $certKey    = "/etc/pki/tls/private/${mercure['host']}.key"
    $certFile   = "/etc/pki/tls/certs/${mercure['host']}.crt"
    
    vs_lamp::create_ssl_certificate{ "CreateSelfSignedCertificate_${mercure['host']}":
        hostName    => $mercure['host'],
        sslHost     => $mercure['host'],
    }
	*/
	
	file { "${mercure['host']}.conf":
        path    => "/etc/httpd/conf.d/${mercure['host']}.conf",
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template( 'vs_devenv/mercure.apache.erb' ),
        notify  => Service['httpd'],
    }
    
    # Create cache/log dir
    file { "/var/www/${mercure['host']}":
        ensure => 'directory',
        owner  => 'apache',
        group  => 'root',
        mode   => '0777',
    }
    
    vs_devenv::system_host{ "${mercure['host']}":
        hostIp      => $hostIp,
        hostName    => $mercure['host'],
    }
}
