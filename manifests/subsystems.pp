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
                if ( $subsystems['docker']['enabled'] ) {
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
                if ( $subsystems['dotnet']['enabled'] ) {
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
            
            'phpbrew':
            {
                if ( $subsys['enabled'] ) {
                    class { '::vs_devenv::phpbrew':
                        config	=> $subsys,
                        require	=> Class['vs_lamp::php'],
                    }
                }
            }
            
        }
    }
}
