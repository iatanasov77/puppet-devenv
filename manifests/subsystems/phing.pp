########################################
# Php Build Tool PHING
########################################
class vs_devenv::subsystems::phing (
	Hash $config    = {},
) {
	/* 
	 * https://codingbee.net/puppet/puppet-modules-the-files-folder
	 */
	Exec { "PhingServerStatus":
		command	=> 'curl -s -o /dev/null -w "%{http_code}" https://www.phing.info/ > /vagrant/vagrant.d/puppet/modules/vs_devenv/files/tmp/phing_server_status',
		creates => "/tmp/phing_server_status",
	}
	wait_for { 'a_minute':
		seconds => 60,
	}
	$status = file( 'vs_devenv/tmp/phing_server_status' )

	if $status == '200' {
	    notify { "INSTALLING PHING ( PHP BUILD TOOL )":
	        withpath => false,
	    }
	    wget::fetch { 'https://www.phing.info/get/phing-latest.phar':
	        destination => "/usr/share/php/",
	        timeout     => 0,
	        verbose     => true,
	    } ->
	    file { '/usr/local/bin/phing':
	        ensure  => link,
	        target  => '/usr/share/php/phing-latest.phar',
	        mode    => '0777',
	    }
	} else {
		notify { "PHING SERVER RETURN STATUS: ${status}":
	        withpath => false,
	    }
	}
}
