############################################################
# RVM Not Work on CentOs 9 BUT It Have Ruby Installed
############################################################
class vs_devenv::subsystems::ruby::rvm (
    String $rubyDefaultVersion  = '2.7.1',
) {
    $dependencies   = ['which','gcc','gcc-c++','make','gettext-devel','expat-devel','zlib-devel','openssl-devel',
                        'perl','cpio','bzip2','libxml2','libxml2-devel','libxslt','libxslt-devel',
                        'readline-devel','patch','libyaml-devel','libffi-devel','libtool','bison']

    Package { $dependencies:
        ensure => present,
    } ->
    Exec { 'Import GPG2 Key for RVM':
      command => "/usr/bin/command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -",
    } ->
    class { '::rvm':
        #version        => '1.29.12',
        signing_keys    => [],
        include_gnupg   => false,
        manage_wget     => false,
        system_users    => ['vagrant'],
    } ->
    rvm_system_ruby {
        "ruby-${rubyDefaultVersion}":
            ensure      => 'present',
            default_use => true;
    } ->
    File { '/usr/bin/ruby':
        ensure  => 'link',
        force   => true,
        target  => '/usr/local/rvm/rubies/ruby-2.7.1/bin/ruby',
    } ->
    File { '/usr/bin/gem':
        ensure  => 'link',
        force   => true,
        target  => '/usr/local/rvm/rubies/ruby-2.7.1/bin/gem',
    }
}