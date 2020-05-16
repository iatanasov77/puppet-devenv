class devenv::tools
{
    #case $operatingsystem   'RedHat', 'CentOS', 'Fedora'
    
	$vsConfig['packages'].each |Integer $index, String $value| {
     
        case $value
        {
        	'git':
        	{
        		require git
        		
        		git::config { 'user.name':
					value => $vsConfig['git']['userName'],
					user    => 'vagrant',
				}
				git::config { 'user.email':
					value => $vsConfig['git']['userEmail'],
					user    => 'vagrant',
				}
        	}
            'phpbrew':
            {
                class { 'phpbrew':
                   system_wide => $vsConfig['phpbrew']['system_wide'],
                   additional_dependencies => $vsConfig['phpbrew']['additional_dependencies']
                }
                
                $vsConfig['phpbrew']['install'].each |Integer $index, String $value| {
                    phpbrew::install { $value: 
                       
                    }
                }
            }
            'gitflow':
            {
                case $operatingsystem 
                {
                    'Debian', 'Ubuntu':
                    {
                        package { 'git-flow':
                            ensure => present,
                        }
                    }
                    default:
                    {
                        package { $value:
                            ensure => present,
                        }
                    }
                }
            }
            default:
            {
                if ! defined(Package[$value]) {
                    package { $value:
                        ensure => present,
                    }
                }
            }
        }
    }
}
