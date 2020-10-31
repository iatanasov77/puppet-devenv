class vs_devenv::ansible (
    String $pathRoles,
    String $logPath,
    Array $galaxyRoles = [],
) {

    class { 'ansible':
        ensure           => present,
        roles_path       => "${pathRoles}",
        timeout          => 30,
        log_path         => "${logPath}/ansible.log",
        private_key_file => '/etc/keys',
    }
    
    -> file { "${logPath}":
        ensure => directory,
    }
    -> file  { "${logPath}/ansible.log":
        ensure  =>  file,
        mode    => '0666',
    }
    
    # Install needed 3th party roles from ansible-galaxy
    #######################################################
    $galaxyRoles.each |String $role|
    {
        exec{ "Fetch Role ${role}":
            command => "ansible-galaxy install ${role} -p ${pathRoles} --ignore-errors",
            require => Class['ansible'],
        }
    }
}