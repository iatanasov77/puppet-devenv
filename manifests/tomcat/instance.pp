define vs_devenv::tomcat::instance (
    String $catalinaHome,
    String $catalinaBase,
    Integer $serverPort,
    Integer $connectorPort,
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
        
        #additional_attributes => {
        #    'redirectPort' => '8443'
        #},
    }
    
    -> vs_devenv::tomcat::service { "${name}":
        catalinaHome    => "${catalinaHome}",
    }
    
    -> tomcat::config::server::tomcat_users {
        'instance-role-admin-gui':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'role',
            element_name  => 'admin-gui';
        'instance-role-admin-script':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'role',
            element_name  => 'admin-script';
        'instance-role-manager-gui':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'role',
            element_name  => 'manager-gui';
        'instance-role-manager-script':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'role',
            element_name  => 'manager-script';
        'instance-user-admin':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'user',
            element_name  => 'admin',
            password      => 'admin',
            roles         => ['standard', 'admin-script', 'admin-gui', 'manager-script', 'manager-gui'];
    }
}