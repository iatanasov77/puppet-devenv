class vs_devenv::packages (
    Array $packages         = [],
    String $gitUserName     = 'undefined_user_name',
    String $gitUserEmail    = 'undefined@example.com',
    String $gitCredentials  = '',
) {
    $packages.each |String $value| {
     
        case $value
        {
        	'git':
        	{
        		require git
        		
        		git::config { 'user.name':
					value => $gitUserName,
					user    => 'vagrant',
				}
				git::config { 'user.email':
					value => $gitUserEmail,
					user    => 'vagrant',
				}
				
				# Download Git Prompt
				wget::fetch { "Download GitPrompt Script":
					source      => "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh",
					destination => '/usr/local/bin/git-prompt.sh',
					verbose     => true,
					mode        => '0777',
					cache_dir   => '/var/cache/wget',
				}
				# Setup Git Prompt
				file_line { 'source_git_prompt':
					path => '/home/vagrant/.bashrc',
					line => 'source /usr/local/bin/git-prompt.sh',
				} ->
				file_line { 'use_git_prompt':
					path => '/home/vagrant/.bashrc',
					line => 'PS1=\'`if [ $? = 0 ]; then echo "\[\e[32m\] ✔ "; else echo "\[\e[31m\] ✘ "; fi`\[\033[01;32m\]\u@\h\[\033[00m\]:\[\e[01;34m\]\w\[\e[00;34m\] `(( $(git status --porcelain 2>/dev/null | wc -l) == 0 )) && echo "\[\e[01;32m\]" || ( (( $(git status --porcelain --untracked-files=no 2>/dev/null | wc -l) > 0 )) && echo "\[\e[01;31m\]" ) || echo "\[\e[01;33m\]"`$(__git_ps1 "(%s)")`echo "\[\e[00m\]"`\$ \'',
				}
				
				# Setup Git Credentials
				file { '/home/vagrant/.git-credentials':
			    	content => "${gitCredentials}",
			    	owner	=> 'vagrant',
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
                    'CentOS':
                    {
                    	if $::operatingsystemmajrelease == '8' {
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
