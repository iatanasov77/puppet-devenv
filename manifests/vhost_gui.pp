class vs_devenv::vhost_gui (
    String $hostIp = '0.0.0.0',
    String $defaultHost,
    String $guiRoot,
) {

    ##################################################
    # Create Vhosts for GUI
    ##################################################
    vs_lamp::apache_vhost{ "${defaultHost}":
        hostName        => $defaultHost,
        documentRoot    => "${guiRoot}/public/my-web-projects",
        aliases         => [
            {
                alias => '/build',
                path  => "${guiRoot}/public/shared_assets/build"
            },
            {
                alias => '/phpmyadmin',
                path  => '/usr/share/phpMyAdmin'
            }
        ],
        directories     => [
            {
                'path'              => "${guiRoot}/public/shared_assets/build",
                'allow_override'    => ['All'],
                'Require'           => 'all granted',
            },
            {
                'path'              => '/usr/share/phpMyAdmin',
                'allow_override'    => ['All'],
                'Require'           => 'all granted',
            }
        ],
    }
    
    vs_lamp::apache_vhost{ "admin.${defaultHost}":
        hostName        => "admin.${defaultHost}",
        documentRoot    => "${guiRoot}/public/admin-panel",
    }
}
