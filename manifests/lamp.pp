class devenv::lamp
{
    

    class { '::vs_lamp':
        phpVersion                  => "${vsConfig['phpVersion']}",
        apacheModules               => $vsConfig['apacheModules'],
        
        mysqlService                => 'mysqld',
        mysqllRootPassword          => 'vagrant',

        phpModules                  => $vsConfig['phpModules'],
        phpunit                     => $vsConfig['phpunit'],
        
        phpSettings                     => {
            'PHP/memory_limit'        => '-1',
            'Date/date.timezone'      => 'Europe/Sofia',
            'PHP/post_max_size'       => '64M',
            'PHP/upload_max_filesize' => '64M',
            'PHAR/phar.readonly'      => 'Off',
        },
        
        xdebugTraceOutputName       => "${vsConfig['xdebug']['trace_output_name']}",
        xdebugTraceOutputDir        => "${vsConfig['xdebug']['trace_output_dir']}",
        xdebugProfilerEnable        => "${vsConfig['xdebug']['profiler_enable']}",
        xdebugProfilerOutputName    => "${vsConfig['xdebug']['profiler_output_name']}",
        xdebugProfilerOutputDir     => "${vsConfig['xdebug']['profiler_output_dir']}",
    }

    

	include devenv::vhosts
}
