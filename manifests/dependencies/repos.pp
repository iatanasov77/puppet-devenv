class vs_devenv::dependencies::repos (
	Hash $dependencies	   = {},
	$repos                 = {},
	Boolean $forcePhp7Repo = true,
	String $phpVersion     = '7.2',
	String $mySqlProvider  = 'mysql'
) {

    $yumrepoDefaults = {
        'ensure'   => 'present',
        'enabled'  => true,
        'gpgcheck' => false,
        'priority' => 50,
    }
            
    case $::operatingsystem {
    	centos: {
            class { 'vs_devenv::dependencies::epel':
                yumrepoDefaults => $yumrepoDefaults,
            }
            
            class { 'vs_devenv::dependencies::remi':
            	remiReleaseRpm	=> "${dependencies['remiReleaseRpm']}",
                yumrepoDefaults => $yumrepoDefaults,
            }
            
		    if $::operatingsystemmajrelease == '7' {
		    	if ! defined( Package['yum-plugin-priorities'] ) {
		            Package { 'yum-plugin-priorities':
		                ensure => 'present',
		            }
		        }
		        
                if $mySqlProvider == 'mysql' {
                    include vs_devenv::dependencies::mysql_comunity_repo
                }
		    } elsif $::operatingsystemmajrelease == '8' {
		    	if ! defined( Package['dnf-plugins-core'] ) {
			    	Package { 'dnf-plugins-core':
				        ensure => present,
				    }
				}
				
				class { 'vs_devenv::dependencies::powertools':
                    yumrepoDefaults => $yumrepoDefaults,
                }
                
                #####################################################################
                # Workaroaund: Force enabling required repositories for CentOs 8
                #####################################################################
                Exec { "Force Enabling YumRepo PowerTools":
                    command => 'dnf config-manager --set-enabled powertools',
                    require => [
                        Class['vs_devenv::dependencies::epel'],
                        Class['vs_devenv::dependencies::remi'],
                        Class['vs_devenv::dependencies::powertools'],
                    ],
                }
		    } else {
		    	fail("CentOS support only tested on major version 7 or 8, you are running version '${::operatingsystemmajrelease}'")
		    }
		    
		    if ( $forcePhp7Repo ) {
			    class { 'vs_devenv::dependencies::php7':
			    	phpVersion		=> $phpVersion,
					yumrepoDefaults	=> $yumrepoDefaults,
			    }
			}
	    }
	}
}