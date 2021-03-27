# Made For CentOs7 only
###############################
class vs_devenv::dependencies::mysql_comunity_repo
{
	case $::operatingsystem {
    	centos: {
		    if $::operatingsystemmajrelease == '7' {
		    	if ! defined( Package['yum-plugin-priorities'] ) {
		            Package { 'yum-plugin-priorities':
		                ensure => 'present',
		            }
		        }
		        
		    	$repoRpm			= 'https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm'
		    	$repo				= 'mysql57-community'
		    	$requiredPackages	= [ Package['remi-release'], Package['yum-plugin-priorities'], Package['mysql-community-repo'] ]
		    } elsif $::operatingsystemmajrelease == '8' {
		    	$repoRpm			= 'https://repo.mysql.com/mysql80-community-release-el8-1.noarch.rpm'
		    	$repo				= 'mysql80-community'
		    	$requiredPackages	= [ Package['remi-release'], Package['mysql-community-repo'] ]
		    } else {
		    	fail( "CentOS support only tested on major version 7 or 8, you are running version '${::operatingsystemmajrelease}'" )
		    }
		    
	        Package { 'mysql-community-repo':
	            provider    => 'rpm',
	            ensure      => installed,
	            source      => $repoRpm,
	        }
	        
	        yumrepo { "${repo}":
	            ensure      => 'present',
	            enabled     => true,
	            priority    => 50,
	            require     => $requiredPackages,
	        }
	    }
	}
}