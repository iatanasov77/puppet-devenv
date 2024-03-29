class vs_devenv::subsystems::composer (
	Hash $config    = {},
) {
	class { '::composer':
		command_name	=> "${config['command']}",
		version			=> "${config['version']}",
		build_deps      => false,
	}
	
	/*
	::composer::config { 'composer-vagrant-config':
	  ensure   => present,
	  user     => 'vagrant',
	  home_dir => '/custom/home/dir',
	}
	*/
}
