
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
            remote_autostart     => '0',
        }
    }
}
