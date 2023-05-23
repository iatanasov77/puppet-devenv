class vs_devenv::tomcat::default (
	String $sourceUrl,
	String $catalinaHome,
	Optional[String] $jdkPackage,
) {
	if ! defined(Class['java']) and ! empty($jdkPackage) {
	    class { 'java' :
	        package => $jdkPackage,
	    }
	}
    
    tomcat::install { "${catalinaHome}":
        source_url => $sourceUrl,
    }
    tomcat::instance { 'default':
        catalina_home => "${catalinaHome}",
    }
    
    -> vs_devenv::tomcat::service { "tomcat":
        catalinaHome    => "${catalinaHome}",
    }
    
    -> tomcat::config::server::tomcat_users {
        'default-role-admin-gui':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'role',
            element_name  => 'admin-gui';
        'default-role-admin-script':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'role',
            element_name  => 'admin-script';
        'default-role-manager-gui':
            ensure        => present,
            catalina_base => "${catalinaHome}",
            element       => 'role',
            element_name  => 'manager-gui';
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
            roles         => ['standard', 'admin-script', 'admin-gui', 'manager-script', 'manager-gui'];
    }
}