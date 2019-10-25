
class devenv::phpextensions
{
    if ( 'apc' in $vsConfig['phpModules'] )
    {
        class { 'devenv::phpapc':
            config  => {
                enable_opcode_cache => 1,
                shm_size            => '512M',
                stat                => 0
            }
        }
    }

    if ( 'xdebug' in $vsConfig['phpModules'] )
    {
        class { 'devenv::xdebug':
            default_enable       => '1',
            remote_enable        => '1',
            remote_handler       => 'dbgp',
            remote_host          => 'localhost',
            remote_port          => '9000',
            remote_autostart     => '1',
        }
    }
    
    /*
    if ( 'intl' in $vsConfig['phpModules'] )
    {
        package { "php${vsConfig['phpVersion']}-intl":
            ensure  => installed,
            require => Package["php${vsConfig['phpVersion']}"],
            notify  => Service["${apachename}"],
        }
    }
    
    if ( 'sqlite' in $vsConfig['phpModules'] )
    {
        package { "php${vsConfig['phpVersion']}-sqlite3":
            ensure  => installed,
            require => Package["php${vsConfig['phpVersion']}"],
            notify  => Service["${apachename}"],
        }
    }
    */
}
