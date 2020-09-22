class devenv::dotnet::mono (
    $yumrepo_defaults
) {
    #############################################################################################################################
    # Repo File: https://download.mono-project.com/repo/centos7-stable.repo
    #############################################################################################################################
    yumrepo { 'mono-centos7-stable': 
        name        => 'mono-centos7-stable',
        descr       => "MonoProject Repo for RHEL7",
        baseurl     => 'https://download.mono-project.com/repo/centos7-stable/',
        gpgkey      => 'https://download.mono-project.com/repo/xamarin.gpg',
        *           => $yumrepo_defaults,
    } ->
    
    package { 'mono-complete':
        ensure  => present
    } ->
    
    /* Not needed. Installing by mod_mono
    package { 'xsp':
        ensure  => present
    } ->
    */
    
    # https://www.mono-project.com/docs/web/mod_mono/
    package { 'mod_mono':
        ensure  => present
    }
    
    
}