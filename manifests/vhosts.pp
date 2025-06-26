class vs_devenv::vhosts (
    String $hostIp                  = '0.0.0.0',
    Hash $installedProjects         = {},
    Hash $vhosts                    = {},
    Boolean $sslModule				= false,
    Boolean $dotnetCore             = false,
    Boolean $tomcat             	= false,
    Boolean $python             	= false,
    Boolean $ruby             		= false,
) {
    ##################################################
    # Create Vhosts for all installed projects
    ##################################################
    $installedProjects.each |String $projectId, Hash $projectConfig| {
    
        # Configure Apache Vhosts
        $projectConfig['hosts'].each | Hash $host | {
            
            vs_devenv::system_host{ "${host['hostName']}":
                hostIp      => $hostIp,
                hostName    => $host['hostName'],
            }
            
            if $host['needRewriteRules'] {
                $needRewriteRules = Boolean( $host['needRewriteRules'] )
            } else {
                $needRewriteRules = Boolean( "false" )
            }
        
            if ( 'mercureProxy' in $host and $host['mercureProxy'] ) {
                $mercureProxy   = vs_devenv::apache_vhost_reverse_proxy( '3000', '/hub/', 'http', '127.0.0.1', false )
            }
            
            if ( 'websockets' in $host ) {
                $websockets = $host['websockets'].keys.map |$port| {
                    vs_devenv::apache_vhost_reverse_proxy( $port, $host['websockets'][$port], 'ws', $host['hostName'], false, false )
                }
                $websocketProxy  = join( $websockets, "\n" )
            }
            
            case $host['hostType']
            {
                'Lamp':
                {
                	$fpmProxy			= vs_lamp::apache_vhost_fpm_proxy( $host['fpmSocket'] )
                	$hostCustomFragment	= $host['customFragment']
                	$aliases            = $host['aliases']
                	$directories        = $host['directories']
                	
                	if ( $fpmProxy or $hostCustomFragment or $mercureProxy or $websocketProxy ) {
                		$customFragment	= "
                			${fpmProxy}
                			${hostCustomFragment}
                			${mercureProxy}
                			${websocketProxy}
                		"
                	}
                	
                	if ( 'sslHost' in $host ) {
                	   $sslHost = $host['sslHost']
                	} else {
                	   $sslHost = 'myprojects.lh'
                	}
                	
                    vs_lamp::apache_vhost{ "${host['hostName']}":
                        hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
                        customFragment      => $customFragment,
                        needRewriteRules    => $needRewriteRules,
                        ssl					=> ( $host['withSsl'] and $sslModule ),
                        sslHost             => $sslHost,
                        aliases             => $aliases,
                        directories         => $directories,
                    }
                }
                
                'DotNet':
                {
                    if ( $host['withSsl'] and $sslModule ) {
                        vs_lamp::create_ssl_certificate{ "CreateSelfSignedCertificate_${host['hostName']}":
                            hostName    => $host['hostName'],
                            sslHost     => $host['sslHost'],
                        } ->
                        file { "/etc/pki/tls/certs/${host['sslHost']}.crt":
                            owner   => 'vagrant',
                        } ->
                        file { "/etc/pki/tls/private/${host['sslHost']}.key":
                            owner   => 'vagrant',
                        } ->
                        exec { "CopyAspNetSelfSignedCertificateToTrust_${host['hostName']}":
                            command => "cp /etc/pki/tls/certs/${host['sslHost']}.crt /home/vagrant/.aspnet/dev-certs/trust/"
                        }
                    }
    
                	if ( $dotnetCore and $host['publish'] ) {
                        vs_dotnet::sdk_publish{ "Publish ${host['application']}":
                            application    => $host['application'],
                            description    => $host['description'],
                            projectName    => $projectId,
                            projectPath    => $host['dotnetCoreAppPath'],
                            sdkUser        => 'vagrant',
                            aspnetCoreUrls => $host['aspnetCoreUrls'],
                            ssl            => ( $host['withSsl'] and $sslModule ),
                            sslHost        => $host['sslHost'],
                        }
	                }
	                
	                vs_dotnet::apache_vhost{ "${host['hostName']}":
                        hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
                        reverseProxyPort    => $host['reverseProxyPort'],
                        ssl                 => ( $host['withSsl'] and $sslModule ),
                        sslHost             => $host['sslHost'],
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
                	#$rubyVersion		= "/opt/rvm/wrappers/ruby-${host['rubyVersion']}/ruby"
                	$rubyVersion		= "/usr/local/rvm/wrappers/ruby-${host['rubyVersion']}/ruby"
                	
                	$rubyVersionExists	= find_file( $rubyVersion )
                	#fail( "RUBY ENABLED: \'$ruby\',  RUBY VERSION EXISTS: \'$rubyVersionExists\'" )
                	if ( $ruby ) { # and $rubyVersionExists
	                	vs_lamp::apache_vhost{ "${host['hostName']}":
	                        hostName            => $host['hostName'],
	                        documentRoot        => $host['documentRoot'],
	                        customFragment      => "
	                        						RailsEnv development
	                        						PassengerRuby ${rubyVersion}
	                        						",
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
