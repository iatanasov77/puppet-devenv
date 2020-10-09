# Made For CentOs7 only
###############################
class vs_devenv::force::mysql7_repo
{
    
    if $::operatingsystem == 'CentOS' and $::operatingsystemmajrelease == '7' {
    
        # MySql 5.7
        #rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
        #sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
        #yum --enablerepo=mysql57-community install -y mysql-community-server
        
        Package { 'mysql-community-repo':
            provider    => 'rpm',
            ensure      => installed,
            source      => 'https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm',
        }
        
        yumrepo { 'mysql57-community':
            'ensure'   => 'present',
            'enabled'  => true,
            'priority' => 50,
            'require'  => [ Package['remi-release'], Package['yum-plugin-priorities'], Package['mysql-community-repo'] ],
        } ->
        
        /*
        yumrepo { 'mysql-community':
            'ensure'   => 'present',
            'enabled'  => true,
            'priority' => 50,
            'require'  => [ Package['remi-release'], Package['yum-plugin-priorities'], Package['mysql-community-repo'] ],
        } ->
        */
        
        Package { 'mysql-community-server':
            'ensure'   => 'present',
        }
    }
    
}