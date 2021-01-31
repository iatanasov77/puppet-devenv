class vs_devenv::subsystems (
    Hash $subsystems    = {},
) {
    $subsystems.each |String $subsysKey, Hash $subsys| {
     
        case $subsysKey
        {
        	'vault':
        	{
        		class { 'hashicorp::vault': 
        			version	=> $subsys['version']
        		}
        		/*
        		archive { '/tmp/Vault.zip':
					ensure        	=> present,
					source        	=> "$subsys['sourceUrl']",
					extract       	=> true,
					extract_path  	=> '/usr/local/bin',
					cleanup       	=> true,
				}
				*/
        	}
            'docker':
            {
                if ( $subsys['enabled'] ) {
                	# vs_devenv::subsystems::docker
                    class { 'docker':
                        ensure => present,
                        version => 'latest',
                    }
                    
                    class {'docker::compose':
                        ensure => present,
                        #version => '1.9.0',
                    }
                }
            }
            
            'dotnet':
            {
                if ( $subsys['enabled'] ) {
                    class { '::vs_dotnet':
                        sdkVersion  => $subsys['dotnet_core'],
                        sdkUser     => $subsys['sdkUser'],
                        sdks        => $subsys['sdks'],
                        mono        => ( $subsys['mono'] == Undef ),
                    }
                }
            }
            
            'tomcat':
            {
                if ( $subsys['enabled'] ) {
                    class { '::vs_devenv::tomcat':
                        sourceUrl   => $subsys['sourceUrl'],
                        jdkPackage  => $subsys['jdkPackage'],
                    }
                }
            }
            
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
