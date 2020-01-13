class devenv::dependencies
{
	#if defined( $vsConfig['dependencies'] ) and defined( $vsConfig['dependencies']["${operatingsystem}"] ) {
		$unknown_type = "Unknown dependency type"
		
		$vsConfig['dependencies']["${operatingsystem}"].each |String $name, Hash $config| {
			case $config['type']
	        {
	        	'yumrepo':
	        	{
	        		yumrepo { "${name}":
					    descr      => 'Remi\'s RPM repository for Enterprise Linux $releasever - $basearch',
					    #mirrorlist => "https://rpms.remirepo.net/enterprise/${releasever}/remi/mirror",
					    baseurl		=> "${config['url']}",
					    enabled    => 1,
					    #gpgcheck   => 1,
					    #gpgkey     => 'https://rpms.remirepo.net/RPM-GPG-KEY-remi',
					    priority   => 1,
					}
	        	}
	        	'rpm':
	        	{
	        		package { "${name}":
					    provider    => 'rpm',
					    ensure      => installed,
					    source		=> "${config['source']}",
					    require 	=> $config['require'],
					}
	        	}
	        	'command':
	        	{
	        		exec { 'remove older libzip':
						command     => 'yum remove -y libzip'
					}
	        	}
	        	'packages':
	        	{
	        		$config['packages'].each |$package| {
			        	if ! defined(Package[$package]) {
			            	package { $package:
			              		ensure => 'installed',
			              		#before => Exec['something'],
			            	}
			          	}
			        }
	        	}
	        	default:
	            {
	                fail($unknown_type)
	            }
	        }
		}
	#}
}
