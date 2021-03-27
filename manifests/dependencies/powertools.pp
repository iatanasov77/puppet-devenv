class vs_devenv::dependencies::powertools (
    $yumrepoDefaults,
) {
	case $::operatingsystem {
    	centos: {
    		if $::operatingsystemmajrelease == '8' {
				yumrepo { 'PowerTools':
                    descr       => 'Enable PowerTools repository for Enterprise Linux',
                    mirrorlist  => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=PowerTools&infra=$infra',
                    require     => Package['dnf-plugins-core'],
                    *           => $yumrepoDefaults,
                }
			}
		}
	}
}
