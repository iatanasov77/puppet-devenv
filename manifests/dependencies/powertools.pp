class vs_devenv::dependencies::powertools (
    $yumrepoDefaults,
) {
	case $::operatingsystem {
    	centos: {
    		if $::operatingsystemmajrelease == '8' {
    		    ###############################################################################################
    		    # Install EPEL repository – PowerTools repository & EPEL repository are best friends.
    		    # So enable EPEL repository as well.
    		    # Note: May be Not Need This because is installed with class vs_devenv::dependencies::epel
    		    ###############################################################################################
    		    Exec { 'Install EPEL repository':
                    command => 'dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm',
                }
			}
		}
	}
}
