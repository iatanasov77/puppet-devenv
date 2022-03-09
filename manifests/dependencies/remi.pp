class vs_devenv::dependencies::remi (
	$yumrepoDefaults,
	String $remiReleaseRpm
) {
	case $::operatingsystem {
    	centos: {
		    if $::operatingsystemmajrelease == '7' {
		    	$remiSafeMirrors	= 'http://cdn.remirepo.net/enterprise/7/safe/mirror'
		    	$requiredPackages	= [ Package['epel-release'], Package['yum-plugin-priorities'] ]
		    } elsif $::operatingsystemmajrelease == '8' {
		    	$remiSafeMirrors	= 'http://cdn.remirepo.net/enterprise/8/safe/x86_64/mirror'
		    	
		    	$requiredPackages    = [ Package['epel-release'] ]
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
