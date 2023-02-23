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
