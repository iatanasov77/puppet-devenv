class vs_devenv::install_gui (
    String $guiUrl,
    String $guiRoot,
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
            environment => [ "COMPOSER_HOME=/home/vagrant" ],
        }
    }
}