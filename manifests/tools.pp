class devenv::tools
{
    #case $operatingsystem   'RedHat', 'CentOS', 'Fedora'
    
	$vsConfig['packages'].each |Integer $index, String $value| {
     
        case $value
        {
            'phpbrew': 
            {
                validate_hash( $vsConfig )
                if has_key( $vsConfig, 'phpbrewPhpVersion' ) {
                    phpbrew::install { $vsConfig['phpbrewPhpVersion']: 
                       
                    }
                } else {
                    phpbrew::install { '7.4.1': 
                        
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
