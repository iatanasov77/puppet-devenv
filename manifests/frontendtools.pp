class devenv::frontendtools
{
    class { 'nodejs':
        version       => 'latest',
        target_dir    => '/usr/bin',
    }
    
    package { 'yarn':
        provider    => 'npm',
        require     => Class['nodejs']
    }
    
    package { 'gulp':
        provider    => 'npm',
        require     => Class['nodejs']
    }
    
    if ( 'angular-cli' in $vsConfig['subsystems'] ) {
        exec { 'Install Angular CLI':
            command => '/usr/bin/yarn global add @angular/cli',
            creates => '/usr/lib/node_modules/@angular/cli/bin/ng',
            require => Package['yarn']
        }
    }
}
