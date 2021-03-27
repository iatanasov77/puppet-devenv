class vs_devenv::dependencies::remi (
	$yumrepoDefaults
) {
	case $::operatingsystem {
    	centos: {
		    if $::operatingsystemmajrelease == '7' {
		    	$remiReleaseRpm		= 'https://rpms.remirepo.net/enterprise/remi-release-7.rpm'
		    	$remiSafeMirrors	= 'http://cdn.remirepo.net/enterprise/7/safe/mirror'
		    	$requiredPackages	= [ Package['epel-release'], Package['yum-plugin-priorities'] ]
		    } elsif $::operatingsystemmajrelease == '8' {
                $redhatReleaseRpm   = 'https://centos.pkgs.org/8/centos-baseos-x86_64/centos-linux-release-8.3-1.2011.el8.noarch.rpm.html'
		    	$remiReleaseRpm		= 'https://rpms.remirepo.net/enterprise/remi-release-8.rpm'
		    	$remiSafeMirrors	= 'http://cdn.remirepo.net/enterprise/8/safe/x86_64/mirror'
		    	$requiredPackages	= [ Package['centos-linux-release'], Package['epel-release'] ]
		    	
		    	Package { 'centos-linux-release':
                    ensure   => 'present',
                    provider => 'yum',
                    require  => Package['epel-release'],
                }
		    }
            
		    if ! defined( Package['remi-release'] ) {
		        Package { 'remi-release':
		            ensure   => 'present',
		            name     => 'remi-release',
		            provider => 'rpm',
		            source   => $remiReleaseRpm,
		            require  => $requiredPackages,
		        }
		    }
		    
		    yumrepo { 'remi-safe':
		        descr      	=> 'Safe Remi RPM repository for Enterprise Linux',
		        mirrorlist	=> $remiSafeMirrors,
		        require  	=> $requiredPackages,
		        *          	=> $yumrepoDefaults,
		    }
		}
	}
}
