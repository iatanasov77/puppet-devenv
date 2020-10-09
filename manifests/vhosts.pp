class vs_devenv::vhosts (
    String $defaultHost,
    String $defaultDocumentRoot,
    Hash $installedProjects         = {},
    Hash $vhosts                    = {},
    Boolean $dotnetCore             = false,
) {

    vs_lamp::apache_vhost{ "${defaultHost}":
        hostName        => $defaultHost,
        documentRoot    => $defaultDocumentRoot,
        aliases         => [ 
            {
                alias => '/phpmyadmin',
                path  => '/usr/share/phpMyAdmin'
            }
        ],
    }

    $installedProjects.each |String $projectId, Hash $projectConfig| {
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
                        fpmSocket           => $host['fpmSocket'],
                        needRewriteRules    => $needRewriteRules,
                    }
                }
                'DotNet':
                {
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
            
        }
    }
}
