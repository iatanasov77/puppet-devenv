class vs_devenv::subsystems::django (
	Hash $config    = {},
) {
	class { '::vs_django':
		#stage	=> 'after-main',
		
        #require	=> Class['vs_lamp::apache'],
        #notify  => Class['apache::service'],
    }
}
