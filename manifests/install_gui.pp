class vs_devenv::install_gui (
    String $guiUrl,
    String $guiRoot,
    Hash $database,
) {
    $guiExists = find_file( $guiRoot )
    if ( ! $guiExists )  {
        Exec { 'Install VankoSoft Projects Gui':
            command => "git clone ${guiUrl} ${guiRoot}",
            
        }
        /*
        mysql::db { $database['name']:
            user     => 'root',
            password => 'vagrant',
            host     => 'myprojects.lh',
            sql      => $database['dump'],
        }
        */
    }
}