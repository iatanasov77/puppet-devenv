class devenv::packages
{
    $vsConfig['packages'].each |Integer $index, String $value| {
     
        case $value
        {
        	'git':
        	{
        		require git
        		
        		git::config { 'user.name':
					value => $vsConfig['git']['userName'],
					user    => 'vagrant',
				}
				git::config { 'user.email':
					value => $vsConfig['git']['userEmail'],
					user    => 'vagrant',
				}
        	}
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
                    default:
                    {
                        package { $value:
                            ensure => present,
                        }
                    }
                }
            }
            'gitftp':
            {
                ##############################
                # Download and Install GitFtp
                ##############################
                exec { 'download git-ftp':
                    command => '/usr/bin/wget -P /tmp https://raw.githubusercontent.com/git-ftp/git-ftp/master/git-ftp',
                    creates => '/tmp/git-ftp',
                }
                
                file { '/bin/git-ftp':
                    source  => '/tmp/git-ftp',
                    mode    => 'a+x',
                    require => Exec['download git-ftp'],
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
