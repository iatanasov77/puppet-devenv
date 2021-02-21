class vs_devenv::vhosts (
    String $defaultHost,
    String $defaultDocumentRoot,
    Hash $installedProjects         = {},
    Hash $vhosts                    = {},
    Boolean $sslModule				= false,
    Boolean $dotnetCore             = false,
    Boolean $tomcat             	= false,
    Boolean $python             	= false,
    Boolean $ruby             		= false,
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
        		if $tomcat and $projectConfig['tomcatInstances'] {
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
                	if ( $tomcat ) {
	                    if ( $host['publish'] ) {
	                        file { "${host['documentRoot']}":
	                            ensure  => link,
	                            target  => "${host['publishSrc']}",
	                            mode    => '0777',
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
                }
                
                'JspRewrite':
                {
                	if ( $tomcat ) {
	                    if ( $host['publish'] ) {
	                        file { "${host['documentRoot']}":
	                            ensure  => link,
	                            target  => "${host['publishSrc']}",
	                            mode    => '0777',
	                            require => Class["vs_devenv::tomcat::default"],
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
                }
                
                'Django':
                {
                	if $python {
	                	vs_django::apache_vhost{ "${host['hostName']}":
						    hostName            => $host['hostName'],
	                        documentRoot        => $host['documentRoot'],
						    withSsl				=> ( $host['withSsl'] and $sslModule ),
						    projectPath			=> $projectConfig['projectPath'],
						    venvPath			=> $projectConfig['venvPath'],
						}
					} else {
						notify { "PYTHON IS NOT ENABLED !!!":
					        withpath => false,
					    }
					}
                }
                
                # https://www.pair.com/support/kb/what-is-mod_passenger/
                'Ruby':
                {
                	if $ruby {
	                	vs_lamp::apache_vhost{ "${host['hostName']}":
	                        hostName            => $host['hostName'],
	                        documentRoot        => $host['documentRoot'],
	                        customFragment      => 'RailsEnv development',
	                        needRewriteRules    => Boolean( "false" ),
	                        ssl					=> ( $host['withSsl'] and $sslModule ),
	                    }
	                } else {
	                	notify { "RUBY IS NOT ENABLED !!!":
					        withpath => false,
					    }
	                }
                }
            }
            
        }
    }
}
