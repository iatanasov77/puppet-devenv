
class devenv::phpextensions
{
    if ( 'intl' in $facts['devenv_modules'] )
    {
        package { "php${phpVersion}-intl":
            ensure  => installed,
            require => Package["php${phpVersion}"],
            notify  => Service["${apachename}"],
        }
    }
    
    if ( 'sqlite' in $facts['devenv_modules'] )
    {
        package { "php${phpVersion}-sqlite3":
            ensure  => installed,
            require => Package["php${phpVersion}"],
            notify  => Service["${apachename}"],
        }
    }
    
    if ( 'xdebug' in $facts['devenv_modules'] )
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
    
    if ( 'apc' in $facts['devenv_modules'] )
    {
        class { 'devenv::phpapc':
            config  => {
                enable_opcode_cache => 1,
                shm_size            => '512M',
                stat                => 0
            }
        }
    }
}
