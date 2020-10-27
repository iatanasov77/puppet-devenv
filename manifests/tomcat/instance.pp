define vs_devenv::tomcat::instance (
    String $name,
    String $catalinaHome,
    String $catalinaBase,
    Integer $serverPort     = 8005,
    Integer $connectorPort  = 8080,
) {

    tomcat::instance { "${name}":
        catalina_home => "${catalinaHome}",
        catalina_base => "${catalinaBase}",
    }
    
    tomcat::config::server { "${name}":
        catalina_base => "${catalinaBase}",
        port          => "${serverPort}",
    }
    
    tomcat::config::server::connector { "${name}-http":
        catalina_base         => "${catalinaBase}",
        port                  => "${connectorPort}",
        protocol              => 'HTTP/1.1',
        additional_attributes => {
            'redirectPort' => '8443'
        },
    }
    
}