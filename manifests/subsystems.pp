class devenv::subsystems
{
    $vsConfig['subsystems'].each |Integer $index, String $value| {
     
        case $value
        {
            'dotnet_core': {}
            'mono': {}
            'dotnet':
            {
                # Require Big Refactoring when to install DotnetCore and When Mono
                include devenv::dotnet::all
            }
            'phpbrew':
            {
                file_line { "PHPBREW_ROOT_IS_REQUIRED":
                    ensure  => present,
                    line    => "PHPBREW_ROOT=/opt/phpbrew",
                    path    => "/etc/environment",
                }
                
                class { 'phpbrew':
                   system_wide => $vsConfig['phpbrew']['system_wide'],
                   additional_dependencies => $vsConfig['phpbrew']['additional_dependencies']
                }
                
                exec { "Fetch Known Versions Json ...":
                    command     => '/usr/bin/phpbrew known --more',
                    environment => [ "PHPBREW_ROOT=/opt/phpbrew" ],
                    require     => Class['phpbrew'],
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
