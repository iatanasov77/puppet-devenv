class devenv::packages
{
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
