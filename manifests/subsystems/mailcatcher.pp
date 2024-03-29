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
}
