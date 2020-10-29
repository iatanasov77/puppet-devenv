define vs_devenv::tomcat::service (
    String $catalinaHome,
    String $tomcatUser      = 'tomcat'
) {

    File { "${name}.sh":
        ensure  => file,
        path    => "/etc/init.d/${name}",
        content => template( 'vs_devenv/tomcat.service.erb' ),
        mode    => '0755',
    }
    
    /*
    
    -> Exec { "Tomcat Service":
        command => "/etc/init.d/${name} start",
    }
    
    File { "${name}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${name}.service",
        content => template( 'vs_devenv/tomcat.service.erb' ),
        mode    => '0755',
    }
    
    -> Service { "Start Service: ${name}":
        name    => "${name}",
        ensure  => 'running',
    }
    
    */
    
}