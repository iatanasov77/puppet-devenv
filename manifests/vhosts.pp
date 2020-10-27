class vs_devenv::vhosts (
    String $defaultHost,
    String $defaultDocumentRoot,
    Hash $installedProjects         = {},
    Hash $vhosts                    = {},
    Boolean $dotnetCore             = false,
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
        
        # Install Tomcat Instances
        if ( $projectConfig['type'] == 'Java' and $projectConfig['tomcatInstances'] ) {
            $projectConfig['tomcatInstances'].each | String $instanceId, Hash $instanceConfig | {
                tomcat::install { "${catalinaHome}":
                    source_url => $sourceUrl,
                }
    
                vs_devenv::tomcat::instance(
                    name            => $instanceId,
                    catalinaHome    => "${instanceConfig['catalinaHome']}",
                    catalinaBase    => "${instanceConfig['catalinaBase']}",
                    serverPort      => $instanceConfig['serverPort'],
                    connectorPort   => $instanceConfig['connectorPort'],
                )
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
                    vs_lamp::apache_vhost{ "${host['hostName']}":
                        hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
                        customFragment      => vs_lamp::apache_vhost_fpm_proxy( $host['fpmSocket'] ),
                        needRewriteRules    => $needRewriteRules,
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
                
                'JSP':
                {
                    vs_lamp::apache_vhost{ "${host['hostName']}":
                        hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
                        customFragment      => vs_devenv::apache_vhost_jsp( $host['reverseProxyPort'] ),
                        needRewriteRules    => $needRewriteRules,
                    }
                }
                
            }
            
        }
    }
}
