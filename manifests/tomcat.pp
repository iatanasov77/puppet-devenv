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
}