# Made For CentOs7 only
###############################
class vs_devenv::force::php7_repo
{
	$phpVersionShort    = regsubst( sprintf( "%.1f", $vsConfig['phpVersion'] ), '[.]', '', 'G' )
	$repo               = sprintf( 'remi-php%s', "${phpVersionShort}" )
	        
    case $::operatingsystem {
    	centos: {
		    if $::operatingsystemmajrelease == '7' {
		    	if ! defined( Package['yum-plugin-priorities'] ) {
		            Package { 'yum-plugin-priorities':
		                ensure => 'present',
		            }
		        }
		        
		    	$remiReleaseRpm		= 'https://rpms.remirepo.net/enterprise/remi-release-7.rpm'
		    	$remiSafeMirrors	= 'http://cdn.remirepo.net/enterprise/7/safe/mirror'
		    	$repoMirrors		= "http://cdn.remirepo.net/enterprise/7/php${phpVersionShort}/mirror"
		    	$requiredPackages	= [ Package['remi-release'], Package['yum-plugin-priorities'] ]
		    } elsif $::operatingsystemmajrelease == '8' {
		    	$remiReleaseRpm		= 'https://rpms.remirepo.net/enterprise/remi-release-8.rpm'
		    	$remiSafeMirrors	= 'http://cdn.remirepo.net/enterprise/8/safe/x86_64/mirror'
		    	$repoMirrors		= "http://cdn.remirepo.net/enterprise/8/php${phpVersionShort}/x86_64/mirror"
		    	$requiredPackages	= [ Package['remi-release'] ]
		    } else {
		    	fail("CentOS support only tested on major version 7 or 8, you are running version '${::operatingsystemmajrelease}'")
		    }

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
	                source   => $remiReleaseRpm,
	                require  => Package['epel-release'],
	            }
	        }
	        
	        $yumrepo_defaults = {
	            'ensure'   => 'present',
	            'enabled'  => true,
	            'gpgcheck' => true,
	            'priority' => 50,
	            'require'  => $requiredPackages,
	        }
	        yumrepo { 'remi-safe':
	            descr      => 'Safe Remi RPM repository for Enterprise Linux',
	            mirrorlist => $remiSafeMirrors,
	            *          => $yumrepo_defaults,
	        }

	        yumrepo { $repo:
	            descr      => "Remi PHP ${vsConfig['phpVersion']} RPM repository for Enterprise Linux",
	            mirrorlist => $repoMirrors,
	            *          => $yumrepo_defaults,
	        }
	    }
	}
}