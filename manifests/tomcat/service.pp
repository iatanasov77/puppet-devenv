define vs_devenv::tomcat::service (
    String $catalinaHome,
    String $tomcatUser      = 'root'
) {
    
    $scriptName = "${name}.sh"

    File { "${scriptName}":
        ensure  => file,
        path    => "/etc/init.d/${scriptName}",
        content => template( 'vs_devenv/tomcat.initd.erb' ),
        mode    => '0755',
    }
    
    -> File { "${name}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${name}.service",
        content => template( 'vs_devenv/tomcat.service.erb' ),
        mode    => '0755',
    }
    
    -> Service { "Start Service: ${name}":
        name    => "${name}",
        ensure  => 'running',
    }
    
}