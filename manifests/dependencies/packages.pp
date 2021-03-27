class vs_devenv::dependencies::packages
{
    if $::operatingsystem == 'centos' and $::operatingsystemmajrelease == '8' {
        if ! defined(Package['wget']) {
            Package { 'wget':
                ensure => present,
            }
        }
    }
}
