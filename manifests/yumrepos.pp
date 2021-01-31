
class vs_devenv::yumrepos
{
	if $::operatingsystem == 'centos' and $::operatingsystemmajrelease == '8' {
	   	package { 'dnf-plugins-core':
	        ensure => present,
	    }

		yumrepo { 'PowerTools':
			ensure      => 'present',
			mirrorlist 	=> 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=PowerTools&infra=$infra',
			enabled     => 1,
			gpgcheck 	=> 0,
			require		=> Package['dnf-plugins-core'],
		}
	}
}
