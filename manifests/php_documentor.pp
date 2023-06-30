class vs_devenv::php_documentor
{
    /* Example: https://github.com/metanorma/plantuml-install/blob/main/centos.sh */
    /* Require Java Runtime */
    Package { 'graphviz':
        ensure   => 'present',
    } ->
    File { '/opt/plantuml':
        ensure  => 'directory',
    } ->
    wget::fetch { 'https://github.com/plantuml/plantuml/releases/download/v1.2023.9/plantuml.jar':
        destination => "/opt/plantuml/",
        timeout     => 0,
        verbose     => true,
    } ->
    Exec { 'Install VankoSoft Projects Gui':
        command     => "printf '#!/bin/sh\nexec java -Djava.awt.headless=true -jar /opt/plantuml/plantuml.jar \"$@\"' > /usr/local/bin/plantuml",
    } ->
    file { '/usr/local/bin/plantuml':
        ensure  => file,
        mode    => '0777',
    } ->
    wget::fetch { 'https://phpdoc.org/phpDocumentor.phar':
        destination => "/usr/local/bin/",
        timeout     => 0,
        verbose     => true,
    } ->
    file { '/usr/local/bin/phpDocumentor.phar':
        ensure  => file,
        mode    => '0777',
    } ->
    file { '/usr/local/bin/phpdoc':
        ensure  => link,
        target  => '/usr/local/bin/phpDocumentor.phar',
        mode    => '0777',
    }
}