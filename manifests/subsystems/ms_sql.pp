class vs_devenv::subsystems::ms_sql (
    Hash $config    = {},
) {
    class { 'vs_dotnet::ms_sql::install':
        config  => $config,
    }
    
    # Create Databases
    $config['databases'].each |String $key, Hash $db| {
        exec { 'Install mssql-tools':
            command     => "sqlcmd -S localhost -U SA -P 'Ophthalamia@123' -q \"exit(CREATE DATABASE ${db['name']})\"",
            require     => [ Class['vs_dotnet::ms_sql::install'] ],
        } ->
        exec { 'Install mssql-tools':
            command     => "sqlcmd -S localhost -U SA -P '${config['rootPassword']}' -q \"exit(RESTORE DATABASE [${db['name']}] FROM DISK='${db['dump']}')\"",
            require     => [ Class['vs_dotnet::ms_sql::install'] ],
        }
    }
}