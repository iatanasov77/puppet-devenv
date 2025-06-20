class vs_devenv::subsystems::ms_sql (
    Hash $config    = {},
) {
    class { 'vs_dotnet::ms_sql::install':
        config  => $config,
    }
    
    # Create Databases
    $config['databases'].each |String $key, Hash $db| {
        vs_dotnet::ms_sql::database { $db['name']:
            rootPassword    => $config['rootPassword'],
            dbName          => $db['name'],
            backupFile      => $db['dump'],
        }
    }
}