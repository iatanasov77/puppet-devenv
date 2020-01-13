class devenv::lamp
{
	include devenv::apache
	include devenv::mysql
    include devenv::php
    include devenv::phpextensions

    class { '::composer':
        command_name => 'composer',
        target_dir   => '/usr/bin',
        auto_update => true
    }

	class { 'phpmyadmin': }

	include devenv::vhosts
}
