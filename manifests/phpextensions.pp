
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
            
            # Tracer default settings
            trace_format           => '1',
            trace_enable_trigger   => '1',
            trace_output_name      => "${vsConfig['xdebug']['trace_output_name']}",
            trace_output_dir       => "${vsConfig['xdebug']['trace_output_dir']}",
            
            # Profiler default settings
            profiler_enable        => "${vsConfig['xdebug']['profiler_enable']}",
            profiler_enable_trigger=> '1',
            profiler_output_name   => "${vsConfig['xdebug']['profiler_output_name']}",
            profiler_output_dir    => "${vsConfig['xdebug']['profiler_output_dir']}",
        }
    }
    
    if ( 'mongodb' in $vsConfig['phpModules'] )
    {
        class { 'devenv::mongodb':
            config  => {
                #enable_opcode_cache => 1,
                #shm_size            => '512M',
                #stat                => 0
            }
        }
    }
}
