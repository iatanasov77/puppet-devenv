class devenv::dotnet::all
{
    ######################################################
    # Docs:
    # -----
    # https://www.mono-project.com/docs/web/fastcgi/
    # https://github.com/dotnet/efcore
    #
    # EntityFramework: https://github.com/dotnet/efcore
    ######################################################
    
    if ! defined(Package['yum-plugin-priorities']) {
        package { 'yum-plugin-priorities':
            ensure => 'present',
        }
    }
    
    $yumrepo_defaults = {
        'ensure'   => 'present',
        'enabled'  => true,
        'gpgcheck' => true,
        'priority' => 50,
        'require'  => [ Package['yum-plugin-priorities'] ],
    }
    
    class { '::devenv::dotnet::sdk':
        yumrepo_defaults  => $yumrepo_defaults,
    }
    
    if ( 'mono' in $vsConfig['subsystems'] ) {
        class { '::devenv::dotnet::mono':
            yumrepo_defaults  => $yumrepo_defaults,
        }
    }
}