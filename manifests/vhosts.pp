class vs_devenv::vhosts (
    String $defaultHost,
    String $defaultDocumentRoot,
    Hash $installedProjects         = {},
    Hash $vhosts                    = {},
    Boolean $dotnetCore             = false,
) {

    class { '::vs_lamp::apache_vhost':
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
            
            if $host['needRewriteRules'] == Undef {
                $needRewriteRules = False
            } else
                $needRewriteRules = Boolean( $host['needRewriteRules'] )
            }
        
            case $host['hostType']
            {
                'Lamp':
                {
                    class { '::vs_lamp::apache_vhost':
                        hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
                        fpmSocket           => $host['fpmSocket'],
                        needRewriteRules    => $needRewriteRules,
                    }
                }
                'DotNet':
                {
                    class { '::vs_dotnet::sdk_publish':
                        projectName         => $projectId,
                        projectPath         => $host['dotnetCoreAppPath'],
                        reverseProxyPort    => $host['reverseProxyPort'],
                        sdkUser             => 'vagrant',
                    }
                    class { '::vs_dotnet::apache_vhost':
                        hostName            => $host['hostName'],
                        documentRoot        => $host['documentRoot'],
                        reverseProxyPort    => $host['reverseProxyPort'],
                    }
                }
            }
            
        }
    }
}
