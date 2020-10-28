class vs_devenv::tomcat (
    String $catalinaHome    = '/opt/tomcat',
    String $sourceUrl,
    String $jdkPackage,
) {
    class { 'java' :
        package => $jdkPackage,
    } ->
    
    tomcat::install { "${catalinaHome}":
        source_url => $sourceUrl,
    }
    tomcat::instance { 'default':
        catalina_home => "${catalinaHome}",
    }
    
    -> tomcat::config::server::tomcat_users {
        'default-role-manager-script':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'role',
            element_name  => 'manager-script';
        'default-user-admin':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'user',
            element_name  => 'admin',
            password      => 'admin',
            roles         => ['standard', 'manager-script'];
    }
}