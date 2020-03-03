class devenv::frontendtools
{
	class { 'nodejs':
		version       => 'latest',
		target_dir    => '/usr/bin',
	}
	
	package { 'yarn':
		provider 	=> 'npm',
		require  	=> Class['nodejs']
	}
	
	::nodejs::npm { 'gulp':
	  ensure    => present,
	  pkg_name  => 'gulp',
	  options   => '--save-dev --no-bin-links',
	  exec_user => 'vagrant',
	  home_dir  => '/home/vagrant'
	}
	
	::nodejs::npm { '@babel/register':
	  ensure    => present,
	  pkg_name  => '@babel/register',
	  options   => '--save-dev --no-bin-links',
	  exec_user => 'vagrant',
	  home_dir  => '/home/vagrant'
	}
}
