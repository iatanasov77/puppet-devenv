class vs_devenv::subsystems (
    Hash $subsystems    = {},
) {
	$subsystems.each |String $subsysKey, Hash $subsys| {
     
        case $subsysKey
        {
            'drush':
            {
            	if ( $subsys['enabled'] ) {
            		$drushVersions	= $subsys['versions'].map |$v| { String( $v ) }
                    class { '::vs_devenv::subsystems::drush':
                        versions   		=> $drushVersions,
                        defaultVersion	=> String( $subsys['defaultVersion'] ),
                    }
                }
            }
            
            'ruby':
            {
            	if ( $subsys['enabled'] ) {
            		stage { 'rvm-install': before => Stage['main'] }
                    class { '::vs_devenv::subsystems::ruby':
                    	config	=> $subsys,
                        stage	=> 'rvm-install',
                    }
                }
            }
            
            'mailcatcher':
            {
                if ( $subsys['enabled'] ) {
                    
                    if ( 'ruby' in $subsystems and $subsystems['ruby']['enabled'] ) {
                        $mailcatcherRequires    = []
                    } else {
                        class { 'vs_core::packages::ruby':
                            rubyVersion => $subsys['rubyDefaultVersion']
                        }
                        $mailcatcherRequires    = [Class['vs_core::packages::ruby']]
                    }
                    
                    class { "::vs_devenv::subsystems::mailcatcher":
                        config  => $subsys,
                        require => $mailcatcherRequires,
                    }
                }
            }
            
            default:
            {
                if ( $subsys['enabled'] ) {
                    class { "::vs_devenv::subsystems::${$subsysKey}":
                    	config	=> $subsys,
                        require	=> [
                        	Class['vs_lamp::php'], 
                        	Class['vs_lamp::apache']
                        ],
                    }
                }
      
            }
        }
    }
}
