class vs_devenv::frontendtools (
    Hash $frontendtools = {},
) {
    class { 'nodejs':
        version       => "${frontendtools['nodejs']}",
        target_dir    => '/usr/bin',
    }
    
    package { 'yarn':
        provider    => 'npm',
        require     => Class['nodejs']
    }
    
    $frontendtools['tools'].each |String $key, Hash $data| {
     
        case $key
        {
            'gulp':
            {
                package { 'gulp':
                    provider    => 'npm',
                    require     => Class['nodejs']
                }
            }
            
            'angular-cli':
            {
                exec { 'Install Angular CLI':
                    command => '/usr/bin/yarn global add @angular/cli',
                    creates => '/usr/lib/node_modules/@angular/cli/bin/ng',
                    require => Package['yarn']
                }
            }
        }
    }
    
}
