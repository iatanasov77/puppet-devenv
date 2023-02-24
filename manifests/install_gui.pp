class vs_devenv::install_gui (
    String $guiUrl,
    String $guiRoot,
    Hash $database,
) {
    $guiExists = find_file( $guiRoot )
    if ( ! $guiExists )  {
        Exec { 'Clone VankoSoft Projects Gui':
            command => "git clone ${guiUrl} ${guiRoot}",
        } ->
        Exec { 'Install VankoSoft Projects Gui':
            command     => "${guiRoot}/install.sh",
            cwd         => $guiRoot,
            user        => 'vagrant',
            environment => [ "PHPBREW_ROOT=/opt/phpbrew" ],
            environment => [ "COMPOSER_HOME=/home/vagrant" ],
        } ->
        mysql::db { $database['name']:
            user     => 'root',
            password => 'vagrant',
            host     => 'myprojects.lh',
            sql      => $database['dump'],
        }
    }
}