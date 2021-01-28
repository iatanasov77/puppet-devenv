class vs_devenv::vhosts (
    String $defaultHost,
    String $defaultDocumentRoot,
    Hash $installedProjects         = {},
    Hash $vhosts                    = {},
    Boolean $dotnetCore             = false,
    Boolean $sslModule				= false,
) {

    ##################################################
    # Create Vhost for GUI
    ##################################################
    vs_lamp::apache_vhost{ "${defaultHost}":
        hostName        => $defaultHost,
        documentRoot    => $defaultDocumentRoot,
        aliases         => [
            {
                alias => '/phpmyadmin',
                path  => '/usr/share/phpMyAdmin'
            }
        ],
        directories     => [
            {
                'path'              => '/usr/share/phpMyAdmin',
                'allow_override'    => ['All'],
                'Require'           => 'all granted',
            }
        ],
    }
    
    ##################################################
    # Create Vhosts for all installed projects
    ##################################################
    $installedProjects.each |String $projectId, Hash $projectConfig| {
    
    	# Project Dependencies
        case $projectConfig['type']
        {
        	'Java': {
        		if $projectConfig['tomcatInstances'] {
        			# Install Tomcat Instances
        			$projectConfig['tomcatInstances'].each | String $instanceId, Hash $instanceConfig | {
		                tomcat::install { "${instanceConfig['catalinaHome']}":
		                    source_url  => $instanceConfig['sourceUrl'],
		                }
		    
		                vs_devenv::tomcat::instance { "${instanceId}":
		                    catalinaHome    => "${instanceConfig['catalinaHome']}",
		                    catalinaBase    => "${instanceConfig['catalinaBase']}",
		                    serverPort      => $instanceConfig['serverPort'],
		                    connectorPort   => $instanceConfig['connectorPort'],
		                }
		            }
        		}
        	}
        	
        	'Django': {
        		if ! defined( Class["vs_django"] ) {
        			include vs_django
        		}
        	}
        }
    
        # Configure Apache Vhosts
        $projectConfig['hosts'].each | Hash $host | {
            
            if $host['needRewriteRules'] {
                $needRewriteRules = Boolean( $host['needRewriteRules'] )
            } else {
                $needRewriteRules = Boolean( "false" )
            }
        
            case $host['hostType']
            {
                'Lamp':
                {
                	$fpmProxy			= vs_lamp::apache_vhost_fpm_proxy( $host['fpmSocket'] )
                	$hostCustomFragment	= $host['customFragment']
                	if ( $fpmProxy or $hostCustomFragment ) {
                		$customFragment	= "
                			${fpmProxy}
                			${hostCustomFragment}
                		"
                	}
                	
                    vs_lamp::apache_vhost{ "${host['hostName']}":
                        hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
                        customFragment      => $customFragment,
                        needRewriteRules    => $needRewriteRules,
                        ssl					=> ( $host['withSsl'] and $sslModule ),
                    }
                }
                
                'DotNet':
                {
                	if ( $dotnetCore ) {
	                    if ( $host['publish'] ) {
	                        vs_dotnet::sdk_publish{ "Publish ${host['application']}":
	                            application         => $host['application'],
	                            projectName         => $projectId,
	                            projectPath         => $host['dotnetCoreAppPath'],
	                            reverseProxyPort    => $host['reverseProxyPort'],
	                            sdkUser             => 'vagrant',
	                        }
	                    }
	                    
	                    vs_dotnet::apache_vhost{ "${host['hostName']}":
	                        hostName            => $host['hostName'],
	                        documentRoot        => $host['documentRoot'],
	                        reverseProxyPort    => $host['reverseProxyPort'],
	                    }
	                }
                }
                
                'Jsp':
                {
                    if ( $host['publish'] ) {
                        file { "${host['documentRoot']}":
                            ensure  => link,
                            target  => "${host['publishSrc']}",
                            mode    => '0777',
                            require => [
                                Class['vs_devenv::tomcat'],
                                #File['/etc/ssh/sshd_config'],
                            ],
                        }
                    }
    
                    vs_lamp::apache_vhost{ "${host['hostName']}":
                        hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
                        customFragment      => vs_devenv::apache_vhost_jsp( $host['reverseProxyProtocol'], $host['reverseProxyPort'] ),
                        needRewriteRules    => $needRewriteRules,
                    }
                    
                    -> Exec { "Restart Tomcat for host: ${host['hostName']}":
                        command => "service ${host['tomcatService']} restart",
                        require => Service["${host['tomcatService']}"],
                    }
                }
                
                'JspRewrite':
                {
                    if ( $host['publish'] ) {
                        file { "${host['documentRoot']}":
                            ensure  => link,
                            target  => "${host['publishSrc']}",
                            mode    => '0777',
                            require => [
                                Class['vs_devenv::tomcat'],
                                #File['/etc/ssh/sshd_config'],
                            ],
                        }
                    }
                    
                    vs_lamp::apache_vhost{ "${host['hostName']}":
                        hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
                        customFragment      => vs_devenv::apache_vhost_jsp_rewrite( $host['hostName'], $host['tomcatUrl'] ),
                        needRewriteRules    => $needRewriteRules,
                    }
                    
                    -> Exec { "Restart Tomcat for host: ${host['hostName']}":
                        command => "service ${host['tomcatService']} restart",
                        require => Service["${host['tomcatService']}"],
                    }
                }
                
                'Django':
                {
                	class { 'vs_django::virtualenv':
				        hostName    => $host['hostName'],
				        require		=> Class["vs_django"],
				    }
                	$venvPath	= "/var/www/${host['hostName']}/venv"
                	
                	vs_django::apache_vhost (
					    hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
					    configWsgiDaemon	=> vs_django::apache_vhost_wsgi_daemon( $venvPath, $projectConfig['projectPath'] ),
					    configWsgi			=> vs_django::apache_vhost_wsgi( $host['hostName'], $host['documentRoot'] ),
					    withSsl				=> ( $host['withSsl'] and $sslModule ),
					) 
                
                }
            }
            
        }
    }
}
