class vs_devenv (
    String $defaultHost,
    String $defaultDocumentRoot,
    Hash $vhosts                        = {},
    
    Hash $subsystems                    = {},
    Hash $phpbrewConfig                 = {
        'system_wide'               => true,
        'additional_dependencies'   => [],
        'install'                   => [],
    },
    
    Array $packages                     = [],
    String $gitUserName                 = 'undefined_user_name',
    String $gitUserEmail                = 'undefined@example.com',


    Array $apacheModules                = [],
    String $phpVersion                  = '7.2',
    
    String $mysqlService                = 'mysqld',
    String $mysqllRootPassword          = 'vagrant',

    Array $phpModules                   = [],
    Boolean $phpunit                    = false,
    
    Hash $phpSettings                   = {},
    
    String $xdebugTraceOutputName       = 'trace.out',
    String $xdebugTraceOutputDir        = '/home/nickname/Xdebug',
    String $xdebugProfilerEnable        = '0',
    String $xdebugProfilerOutputName    = 'cachegrind.out',
    String $xdebugProfilerOutputDir     = '/home/nickname/Xdebug',
    
    Hash $vstools                       = {},
) {
    class { '::vs_devenv::packages':
        packages        => $packages,
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
    }

    class { '::vs_lamp':
        phpVersion                  => $phpVersion,
        apacheModules               => $vsConfig['apacheModules'],
        
        mysqlService                => $mysqlService,
        mysqllRootPassword          => $mysqllRootPassword,

        phpModules                  => $phpModules,
        phpunit                     => $phpunit,
        
        phpSettings                 => $phpSettings,
        
        xdebugTraceOutputName       => $xdebugTraceOutputName,
        xdebugTraceOutputDir        => $xdebugTraceOutputDir,
        xdebugProfilerEnable        => $xdebugProfilerEnable,
        xdebugProfilerOutputName    => $xdebugProfilerOutputName,
        xdebugProfilerOutputDir     => $xdebugProfilerOutputDir,
    }

    class { '::vs_devenv::vhosts':
        defaultHost         => "${hostname}",
        defaultDocumentRoot => '/vagrant/gui_symfony/public'
        vhosts              = {},
        dotnetCore          => ( 'dotnet' in $subsystems )
    )
    
    class { '::vs_devenv::subsystems':
        subsystems      => $subsystems,
        phpbrewConfig   => $phpbrewConfig,
    )
    
    class { '::vs_devenv::vstools':
        vstools => $vstools,
    )

    class { '::vs_devenv::frontendtools':
        angularCli => ( 'angular-cli' in $subsystems ),
    )
}
