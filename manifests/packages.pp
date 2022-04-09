class vs_devenv::packages (
    Array $packages         = [],
) {
    $packages.each |String $value| {
     
        case $value
        {
            'gitflow':
            {
                case $operatingsystem 
                {
                    'Debian', 'Ubuntu':
                    {
                        package { 'git-flow':
                            ensure => present,
                        }
                    }
                    'CentOS':
                    {
                    	if $::operatingsystemmajrelease == '8' {
                    	   /* USING ORIGINAL REPO
							wget::fetch { "Download GitFlow Installer":
								source      => "https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh",
								destination => '/tmp/gitflow-installer.sh',
								verbose     => true,
								mode        => '0755',
								cache_dir   => '/var/cache/wget',
							} ->
							Exec { "Install GitFlow":
								command	=> '/tmp/gitflow-installer.sh',
							}
						  */
						
						  /* MY FORKED REPO */
                            wget::fetch { "Download GitFlow Installer":
                                source      => "https://raw.github.com/iatanasov77/gitflow/use_fixed_gitmodules/contrib/gitflow-installer.sh",
                                destination => '/tmp/gitflow-installer.sh',
                                verbose     => true,
                                mode        => '0755',
                                cache_dir   => '/var/cache/wget',
                            } ->
                            Exec { "Install GitFlow":
                                command => '/tmp/gitflow-installer.sh',
                            }
                    	} else {
                    		package { $value:
	                            ensure => present,
	                        }
                    	}
                    }
                    default:
                    {
                        fail( 'Unsupported Operating System' )
                    }
                }
            }
            'gitftp':
            {
                ##############################
                # Download and Install GitFtp
                ##############################
                wget::fetch { "Download git-ftp":
					source      => "https://raw.githubusercontent.com/git-ftp/git-ftp/master/git-ftp",
					destination => '/tmp/git-ftp',
					verbose     => true,
					mode        => 'a+x',
					cache_dir   => '/var/cache/wget',
				}
            }
            default:
            {
                if ! defined(Package[$value]) {
                    package { $value:
                        ensure => present,
                    }
                }
            }
        }
    }
}
