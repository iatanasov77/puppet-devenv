class vs_devenv::dependencies
{
	if $::operatingsystem == 'centos' and $::operatingsystemmajrelease == '8' {
		yumrepo { 'PowerTools':
			ensure      => 'present',
			enabled     => true,
		}
		
		package { 'wget':
	        ensure => present,
	    }
	}
}