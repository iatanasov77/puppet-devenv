# Manual: https://www.vultr.com/docs/install-mailcatcher-on-centos-7/
######################################################################
class vs_devenv::subsystems::mailcatcher (
    Hash $config    = {},
) {
    if ! defined(Package['ruby-devel']) {
        package { 'ruby-devel':
            ensure  => present,
        }
    }
    
    if ! defined(Package['sqlite-devel']) {
        package { 'sqlite-devel':
            ensure => present,
        }
    }

    package { 'mailcatcher':
        provider  => gem,
        ensure    => installed,
        require   => Package['ruby-devel'],
    }
    
    File { "mailcatcher.service":
        ensure  => file,
        path    => "/etc/systemd/system/mailcatcher.service",
        content => template( 'vs_devenv/mailcatcher.service.erb' ),
        mode    => '0644',
        require => Package['mailcatcher'],
    }
    
    Service { "mailcatcher":
        ensure  => 'running',
        enable  => true,
        require => File['mailcatcher.service'],
        notify  => [
            Exec['daemon-reload'],
        ],
    }
}
