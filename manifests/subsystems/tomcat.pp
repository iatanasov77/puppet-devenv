class vs_devenv::subsystems::tomcat (
	Hash $config    = {},
) {
	######################################################################
	# Reference: https://forge.puppet.com/modules/puppetlabs/tomcat
	######################################################################
	file { '/opt/tomcat':
        ensure => directory,
    } ->
	class { 'vs_devenv::tomcat::default' :
		jdkPackage		=> $config['jdkPackage'],
		sourceUrl		=> $config['sourceUrl'],
		catalinaHome	=> $config['catalinaHome'],
    }
    
    if $config['instances'] {
    	$config['instances'].each | String $instanceName, Hash $instanceConfig | {
    		tomcat::install { "${instanceConfig['catalinaHome']}":
		        source_url => $instanceConfig['sourceUrl'],
		    } ->
    		vs_devenv::tomcat::instance { "${instanceName}":
    			catalinaHome	=> $instanceConfig['catalinaHome'],
			    catalinaBase	=> $instanceConfig['catalinaHome'],
			    serverPort		=> $instanceConfig['serverPort'],
			    connectorPort	=> $instanceConfig['connectorPort'],
		    }
    	}
    }
}