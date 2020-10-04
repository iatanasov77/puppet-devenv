class vs_devenv::subsystems (
    Hash $subsystems    = {},
    Hash $phpbrewConfig = {
        'system_wide'               => true,
        'additional_dependencies'   => [],
        'install'                   => [],
    },
) {
    $subsystems.each |String $subsysKey, Hash $subsys| {
     
        case $subsysKey
        {
            'angular-cli': {}
            
            'dotnet':
            {
                class { '::vs_dotnet':
                    sdkVersion  => $subsys['dotnet_core'],
                    sdkUser     => $subsys['sdkUser'],
                    sdks        => $subsys['sdks'],
                    mono        => ( $subsys['mono'] == Undef ),
                }
            }
            
            'phpbrew':
            {
                file_line { "PHPBREW_ROOT_IS_REQUIRED":
                    ensure  => present,
                    line    => "PHPBREW_ROOT=/opt/phpbrew",
                    path    => "/etc/environment",
                }
                
                class { 'phpbrew':
                   system_wide => $phpbrewConfig['system_wide'],
                   additional_dependencies => $phpbrewConfig['additional_dependencies']
                }
                
                exec { "Fetch Known Versions Json ...":
                    command     => '/usr/bin/phpbrew known --more',
                    environment => [ "PHPBREW_ROOT=/opt/phpbrew" ],
                    require     => Class['phpbrew'],
                }
                
                $phpbrewConfig['install'].each |Integer $index, String $value| {
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
