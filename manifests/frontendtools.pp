class devenv::frontendtools
{
    class { 'nodejs':
        version       => 'latest',
        target_dir    => '/usr/bin',
    }
    
    package { 'yarn':
        provider    => 'npm',
        require     => Class['nodejs']
    }
    
    package { 'gulp':
        provider    => 'npm',
        require     => Class['nodejs']
    }
}
