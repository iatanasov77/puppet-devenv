# Made For CentOs7 only
###############################
class vs_devenv::force::mysql_comunity_repo
{   
    if $::operatingsystem == 'CentOS' and $::operatingsystemmajrelease == '7' 
    {
        Package { 'mysql-community-repo':
            provider    => 'rpm',
            ensure      => installed,
            source      => 'https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm',
        }
        
        yumrepo { 'mysql57-community':
            ensure      => 'present',
            enabled     => true,
            priority    => 50,
            require     => [ Package['remi-release'], Package['yum-plugin-priorities'], Package['mysql-community-repo'] ],
        }
    }
}