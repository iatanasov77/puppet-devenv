class vs_devenv::dependencies
{
	if $::operatingsystem == 'centos' and $::operatingsystemmajrelease == '8' {
		package { 'wget':
	        ensure => present,
	    }
	}
}