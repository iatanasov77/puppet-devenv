class vs_devenv::dependencies::php7 (
	$phpVersion			= '7.4',
	$yumrepoDefaults
) {
	$phpVersionShort    = regsubst( sprintf( "%.1f", $phpVersion ), '[.]', '', 'G' )
	
	case $::operatingsystem {
    	centos: {
    		$repo               = sprintf( 'remi-php%s', "${phpVersionShort}" )
    		
		    if $::operatingsystemmajrelease == '7' {
		    	$repoMirrors		= "http://cdn.remirepo.net/enterprise/7/php${phpVersionShort}/mirror"
		    	$requiredPackages	= [ Package['remi-release'], Package['yum-plugin-priorities'] ]
		    } elsif $::operatingsystemmajrelease == '8' {
		    	$repoMirrors		= "http://cdn.remirepo.net/enterprise/8/php${phpVersionShort}/x86_64/mirror"
		    	$requiredPackages	= [ Package['remi-release'] ]
		    }
		    
			yumrepo { $repo:
		        descr      	=> "Remi PHP ${phpVersion} RPM repository for Enterprise Linux",
		        mirrorlist	=> $repoMirrors,
		        require  	=> $requiredPackages,
		        *          	=> $yumrepoDefaults,
		    } ->
		    Exec { 'Reset PHP Module':
                command => 'dnf module reset -y php',
            }
            -> Exec { 'Install PHP Module Stream':
                command => "dnf module install -y php:remi-${phpVersion}",
            }
		}
	}
}
