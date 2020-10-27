class vs_devenv::tomcat (
    String $sourceUrl,
    String $jdkPackage,
) {
    class { 'java' :
        package => $jdkPackage,
    } ->
    
    tomcat::install { '/opt/tomcat':
        source_url => $sourceUrl,
    }
    tomcat::instance { 'default':
        catalina_home => '/opt/tomcat',
    }
}