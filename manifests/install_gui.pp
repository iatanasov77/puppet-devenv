class vs_devenv::install_gui (
    String $guiUrl,
    String $guiRoot,
) {
    $guiExists = find_file( $guiRoot )
    if ( ! $guiExists )  {
        Exec { 'Install VankoSoft Projects Gui':
            command => "git clone ${guiUrl} ${guiRoot}",
            
        }
    }
}