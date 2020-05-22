class devenv::subsystems
{
    $vsConfig['subsystems'].each |Integer $index, String $value| {
     
        case $value
        {
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
            'docker':
            {
                class { 'docker':
                    ensure => present,
                    version => 'latest',
                }
                
                class {'docker::compose':
                    ensure => present,
                    #version => '1.9.0',
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
