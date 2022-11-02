class vs_devenv::install_gui (
    String $guiUrl,
    String $guiRoot,
) {
    Exec { 'Install VankoSoft Projects Gui':
        command => "git clone ${guiUrl} ${guiRoot}",
        
    }
}