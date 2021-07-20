class vs_devenv::subsystems::symfony (
	Hash $config    = {},
) {
    Exec { 'Install Symfony CLI':
      command		=> 'curl -sSL https://get.symfony.com/cli/installer | bash',
      environment	=> [ "HOME=/root" ],
    } ->
    Exec { 'Move Symfony CLI globally':
      command	=> 'mv /root/.symfony/bin/symfony /usr/local/bin/symfony'
    } ->
    file { "/usr/local/bin/symfony":
        ensure => present,
        mode   => '0777',
    }
}
