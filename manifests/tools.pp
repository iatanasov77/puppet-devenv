class devenv::tools
{
    #case $operatingsystem   'RedHat', 'CentOS', 'Fedora'
    
	$vsConfig['packages'].each |Integer $index, String $value| {
     
        case $value
        {
            'phpbrew': 
            {
                require phpbrew::pre_init
                require phpbrew
                
                $vsConfig['phpbrewInstall'].each |Integer $index, String $value| {
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
                package { $value:
                    ensure => present,
                }
            }
        }
    }
}
