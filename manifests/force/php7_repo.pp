# Made For CentOs7 only
###############################
class vs_devenv::force::php7_repo
{
    
    if $::operatingsystem == 'CentOS' and $::operatingsystemmajrelease == '7' {
    
        if ! defined( Package['epel-release'] ) {
            Exec { 'Import RPM GPG KEYS':
                command => 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*',
            } ->
            Package { 'epel-release':
                ensure   => 'present',
                provider => 'yum',
            }
        }
    
        if ! defined( Package['remi-release'] ) {
            Package { 'remi-release':
                ensure   => 'present',
                name     => 'remi-release',
                provider => 'rpm',
                source   => 'https://rpms.remirepo.net/enterprise/remi-release-7.rpm',
                require  => Package['epel-release'],
            }
        }
        
        if ! defined( Package['yum-plugin-priorities'] ) {
            Package { 'yum-plugin-priorities':
                ensure => 'present',
            }
        }
        
        $yumrepo_defaults = {
            'ensure'   => 'present',
            'enabled'  => true,
            'gpgcheck' => true,
            'priority' => 50,
            'require'  => [ Package['remi-release'], Package['yum-plugin-priorities'] ],
        }
        yumrepo { 'remi-safe':
            descr      => 'Safe Remi RPM repository for Enterprise Linux 7',
            mirrorlist => 'http://cdn.remirepo.net/enterprise/7/safe/mirror',
            *          => $yumrepo_defaults,
        }
    
        $phpVersionShort    = regsubst( sprintf( "%.1f", $vsConfig['phpVersion'] ), '[.]', '', 'G' )
        $repo               = sprintf( 'remi-php%s', "${phpVersionShort}" )
        
        # Test String
        #fail( "Repo String: ${phpVersionShort}" )
        
        yumrepo { $repo:
            descr      => "Remi PHP ${vsConfig['phpVersion']} RPM repository for Enterprise Linux 7",
            mirrorlist => "http://cdn.remirepo.net/enterprise/7/php${phpVersionShort}/mirror",
            *          => $yumrepo_defaults,
        } 
    }
}