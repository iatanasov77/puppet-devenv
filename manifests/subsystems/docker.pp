class vs_devenv::subsystems::docker (
	Hash $config    = {},
) {
	class { 'docker':
        ensure          => 'present',
        version         => 'latest',
        docker_users    => $config['docker_users'],
    }
    
    class {'docker::compose':
        ensure => present,
        #version => '1.9.0',
    }
}
