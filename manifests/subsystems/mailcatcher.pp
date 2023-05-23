# Manual: https://www.vultr.com/docs/install-mailcatcher-on-centos-7/
######################################################################
class vs_devenv::subsystems::mailcatcher (
    Hash $config    = {},
) {
    $rubyDefaultVersion  = $config['rubyDefaultVersion']
    
    if Boolean( $config['useRvm'] ) and ( ! defined( Class['vs_devenv::subsystems::ruby::rvm'] ) ) {
        class { 'vs_devenv::subsystems::ruby::rvm':
            rubyDefaultVersion => "${rubyDefaultVersion}",
        }
        
        if ! defined(Package['ruby-devel']) {
            package { 'ruby-devel':
                ensure  => present,
                require => Class['vs_devenv::subsystems::ruby::rvm'],
            }
        }
    } else {
        if ! defined(Package['ruby-devel']) {
            package { 'ruby-devel':
                ensure  => present,
            }
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
    
    /*
     * CANNOT START MAILCATCHER SERVICE NOW.
     * START IT AFTER YOU LOGIN IN THE MACHINE
     *
    exec { "Run MailCatcher Service ...":
        command     => "/usr/local/rvm/rubies/ruby-${rubyDefaultVersion}/bin/mailcatcher --ip ${config['ip']}",
        user        => 'vagrant',
        require     => Package['mailcatcher'],
    }
    */
}
